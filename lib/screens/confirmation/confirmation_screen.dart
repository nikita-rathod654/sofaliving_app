import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/order.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/custom_button.dart';

class ConfirmationScreen extends StatelessWidget {
  final OrderModel order;

  const ConfirmationScreen({super.key, required this.order});

  static const String _fallbackImage =
      'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=80';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text('SOFALIVING', style: AppTextStyles.brandHeader),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textPrimary),
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          children: [
            // 1. Success Circle & Banner
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.check, color: AppColors.success, size: 32),
            ),
            const SizedBox(height: 14),
            const Text(
              'Order Placed Successfully!',
              textAlign: TextAlign.center,
              style: AppTextStyles.h1,
            ),
            const SizedBox(height: 6),
            Text(
              'Thank you, ${order.recipientName.split(' ').first}. Your bespoke sofa is now being handcrafted in our atelier.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 16),

            // 2. Order Reference Pill with Copy Button
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: order.orderRef));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Order reference copied to clipboard!')),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'ORDER REF: ',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMuted,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        order.orderRef,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.copy_outlined,
                        size: 14, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Estimated Delivery Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  const Text(
                    'ESTIMATED DELIVERY:',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Text(
                    'October 24 – 26, 2025',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accentLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Ships in 5-7 days',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Craftsmanship Journey Visual Timeline
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Craftsmanship Journey',
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.h3,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'LIVE ATELIER',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildJourneyStep('1', 'Order Placed', 'Confirmed',
                          isCompleted: true),
                      _buildJourneyLine(isDone: true),
                      _buildJourneyStep('2', 'Woodworking', 'In Progress',
                          isActive: true),
                      _buildJourneyLine(isDone: false),
                      _buildJourneyStep('3', 'Upholstery', 'Pending'),
                      _buildJourneyLine(isDone: false),
                      _buildJourneyStep('4', 'White Glove', 'Room Setup'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. Order Details Card
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Order Details', style: AppTextStyles.h3),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '${order.items.length} bespoke items',
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Ordered Items
                  ...order.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              item.image.isNotEmpty
                                  ? item.image
                                  : _fallbackImage,
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 44,
                                height: 44,
                                color: AppColors.cardBg,
                                child: const Icon(
                                  Icons.weekend_outlined,
                                  size: 20,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${item.seating} • ${item.color} • ${item.fabric}',
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            CurrencyFormatter.format(item.totalPrice),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ],
                      ),
                    );
                  }),
                  const Divider(height: 20),

                  // White Glove Delivery Address
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'White Glove Delivery Address',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${order.street}, ${order.landmark.isNotEmpty ? "${order.landmark}, " : ""}${order.city}, ${order.state} ${order.pincode}',
                              style: AppTextStyles.bodySmall,
                            ),
                            Text(
                              'Recipient: ${order.recipientName} | ${order.phone}',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),

                  // Payment Method
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Payment Method',
                              style: TextStyle(
                                  fontSize: 10, color: AppColors.textMuted),
                            ),
                            Text(
                              order.paymentMethod,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'PAID',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),

                  // Pricing Rows
                  _buildSummaryRow(
                      'Subtotal', CurrencyFormatter.format(order.subtotal)),
                  _buildSummaryRow(
                    'White Glove Room Delivery & Assembly',
                    'COMPLIMENTARY',
                    valueColor: AppColors.success,
                  ),
                  if (order.discount > 0)
                    _buildSummaryRow(
                      'Promotional Discount',
                      '−${CurrencyFormatter.format(order.discount)}',
                      valueColor: AppColors.success,
                    ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Paid', style: AppTextStyles.h3),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          CurrencyFormatter.format(order.total),
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.h2.copyWith(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 5. Personal Atelier Concierge Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.support_agent_outlined,
                      color: AppColors.primary, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Atelier Concierge',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Questions about customisation or delivery scheduling? Our design masters are on standby.',
                          style: TextStyle(
                              fontSize: 10, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline,
                        size: 18, color: AppColors.primary),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Connecting to Atelier Concierge Desk...')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 6. Action Buttons
            CustomButton(
              text: 'Track Order Status',
              isOutlined: true,
              onPressed: () {
                _showStatusModal(context);
              },
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Continue Shopping →',
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildJourneyStep(
    String step,
    String title,
    String status, {
    bool isCompleted = false,
    bool isActive = false,
  }) {
    return SizedBox(
      width: 56,
      child: Column(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.success
                  : (isActive ? AppColors.primary : AppColors.cardBg),
              shape: BoxShape.circle,
              border: Border.all(
                  color: isActive ? AppColors.primary : AppColors.border),
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : Text(
                      step,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color:
                            isActive ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              status,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                fontSize: 8,
                color: isActive ? AppColors.accent : AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Aligned with the vertical centre of the 22px step circle (top: 11 - 0.75).
  Widget _buildJourneyLine({required bool isDone}) {
    return Expanded(
      child: Container(
        height: 1.5,
        margin: const EdgeInsets.only(top: 10.25, left: 2, right: 2),
        color: isDone ? AppColors.success : AppColors.border,
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style:
                  const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Order ${order.orderRef}',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.h2,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.verified, color: AppColors.success),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Status: Handcrafting Solid Teak Frame (In Progress)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your teak frame is currently undergoing master artisan jointing and hand-sanding in our Mumbai atelier. Belgian upholstery will begin shortly.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            CustomButton(text: 'Close', onPressed: () => Navigator.of(ctx).pop()),
          ],
        ),
      ),
    );
  }
}