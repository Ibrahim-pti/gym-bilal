import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gym_base/core/theme/app_colors.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Background processor — no UI WebView shown.
/// Silently loads Rasedi checkout, intercepts the gateway deep link,
/// and opens the banking app (FIB, FastPay, etc.) directly.
class RasediNativePaymentProcessor extends StatefulWidget {
  final String checkoutUrl;
  final String referenceCode;
  final String planTitle;
  final String amount;
  final String gatewayName; // e.g. 'FIB Bank', 'FastPay'
  final bool isFastpay;     // show QR + countdown UI for Fastpay
  final VoidCallback? onPaymentSuccess;
  final VoidCallback onPaymentClosed; // called when user taps close/back

  const RasediNativePaymentProcessor({
    super.key,
    required this.checkoutUrl,
    required this.referenceCode,
    required this.planTitle,
    required this.amount,
    required this.gatewayName,
    required this.onPaymentClosed,
    this.isFastpay = false,
    this.onPaymentSuccess,
  });

  @override
  State<RasediNativePaymentProcessor> createState() =>
      _RasediNativePaymentProcessorState();
}

class _RasediNativePaymentProcessorState
    extends State<RasediNativePaymentProcessor>
    with SingleTickerProviderStateMixin {
  WebViewController? _controller;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  String _statusText = 'Connecting to payment gateway...';
  bool _appLinkOpened = false;
  bool _showFallback = false;
  Timer? _fallbackTimer;

  // Fastpay countdown (5 minutes = 300 seconds)
  int _countdownSeconds = 300;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _initBackgroundWebView();
    });

    // Fastpay: start 5-minute countdown
    if (widget.isFastpay) {
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) { t.cancel(); return; }
        setState(() {
          if (_countdownSeconds > 0) {
            _countdownSeconds--;
          } else {
            t.cancel();
          }
        });
      });
    } else {
      // Fallback: if app link not detected in 8s, show manual button
      _fallbackTimer = Timer(const Duration(seconds: 8), () {
        if (mounted && !_appLinkOpened) {
          setState(() {
            _showFallback = true;
            _statusText = 'Tap below to open payment page';
          });
        }
      });
    }
  }

  void _initBackgroundWebView() {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterBridge',
        onMessageReceived: (JavaScriptMessage msg) {
          _handleDeepLink(msg.message);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            _setState('Preparing your payment session...');
            _injectAutoClickScript();
          },
          onNavigationRequest: (req) {
            final url = req.url;
            if (_isAppDeepLink(url)) {
              _handleDeepLink(url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));

    setState(() => _controller = controller);
  }

  bool _isAppDeepLink(String url) {
    if (url.startsWith('http') || url.startsWith('about') ||
        url.startsWith('javascript') || url.startsWith('blob')) {
      return false;
    }
    return true;
  }

  void _handleDeepLink(String url) async {
    if (_appLinkOpened) return;
    _appLinkOpened = true;
    _setState('Opening ${widget.gatewayName} app...');

    try {
      final uri = Uri.parse(url.trim());
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (mounted) {
          _setState('Waiting for payment confirmation...');
        }
      } else {
        // App not installed — fallback to open checkout in external browser
        final checkoutUri = Uri.parse(widget.checkoutUrl);
        await launchUrl(checkoutUri, mode: LaunchMode.externalApplication);
        if (mounted) _setState('Waiting for payment confirmation...');
      }
    } catch (e) {
      _appLinkOpened = false;
      _setState('Error opening app. Try again.');
    }
  }

  void _setState(String text) {
    if (mounted) setState(() => _statusText = text);
  }

  void _injectAutoClickScript() {
    _controller?.runJavaScript(r"""
      (function() {
        // Intercept XHR responses for FIB/app links in JSON
        var _xhrOpen = XMLHttpRequest.prototype.open;
        var _xhrSend = XMLHttpRequest.prototype.send;
        XMLHttpRequest.prototype.open = function(m, u) {
          this._url = u;
          return _xhrOpen.apply(this, arguments);
        };
        XMLHttpRequest.prototype.send = function() {
          this.addEventListener('load', function() {
            try {
              var data = JSON.parse(this.responseText);
              var link = data.businessAppLink || data.personalAppLink ||
                         data.appLink || data.deepLink || data.fib_link ||
                         (data.data && (data.data.businessAppLink || data.data.personalAppLink));
              if (link && !link.startsWith('http')) {
                FlutterBridge.postMessage(link);
              }
            } catch(e) {}
          });
          return _xhrSend.apply(this, arguments);
        };

        // Intercept fetch for FIB links
        var _origFetch = window.fetch;
        window.fetch = function() {
          return _origFetch.apply(this, arguments).then(function(res) {
            res.clone().json().then(function(data) {
              try {
                var link = data.businessAppLink || data.personalAppLink ||
                           data.appLink || data.deepLink ||
                           (data.data && (data.data.businessAppLink || data.data.personalAppLink));
                if (link && !link.startsWith('http')) {
                  FlutterBridge.postMessage(link);
                }
              } catch(e) {}
            }).catch(function(){});
            return res;
          });
        };

        // Intercept link clicks (app deep links)
        document.addEventListener('click', function(e) {
          var el = e.target;
          while (el && el.tagName !== 'A') { el = el.parentElement; }
          if (!el) return;
          var href = el.getAttribute('href') || '';
          if (href && !href.startsWith('http') && !href.startsWith('#') && href.length > 4) {
            e.preventDefault(); e.stopPropagation();
            FlutterBridge.postMessage(href);
          }
        }, true);

        // Intercept window.open
        var _origOpen = window.open;
        window.open = function(url, t, f) {
          if (url && !url.startsWith('http') && url.length > 4) {
            FlutterBridge.postMessage(url); return null;
          }
          return _origOpen.apply(this, arguments);
        };

        // Retry auto-click every 600ms up to 10 attempts
        var attempts = 0;
        var tryClick = function() {
          attempts++;
          var selectors = ['button', '[type="submit"]', '[class*="pay"]', '[class*="btn"]'];
          var found = false;
          for (var s = 0; s < selectors.length; s++) {
            var els = document.querySelectorAll(selectors[s]);
            for (var i = 0; i < els.length; i++) {
              var txt = (els[i].textContent || '').toLowerCase();
              if (txt.includes('pay') || txt.includes('proceed') || txt.includes('continue')) {
                els[i].click();
                found = true;
                break;
              }
            }
            if (found) break;
          }
          if (!found && attempts < 10) setTimeout(tryClick, 600);
        };
        setTimeout(tryClick, 800);
      })();
    """);
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    _countdownTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  String get _countdownFormatted {
    final m = _countdownSeconds ~/ 60;
    final s = _countdownSeconds % 60;
    return '${m.toString().padLeft(2, '0')}m ${s.toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: widget.isFastpay ? Colors.white : const Color(0xFF0F1116),
        body: Stack(
          children: [
            // Hidden background WebView (size 1x1, invisible)
            if (_controller != null)
              Positioned(
                left: -9999,
                top: -9999,
                width: 1,
                height: 1,
                child: WebViewWidget(controller: _controller!),
              ),

            // ─────────────────────────────────────────────
            // FASTPAY UI — matches image 1 (white, QR, timer)
            // ─────────────────────────────────────────────
            if (widget.isFastpay)
              SafeArea(
                child: Column(
                  children: [
                    // Top bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: widget.onPaymentClosed,
                            child: const Icon(Icons.close, color: Colors.black54, size: 22),
                          ),
                          const Text(
                            'Fastpay',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 22),
                        ],
                      ),
                    ),

                    Divider(color: Colors.black.withValues(alpha: 0.08), height: 1),
                    const SizedBox(height: 24),

                    // QR Card
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7F7F7),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.07),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Instructions text
                                  Text(
                                    'کۆدی QR یان دوگمەی خوارەوە بەکاریھێنە بۆ پارەدانی ${widget.amount} د.ع تەواوکردنی پڕۆسەی پارەدان.',
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      color: Colors.black.withValues(alpha: 0.7),
                                      fontSize: 13,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Countdown timer
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'ماوەی کۆدی QR بەسەردەچێت لە: ',
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                          color: Colors.black.withValues(alpha: 0.55),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        _countdownFormatted,
                                        style: TextStyle(
                                          color: _countdownSeconds > 30
                                              ? const Color(0xFFE50046)
                                              : Colors.redAccent,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // QR Code
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: QrImageView(
                                      data: widget.checkoutUrl,
                                      version: QrVersions.auto,
                                      size: 220,
                                      backgroundColor: Colors.white,
                                      eyeStyle: const QrEyeStyle(
                                        eyeShape: QrEyeShape.square,
                                        color: Colors.black,
                                      ),
                                      dataModuleStyle: const QrDataModuleStyle(
                                        dataModuleShape: QrDataModuleShape.square,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bottom button — بڕۆ بۆ Fastpay
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE50046),
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor: const Color(0xFFE50046).withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () async {
                            final uri = Uri.parse(widget.checkoutUrl);
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          },
                          child: const Text(
                            'بڕۆ بۆ Fastpay',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // ─────────────────────────────────────────────
            // DEFAULT UI — FIB / Card (dark loading screen)
            // ─────────────────────────────────────────────
            if (!widget.isFastpay)
              SafeArea(
                child: Column(
                  children: [
                    // Top bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close_rounded, color: Colors.white60),
                            onPressed: widget.onPaymentClosed,
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.lock_outline_rounded, size: 11, color: AppColors.primary),
                                SizedBox(width: 5),
                                Text('Secured by Rasedi',
                                    style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Animated gateway icon
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) => Opacity(
                        opacity: _pulseAnimation.value,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withValues(alpha: 0.1),
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.2 * _pulseAnimation.value),
                                blurRadius: 30,
                                spreadRadius: 8,
                              )
                            ],
                          ),
                          child: const Center(
                            child: Icon(Icons.payment_rounded, color: AppColors.primary, size: 42),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Gateway name
                    Text(
                      widget.gatewayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.amount} IQD',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Status text
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary.withValues(alpha: 0.8),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              _statusText,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Fallback button (shown after 8s if auto-detect fails)
                    if (_showFallback) ...[
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              shadowColor: AppColors.primary.withValues(alpha: 0.4),
                            ),
                            icon: const Icon(Icons.open_in_new_rounded, size: 18),
                            label: Text(
                              'Open ${widget.gatewayName} Payment',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                            ),
                            onPressed: () async {
                              final uri = Uri.parse(widget.checkoutUrl);
                              await launchUrl(uri, mode: LaunchMode.inAppWebView);
                            },
                          ),
                        ),
                      ),
                    ],

                    const Spacer(),

                    // Info text
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                      child: Text(
                        'After completing payment in ${widget.gatewayName}, return here to confirm your membership.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.35),
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
