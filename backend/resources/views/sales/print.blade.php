<!DOCTYPE html>
<html lang="ku" dir="rtl">
<head>
    <meta charset="UTF-8">
    <title>پسوولەی فرۆشتن #{{ $sale->id }}</title>
    <style>
        @media print {
            @page { margin: 0; size: 80mm 200mm; }
            body { margin: 0; padding: 5mm; }
            .no-print { display: none; }
        }
        body {
            font-family: 'Arial', sans-serif;
            width: 70mm;
            margin: 0 auto;
            padding: 10px;
            font-size: 12px;
            color: #000;
        }
        .header { text-align: center; margin-bottom: 15px; border-bottom: 1px dashed #000; padding-bottom: 10px; }
        .gym-name { font-size: 18px; font-weight: bold; margin-bottom: 5px; }
        .details { margin-bottom: 15px; }
        .details div { display: flex; justify-content: space-between; margin-bottom: 3px; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 15px; }
        th { text-align: right; border-bottom: 1px solid #000; padding: 5px 0; font-size: 11px; }
        td { padding: 5px 0; font-size: 11px; vertical-align: top; }
        .totals { border-top: 1px dashed #000; padding-top: 10px; }
        .totals div { display: flex; justify-content: space-between; margin-bottom: 5px; }
        .total-row { font-size: 14px; font-weight: bold; margin-top: 5px; border-top: 1px solid #000; padding-top: 5px; }
        .footer { text-align: center; margin-top: 20px; font-size: 10px; border-top: 1px dashed #000; padding-top: 10px; }
        .btn-print {
            background: #000; color: #fff; border: none; padding: 10px 20px;
            cursor: pointer; display: block; margin: 20px auto; border-radius: 5px;
        }
    </style>
</head>
<body>
    <button class="btn-print no-print" onclick="window.print()">چاپکردنی پسوولە</button>

    <div class="header">
        <div class="gym-name">{{ $settings['gym_name'] ?? 'GYM SYSTEM' }}</div>
        <div>{{ $settings['gym_phone'] ?? '' }}</div>
        <div>پسوولەی فرۆشتن</div>
    </div>

    <div class="details">
        <div><span>ژمارەی پسوولە:</span> <span>#{{ $sale->id }}</span></div>
        <div><span>بەروار:</span> <span>{{ $sale->created_at->format('Y-m-d H:i') }}</span></div>
        @if($sale->member)
        <div><span>ئەندام:</span> <span>{{ $sale->member->name }}</span></div>
        @endif
        <div><span>فرۆشیار:</span> <span>{{ auth()->user()->name }}</span></div>
    </div>

    <table>
        <thead>
            <tr>
                <th>بابەت</th>
                <th style="text-align:center">بڕ</th>
                <th style="text-align:left">کۆ</th>
            </tr>
        </thead>
        <tbody>
            @foreach($sale->items as $item)
            <tr>
                <td>{{ $item->product->name }}</td>
                <td style="text-align:center">{{ $item->quantity }}</td>
                <td style="text-align:left">{{ number_format($item->subtotal) }}</td>
            </tr>
            @endforeach
        </tbody>
    </table>

    <div class="totals">
        <div><span>کۆی گشتی:</span> <span>{{ number_format($sale->total_amount + $sale->discount) }}</span></div>
        @if($sale->discount > 0)
        <div><span>داشکاندن:</span> <span>{{ number_format($sale->discount) }}</span></div>
        @endif
        <div class="total-row"><span>بڕی کۆتایی:</span> <span>{{ number_format($sale->total_amount) }} {{ $settings['currency'] ?? 'IQD' }}</span></div>
        <div style="margin-top: 5px; font-size: 10px;">
            <span>شێوازی پارەدان:</span>
            <span>
                @if($sale->payment_method == 'cash') نەختینە
                @elseif($sale->payment_method == 'card') کارت
                @else قەرز @endif
            </span>
        </div>
    </div>

    <div class="footer">
        <div>سوپاس بۆ سەردانەکەتان</div>
        <div style="margin-top: 5px;">{{ $settings['gym_address'] ?? '' }}</div>
    </div>

    <script>
        // Auto print on load if needed
        // window.onload = () => window.print();
    </script>
</body>
</html>
