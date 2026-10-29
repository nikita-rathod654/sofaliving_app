import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/custom_button.dart';
import '../../providers/checkout_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../confirmation/confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _streetController;
  late TextEditingController _landmarkController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _pincodeController;

  bool _isCuratedOrderExpanded = false;

  @override
  void initState() {
    super.initState();
    final checkout = Provider.of<CheckoutProvider>(context, listen: false);
    _nameController = TextEditingController(text: checkout.fullName);
    _phoneController = TextEditingController(text: checkout.phone);
    _emailController = TextEditingController(text: checkout.email);
    _streetController = TextEditingController(text: checkout.street);
    _landmarkController = TextEditingController(text: checkout.landmark);
    _cityController = TextEditingController(text: checkout.city);
    _stateController = TextEditingController(text: checkout.state);
    _pincodeController = TextEditingController(text: checkout.pincode);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _streetController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _syncControllers(CheckoutProvider checkout) {
    if (_streetController.text != checkout.street) {
      _streetController.text = checkout.street;
      _landmarkController.text = checkout.landmark;
      _cityController.text = checkout.city;
      _stateController.text = checkout.state;
      _pincodeController.text = checkout.pincode;
      _nameController.text = checkout.fullName;
      _phoneController.text = checkout.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<CheckoutProvider, CartProvider, AuthProvider>(
      builder: (context, checkout, cart, auth, _) {
        _syncControllers(checkout);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('Checkout', style: AppTextStyles.h2),
            centerTitle: true,
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(Icons.lock_outline, size: 20, color: AppColors.textSecondary),
              ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Stepper: 1. Bag -> 2. Delivery & Address -> 3. Confirmation
                  _buildStepper(),
                  const SizedBox(height: 20),

                  // 2. Saved Locations Chips
                  const Text('Saved Locations', style: AppTextStyles.h3),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        // New Address pill
                        GestureDetector(
                          onTap: () {
                            checkout.updateAddressInfo(
                              street: '',
                              landmark: '',
                              city: 'Mumbai',
                              state: 'Maharashtra',
                              pincode: '',
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.add, size: 14, color: AppColors.textPrimary),
                                SizedBox(width: 4),
                                Text('+ New Address', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                        // Saved Addresses
                        ...checkout.savedAddresses.map((addr) {
                          final isSelected = checkout.selectedAddress?.id == addr.id;
                          return GestureDetector(
                            onTap: () => checkout.selectSavedAddress(addr),
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : AppColors.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.border,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.home_outlined,
                                    size: 14,
                                    color: isSelected ? Colors.white : AppColors.textPrimary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${addr.label}: ${addr.city}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected ? Colors.white : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3. Contact Information
                  _buildSectionHeader('Contact Information', 'Step 1/2'),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'Full Name',
                    controller: _nameController,
                    onChanged: (v) => checkout.updateContactInfo(name: v),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter full name' : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Text('+91', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildTextField(
                          label: 'Phone Number',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          onChanged: (v) => checkout.updateContactInfo(phone: v),
                          validator: (v) => (v == null || v.length < 8) ? 'Enter valid phone number' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'Email Address',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (v) => checkout.updateContactInfo(email: v),
                    validator: (v) => (v == null || !v.contains('@')) ? 'Enter valid email' : null,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 4, left: 2),
                    child: Text(
                      'Order invoices & dispatch tracking are dispatched here.',
                      style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4. Delivery Address
                  _buildSectionHeader('Delivery Address', 'Residence'),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'Street Address / Apartment',
                    controller: _streetController,
                    onChanged: (v) => checkout.updateAddressInfo(street: v),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Street address is required' : null,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'Landmark / Locality Area',
                    controller: _landmarkController,
                    onChanged: (v) => checkout.updateAddressInfo(landmark: v),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'City',
                          controller: _cityController,
                          onChanged: (v) => checkout.updateAddressInfo(city: v),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'City required' : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildTextField(
                          label: 'State',
                          controller: _stateController,
                          onChanged: (v) => checkout.updateAddressInfo(state: v),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'State required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'PIN Code',
                    controller: _pincodeController,
                    keyboardType: TextInputType.number,
                    onChanged: (v) => checkout.updateAddressInfo(pincode: v),
                    validator: (v) => (v == null || v.length != 6) ? 'Enter 6-digit PIN' : null,
                  ),
                  
if (checkout.isEligibleForWhiteGlove)
  Padding(
    padding: const EdgeInsets.only(top: 6, left: 2),
    child: Row(
      children: [
        const Icon(Icons.check_circle, size: 14, color: AppColors.success),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            'Eligible for Complimentary White Glove Delivery',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.success),
          ),
        ),
      ],
    ),
  ),


                  const SizedBox(height: 24),

                  // 5. Delivery Method Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: 
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Expanded(
      child: Text(
        'Complimentary White Glove Delivery',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
      ),
    ),
    const SizedBox(width: 8),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text('Selected', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
    ),
  ],
),


                              const SizedBox(height: 4),
                              const Text(
                                'Includes in-room placement, assembly, and packaging removal. Estimated Oct 24-26.',
                                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 6. Curated Order Accordion
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => setState(() => _isCuratedOrderExpanded = !_isCuratedOrderExpanded),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                          
                          
                           child: Wrap(
  alignment: WrapAlignment.spaceBetween,
  crossAxisAlignment: WrapCrossAlignment.center,
  spacing: 12,
  runSpacing: 8,
  children: [
    Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.receipt_long_outlined,
          size: 18,
          color: AppColors.primary,
        ),
        const SizedBox(width: 8),
        Text(
          'Curated Order (${cart.totalItemCount} Items)',
          style: AppTextStyles.h3.copyWith(fontSize: 13),
        ),
      ],
    ),
    Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          CurrencyFormatter.format(cart.estimatedTotal),
          style: AppTextStyles.h3.copyWith(fontSize: 13),
        ),
        const SizedBox(width: 4),
        Icon(
          _isCuratedOrderExpanded
              ? Icons.keyboard_arrow_up
              : Icons.keyboard_arrow_down,
          size: 18,
        ),
      ],
    ),
  ],
),




                          ),
                        ),
                       
                       if (_isCuratedOrderExpanded) ...[
  const Divider(height: 1),
  Padding(
    padding: const EdgeInsets.all(14.0),
    child: Column(
      
    children: cart.items.map((i) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${i.quantity}x ${i.name}', style: AppTextStyles.bodyMedium),
          Text(CurrencyFormatter.format(i.totalPrice), style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }).toList(),
),


  ),
],




                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 7. Payment Preference (Mock Sandbox)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Payment Preference', style: AppTextStyles.h3),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accentLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('Mock Sandbox', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.accent)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildPaymentRadio(
                    method: PaymentMethod.upi,
                    title: 'Mock UPI / Net Banking',
                    subtitle: 'Instant virtual transaction approval',
                    icon: Icons.qr_code,
                    checkout: checkout,
                  ),
                  const SizedBox(height: 8),
                  _buildPaymentRadio(
                    method: PaymentMethod.card,
                    title: 'Mock Credit/Debit Card',
                    subtitle: 'Pre-filled tokenised test sandbox',
                    icon: Icons.credit_card,
                    checkout: checkout,
                  ),
                  const SizedBox(height: 8),
                  _buildPaymentRadio(
                    method: PaymentMethod.cod,
                    title: 'Pay on Delivery (Demo)',
                    subtitle: 'Physical POS on assembly completion',
                    icon: Icons.payments_outlined,
                    checkout: checkout,
                  ),
                  const SizedBox(height: 24),

                  // 8. Trust Guarantees
             
             
                 Container(
  padding: const EdgeInsets.all(14),
  decoration: BoxDecoration(
    color: AppColors.cardBg,
    borderRadius: BorderRadius.circular(10),
  ),
  child: const Wrap(
    alignment: WrapAlignment.spaceAround,
    spacing: 16,
    runSpacing: 12,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 16,
            color: AppColors.primary,
          ),
          SizedBox(width: 6),
          Text(
            '10-Year Frame Warranty',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.thumb_up_outlined,
            size: 16,
            color: AppColors.primary,
          ),
          SizedBox(width: 6),
          Text(
            '30-Day Comfort Guarantee',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ],
  ),
),



                  const SizedBox(height: 24),

                  // 9. Place Demo Order Button
                  CustomButton(
                    text: 'Place Demo Order • ${CurrencyFormatter.format(cart.estimatedTotal)}',
                    isLoading: checkout.isLoading,
                    trailingIcon: const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill all required fields correctly.')),
                        );
                        return;
                      }

                      final userId = auth.currentUser?.id ?? 1;
                      final order = await checkout.placeDemoOrder(
                        userId: userId,
                        subtotal: cart.subtotal,
                        discount: cart.discount,
                        total: cart.estimatedTotal,
                        items: cart.items,
                      );

                      if (order != null && context.mounted) {
                        await cart.clearCart(userId);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => ConfirmationScreen(order: order),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'By continuing, you acknowledge this is a Flutter prototype demonstration environment.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


 
Widget _buildStepper() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStepItem('1', 'Bag', isDone: true),
        _buildStepDivider(isDone: true),
        _buildStepItem('2', 'Delivery & Address', isActive: true),
        _buildStepDivider(isDone: false),
        _buildStepItem('3', 'Confirmation', isDone: false),
      ],
    ),
  );
}

Widget _buildStepDivider({required bool isDone}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 6),
    width: 20,
    height: 1.5,
    color: isDone ? AppColors.primary : AppColors.border,
  );
}

 

  Widget _buildStepItem(String number, String label, {bool isDone = false, bool isActive = false}) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : (isDone ? AppColors.accent : AppColors.border),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 12, color: Colors.white)
                : Text(
                    number,
                    style: TextStyle(
                      color: isActive ? Colors.white : AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  

  Widget _buildSectionHeader(String title, String tag) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.h3),
        Text(tag, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  Widget _buildPaymentRadio({
    required PaymentMethod method,
    required String title,
    required String subtitle,
    required IconData icon,
    required CheckoutProvider checkout,
  }) {
    final isSelected = checkout.selectedPayment == method;

    return GestureDetector(
      onTap: () => checkout.selectPaymentMethod(method),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 18,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(width: 12),
            Icon(icon, size: 20, color: AppColors.textPrimary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
