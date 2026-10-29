import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/quantity_control.dart';
import '../../widgets/empty_state_view.dart';
import '../../providers/cart_provider.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  final VoidCallback? onContinueShopping;

  const CartScreen({super.key, this.onContinueShopping});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController =
      TextEditingController(text: 'SOFAFIRST');

  static const String _fallbackImage =
      'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=80';

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  Widget _thumb(String url) {
    final placeholder = Container(
      width: 75,
      height: 75,
      color: AppColors.cardBg,
      child: const Icon(Icons.image_not_supported_outlined,
          color: AppColors.textMuted),
    );
    return Image.network(
      url.isNotEmpty ? url : _fallbackImage,
      width: 75,
      height: 75,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        title: Consumer<CartProvider>(
          builder: (context, cart, _) {
            return Row(
              children: [
                Expanded(
                  child: Text(
                    'Shopping Bag (${cart.totalItemCount} items)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.h2.copyWith(fontSize: 18),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_outline,
                          size: 12, color: AppColors.textSecondary),
                      SizedBox(width: 4),
                      Text(
                        'SECURE',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.isEmpty) {
            return EmptyStateView(
              icon: Icons.shopping_bag_outlined,
              title: 'Your Shopping Bag is Empty',
              message:
                  'Discover our artisan collection of bespoke sofas crafted for serenity.',
              buttonText: 'Explore Collection',
              onButtonPressed: widget.onContinueShopping,
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Bespoke Atelier Banner
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.border, width: 0.8),
                    ),
                    child: const Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        Icon(Icons.handyman_outlined,
                            size: 14, color: AppColors.accent),
                        Text(
                          'BESPOKE ATELIER ORDER',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Handcrafted to order',
                          style: TextStyle(
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Cart Items List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: AppColors.border, width: 0.8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Thumbnail
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                width: 75,
                                height: 75,
                                child: _thumb(item.image),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Item Details & Controls
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.name,
                                          style: AppTextStyles.h3
                                              .copyWith(fontSize: 14),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      GestureDetector(
                                        onTap: () => cart.removeItem(item.id),
                                        child: const Icon(Icons.close,
                                            size: 18,
                                            color: AppColors.textMuted),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.specificationsLabel,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.bodySmall
                                        .copyWith(fontSize: 11),
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    alignment: WrapAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      Text(
                                        CurrencyFormatter.format(
                                            item.totalPrice),
                                        style: AppTextStyles.priceHighlight
                                            .copyWith(fontSize: 15),
                                      ),
                                      QuantityControl(
                                        quantity: item.quantity,
                                        onChanged: (newQty) =>
                                            cart.updateQuantity(
                                                item.id, newQty),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 18),

                  // 3. Complimentary White Glove Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.local_shipping_outlined,
                            color: AppColors.primary, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'Complimentary White Glove',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.successLight,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'INCLUDED',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.success,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'White Glove Delivery to Mumbai, 400001 • Free on orders over ₹50,000',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Estimated Delivery: 8-12 Business Days',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textMuted,
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 4. Promo Code Box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _couponController,
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: const InputDecoration(
                                  hintText: 'Enter coupon code',
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                              onPressed: () {
                                final applied =
                                    cart.applyCoupon(_couponController.text);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      applied
                                          ? 'Coupon SOFAFIRST applied successfully! (-₹5,000)'
                                          : 'Invalid promo code. Use SOFAFIRST for ₹5,000 off.',
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Apply',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ),
                          ],
                        ),
                        if (cart.appliedCoupon != null) ...[
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.successLight,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        color: AppColors.success
                                            .withValues(alpha: 0.5)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.check,
                                          size: 12, color: AppColors.success),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          '${cart.appliedCoupon} (-${CurrencyFormatter.format(cart.discount)} applied)',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.success,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  cart.removeCoupon();
                                  _couponController.clear();
                                },
                                child: const Icon(Icons.close,
                                    size: 16, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 5. Order Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Order Summary', style: AppTextStyles.h3),
                        const SizedBox(height: 12),
                        _buildSummaryRow('Subtotal',
                            CurrencyFormatter.format(cart.subtotal)),
                        _buildSummaryRow('Fabric & Custom Crafting', 'Included'),
                        _buildSummaryRow(
                          'White Glove Delivery & Assembly',
                          cart.whiteGloveDeliveryFee == 0
                              ? '₹2,999 FREE'
                              : CurrencyFormatter.format(
                                  cart.whiteGloveDeliveryFee),
                          valueColor: cart.whiteGloveDeliveryFee == 0
                              ? AppColors.success
                              : null,
                        ),
                        if (cart.discount > 0)
                          _buildSummaryRow(
                            'Promotional Discount (${cart.appliedCoupon})',
                            '−${CurrencyFormatter.format(cart.discount)}',
                            valueColor: AppColors.success,
                          ),
                        const Divider(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Estimated Total',
                                      style: AppTextStyles.h3),
                                  Text('Inclusive of all taxes & GST',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.textMuted)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              CurrencyFormatter.format(cart.estimatedTotal),
                              style: AppTextStyles.h2.copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 6. Proceed to Checkout Button
                 CustomButton(
  text: 'Checkout • ${CurrencyFormatter.format(cart.estimatedTotal)}',
  trailingIcon: const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
  onPressed: () {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CheckoutScreen()),
    );
  },
),


                  const SizedBox(height: 12),

                  // 7. Continue Shopping Button
                  Center(
                    child: TextButton(
                      onPressed: widget.onContinueShopping,
                      child: const Text(
                        '← Continue Shopping',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(label, style: AppTextStyles.bodyMedium),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}