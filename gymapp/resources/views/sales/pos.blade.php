@extends('layouts.app')

@section('title', __('messages.pos'))

@push('styles')
<style>
    :root {
        --pos-sidebar-width: 400px;
        --pos-bg: #f3f4f6;
        --cart-item-bg: #ffffff;
    }
    .main-content { padding: 0 !important; background: var(--pos-bg); }
    .pos-layout { display: flex; height: calc(100vh - 65px); overflow: hidden; }
    
    /* Left side - Products */
    .pos-products-container { flex: 1; display: flex; flex-direction: column; padding: 20px; overflow: hidden; }
    .search-section { background: #fff; border-radius: 15px; padding: 12px 20px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); margin-bottom: 20px; }
    .search-section input { border: none; outline: none; width: 100%; font-size: 0.95rem; font-weight: 500; }
    
    .cat-scroll { display: flex; gap: 10px; overflow-x: auto; padding-bottom: 15px; scrollbar-width: none; }
    .cat-btn { padding: 8px 18px; background: #fff; border: 1px solid #e5e7eb; border-radius: 10px; cursor: pointer; white-space: nowrap; font-size: 0.85rem; font-weight: 600; transition: all 0.2s; color: #4b5563; }
    .cat-btn.active { background: var(--accent); color: #fff; border-color: var(--accent); box-shadow: 0 4px 10px rgba(108, 99, 255, 0.2); }
    
    .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); gap: 15px; overflow-y: auto; padding-bottom: 20px; }
    .p-card { background: #fff; border-radius: 18px; border: 1px solid #f3f4f6; padding: 15px; cursor: pointer; transition: all 0.2s; position: relative; }
    .p-card:hover { transform: translateY(-4px); box-shadow: 0 10px 20px rgba(0,0,0,0.04); border-color: var(--accent-soft); }
    .p-card .p-img { width: 100%; aspect-ratio: 1; background: #f9fafb; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 2rem; color: var(--accent); margin-bottom: 12px; }
    .p-card .p-name { font-weight: 700; font-size: 0.88rem; color: #1f2937; margin-bottom: 4px; }
    .p-card .p-price { color: var(--accent); font-weight: 800; font-size: 1rem; }
    .p-card .p-stock { font-size: 0.7rem; color: #9ca3af; margin-top: 4px; }
    .out-stock-overlay { position: absolute; inset: 0; background: rgba(255,255,255,0.8); border-radius: 18px; display: flex; align-items: center; justify-content: center; color: #dc2626; font-weight: 800; font-size: 0.8rem; pointer-events: none; }

    /* Right side - Cart */
    .pos-cart-container { width: var(--pos-sidebar-width); background: #fff; border-left: 1px solid #e5e7eb; display: flex; flex-direction: column; box-shadow: -10px 0 30px rgba(0,0,0,0.02); }
    .cart-header { padding: 25px; border-bottom: 1px solid #f3f4f6; }
    .cart-list { flex: 1; overflow-y: auto; padding: 20px; }
    .cart-row { background: #f9fafb; border-radius: 15px; padding: 12px; margin-bottom: 12px; display: flex; gap: 12px; align-items: center; }
    .cart-row-info { flex: 1; }
    .qty-ctrl { display: flex; align-items: center; gap: 10px; background: #fff; border-radius: 8px; padding: 4px 8px; box-shadow: 0 1px 2px rgba(0,0,0,0.05); }
    .qty-ctrl button { border: none; background: none; font-weight: bold; padding: 0 5px; color: var(--accent); }
    
    .cart-checkout-section { padding: 25px; background: #fff; border-top: 1px solid #f3f4f6; box-shadow: 0 -10px 30px rgba(0,0,0,0.02); }
    .checkout-summary { margin-bottom: 20px; }
    .summary-item { display: flex; justify-content: space-between; margin-bottom: 8px; color: #6b7280; font-size: 0.9rem; }
    .summary-item.total { margin-top: 15px; padding-top: 15px; border-top: 1px dashed #e5e7eb; font-weight: 800; color: #111827; font-size: 1.3rem; }
    
    .pay-methods { display: flex; gap: 10px; margin-bottom: 20px; }
    .pay-btn { flex: 1; cursor: pointer; text-align: center; }
    .pay-btn input { display: none; }
    .pay-btn span { display: block; padding: 10px; border: 1.5px solid #e5e7eb; border-radius: 12px; font-weight: 600; font-size: 0.8rem; transition: all 0.2s; color: #4b5563; }
    .pay-btn input:checked + span { background: var(--accent); color: #fff; border-color: var(--accent); box-shadow: 0 4px 10px rgba(108, 99, 255, 0.2); }
    
    .btn-finish { width: 100%; padding: 16px; border: none; border-radius: 15px; background: #111827; color: #fff; font-weight: 700; font-size: 1rem; transition: all 0.2s; display: flex; align-items: center; justify-content: center; gap: 10px; }
    .btn-finish:disabled { background: #e5e7eb; color: #9ca3af; cursor: not-allowed; }
    .btn-finish:hover:not(:disabled) { background: #000; transform: translateY(-2px); }
</style>
@endpush

@section('content')
<div class="pos-layout">
    <div class="pos-products-container">
        <div class="search-section d-flex align-items-center">
            <i class="bi bi-search text-muted me-3"></i>
            <input type="text" id="productSearch" placeholder="سێرچ بکە یان بارکۆد سکان بکە...">
        </div>

        <div class="cat-scroll">
            <div class="cat-btn active" data-category="all">هەموو جۆرەکان</div>
            @foreach($products->pluck('category')->unique() as $cat)
                @if($cat) <div class="cat-btn" data-category="{{ $cat }}">{{ $cat }}</div> @endif
            @endforeach
        </div>

        <div class="product-grid" id="productsList">
            @foreach($products as $product)
            <div class="p-item" data-name="{{ strtolower($product->name) }}" data-barcode="{{ $product->barcode }}" data-category="{{ $product->category }}">
                <div class="p-card" onclick="addToCart({{ json_encode($product) }})">
                    <div class="p-img"><i class="bi bi-box-seam"></i></div>
                    <div class="p-name text-truncate">{{ $product->name }}</div>
                    <div class="p-price">{{ number_format($product->price) }} <small>IQD</small></div>
                    <div class="p-stock">کۆگا: {{ $product->stock_quantity }}</div>
                    @if($product->stock_quantity <= 0)
                        <div class="out-stock-overlay">تەواو بووە</div>
                    @endif
                </div>
            </div>
            @endforeach
        </div>
    </div>

    <div class="pos-cart-container">
        <div class="cart-header">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="fw-bold mb-0">کارت</h5>
                <button class="btn btn-sm btn-light text-danger" onclick="clearCart()"><i class="bi bi-trash"></i></button>
            </div>
            
            <label class="form-label small fw-bold text-muted">هەڵبژاردنی ئەندام</label>
            <select id="member_id" class="form-select border-0 bg-light rounded-3 py-2">
                <option value="">-- کڕیاری ئاسایی --</option>
                @foreach($members as $member)
                <option value="{{ $member->id }}">
                    {{ $member->name }} (قەرز: {{ number_format($member->balance) }})
                </option>
                @endforeach
            </select>
        </div>

        <div class="cart-list" id="cartItems">
            <div class="text-center py-5 opacity-25">
                <i class="bi bi-cart3 fs-1 d-block mb-2"></i>
                <p class="small">کارتەکە چۆڵە</p>
            </div>
        </div>

        <div class="cart-checkout-section">
            <div class="checkout-summary">
                <div class="summary-item">
                    <span>کۆی گشتی</span>
                    <span id="cartSubtotal">0 IQD</span>
                </div>
                <div class="summary-item align-items-center">
                    <span>داشکاندن</span>
                    <input type="number" id="discount" class="form-control form-control-sm border-0 bg-light text-end" style="width: 80px;" value="0" onchange="updateTotal()">
                </div>
                <div class="summary-item total">
                    <span>بڕی کۆتایی</span>
                    <span id="cartTotal">0 IQD</span>
                </div>
            </div>

            <label class="form-label small fw-bold text-muted mb-2">شێوازی پارەدان</label>
            <div class="pay-methods">
                <label class="pay-btn">
                    <input type="radio" name="payment_method" value="cash" checked>
                    <span>نەختینە</span>
                </label>
                <label class="pay-btn">
                    <input type="radio" name="payment_method" value="debt">
                    <span>قەرز</span>
                </label>
            </div>

            <button class="btn-finish" onclick="processSale()" id="checkoutBtn" disabled>
                <i class="bi bi-shield-check"></i> تەواوکردنی فرۆشتن
            </button>
        </div>
    </div>
</div>

<!-- Success Modal -->
<div class="modal fade" id="receiptModal" data-bs-backdrop="static" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 25px;">
            <div class="modal-body text-center p-5">
                <div class="mb-4">
                    <div class="bg-success bg-opacity-10 text-success rounded-circle d-flex align-items-center justify-content-center mx-auto" style="width: 80px; height: 80px;">
                        <i class="bi bi-check-lg fs-1"></i>
                    </div>
                </div>
                <h4 class="fw-bold mb-1">فرۆشتنەکە سەرکەوت!</h4>
                <p class="text-muted small mb-4">پسوولەی ژمارە <span id="success_sale_id" class="fw-bold text-dark"></span></p>
                <div class="d-grid gap-2">
                    <a href="#" id="print_receipt_btn" target="_blank" class="btn btn-dark py-3 rounded-4 fw-bold">
                        <i class="bi bi-printer me-2"></i>چاپی پسوولە
                    </a>
                    <button class="btn btn-light py-3 rounded-4 fw-bold" onclick="location.reload()">فرۆشتنی نوێ</button>
                </div>
            </div>
        </div>
    </div>
</div>

@push('scripts')
<script>
    let cart = [];
    const currency = "IQD";

    // Category filtering
    document.querySelectorAll('.cat-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('.cat-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            filterProducts();
        });
    });

    function filterProducts() {
        const query = document.getElementById('productSearch').value.toLowerCase();
        const activeCat = document.querySelector('.cat-btn.active').dataset.category;

        document.querySelectorAll('.p-item').forEach(item => {
            const nameMatch = item.dataset.name.includes(query);
            const barcodeMatch = item.dataset.barcode.includes(query);
            const catMatch = activeCat === 'all' || item.dataset.category === activeCat;
            
            item.style.display = ((nameMatch || barcodeMatch) && catMatch) ? 'block' : 'none';
        });
    }

    document.getElementById('productSearch').addEventListener('input', filterProducts);

    function addToCart(product) {
        if (product.stock_quantity <= 0) return;
        const existing = cart.find(item => item.id === product.id);
        if (existing) {
            if (existing.quantity < product.stock_quantity) existing.quantity++;
        } else {
            cart.push({ ...product, quantity: 1 });
        }
        renderCart();
    }

    function renderCart() {
        const container = document.getElementById('cartItems');
        if (cart.length === 0) {
            container.innerHTML = `<div class="text-center py-5 opacity-25"><i class="bi bi-cart3 fs-1 d-block mb-2"></i><p class="small">کارتەکە چۆڵە</p></div>`;
            document.getElementById('checkoutBtn').disabled = true;
        } else {
            container.innerHTML = cart.map(item => `
                <div class="cart-row">
                    <div class="cart-row-info">
                        <div class="fw-bold small mb-1">${item.name}</div>
                        <div class="text-accent fw-bold small">${(item.price).toLocaleString()} <small>IQD</small></div>
                    </div>
                    <div class="qty-ctrl">
                        <button onclick="updateQty(${item.id}, -1)">-</button>
                        <span class="small">${item.quantity}</span>
                        <button onclick="updateQty(${item.id}, 1)">+</button>
                    </div>
                    <div class="text-end" style="min-width: 60px;">
                        <div class="fw-bold small text-dark">${(item.price * item.quantity).toLocaleString()}</div>
                    </div>
                </div>
            `).join('');
            document.getElementById('checkoutBtn').disabled = false;
        }
        updateTotal();
    }

    function updateQty(id, delta) {
        const item = cart.find(i => i.id === id);
        if (item) {
            const newQty = item.quantity + delta;
            if (newQty > 0 && newQty <= item.stock_quantity) {
                item.quantity = newQty;
            } else if (newQty === 0) {
                cart = cart.filter(i => i.id !== id);
            }
        }
        renderCart();
    }

    function clearCart() {
        if (cart.length > 0 && confirm('ئایا دڵنیای؟')) {
            cart = [];
            renderCart();
        }
    }

    function updateTotal() {
        const subtotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
        const discount = parseFloat(document.getElementById('discount').value) || 0;
        const total = Math.max(0, subtotal - discount);

        document.getElementById('cartSubtotal').innerText = subtotal.toLocaleString() + ' IQD';
        document.getElementById('cartTotal').innerText = total.toLocaleString() + ' IQD';
    }

    async function processSale() {
        const btn = document.getElementById('checkoutBtn');
        const oldHtml = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span> تۆمار دەکرێت...';

        const data = {
            member_id: document.getElementById('member_id').value || null,
            items: cart.map(i => ({ id: i.id, quantity: i.quantity })),
            discount: parseFloat(document.getElementById('discount').value) || 0,
            payment_method: document.querySelector('input[name="payment_method"]:checked').value,
            _token: '{{ csrf_token() }}'
        };

        try {
            const response = await fetch('{{ route("sales.store") }}', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
                body: JSON.stringify(data)
            });

            const result = await response.json();
            if (result.success) {
                document.getElementById('success_sale_id').innerText = '#' + result.sale_id;
                document.getElementById('print_receipt_btn').href = `/sales/${result.sale_id}/print`;
                new bootstrap.Modal(document.getElementById('receiptModal')).show();
            } else {
                alert('هەڵەیەک ڕوویدا: ' + result.message);
                btn.disabled = false;
                btn.innerHTML = oldHtml;
            }
        } catch (error) {
            alert('پەیوەندی نییە!');
            btn.disabled = false;
            btn.innerHTML = oldHtml;
        }
    }

    // Barcode handle
    let barcodeTimer;
    let barcodeBuffer = '';
    window.addEventListener('keypress', e => {
        if (document.activeElement.tagName === 'INPUT') return;
        if (barcodeTimer) clearTimeout(barcodeTimer);
        if (e.key === 'Enter') {
            if (barcodeBuffer.length > 2) {
                const product = @json($products).find(p => p.barcode === barcodeBuffer);
                if (product) addToCart(product);
                barcodeBuffer = '';
            }
        } else {
            barcodeBuffer += e.key;
        }
        barcodeTimer = setTimeout(() => { barcodeBuffer = ''; }, 100);
    });
</script>
@endpush
@endsection
