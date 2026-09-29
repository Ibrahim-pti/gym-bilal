import 'package:rasedi_flutter_sdk/rasedi_flutter_sdk.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gym_base/core/config/rasedi_config.dart';

class RasediPaymentService {
  static final RasediPaymentService _instance = RasediPaymentService._internal();
  factory RasediPaymentService() => _instance;
  RasediPaymentService._internal();

  late final RasediClient _client = RasediClient(
    RasediConfig.privateKey,
    RasediConfig.secretKey,
  );

  RasediClient get client => _client;

  Future<CreatePaymentResponse> initiatePlanPayment({
    required String planTitle,
    required String rawAmount,
    required String duration,
    List<Gateway>? preferredGateways,
  }) async {
    final payload = CreatePaymentPayload(
      amount: rawAmount,
      title: "Bilal Gym - $planTitle",
      description: "Membership subscription to $planTitle ($duration)",
      gateways: preferredGateways ?? [
        Gateway.FIB,
        Gateway.FAST_PAY,
        Gateway.ZAIN,
        Gateway.ASIA_PAY,
        Gateway.CREDIT_CARD,
      ],
      redirectUrl: "https://gymbilal.com/payment/callback",
      callbackUrl: "https://gymbilal.com/payment/webhook",
      collectFeeFromCustomer: false,
      collectCustomerEmail: false,
      collectCustomerPhoneNumber: false,
    );

    return await _client.createPayment(payload);
  }

  Future<bool> openPaymentUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.inAppWebView);
      }
      return await launchUrl(uri, mode: LaunchMode.inAppWebView);
    } catch (e) {
      return false;
    }
  }

  Future<PaymentStatus> checkPaymentStatus(String referenceCode) async {
    final res = await _client.getPaymentByReference(referenceCode);
    return res.body.status;
  }
}
