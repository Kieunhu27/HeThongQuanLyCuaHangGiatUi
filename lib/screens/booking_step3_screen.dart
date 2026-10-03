import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'booking_success_screen.dart'; // 🚀 Chuyển thẳng sang Màn hình Hoàn tất đặt lịch

class BookingStep3Screen extends StatefulWidget {
  const BookingStep3Screen({super.key});

  @override
  State<BookingStep3Screen> createState() => _BookingStep3ScreenState();
}

class _BookingStep3ScreenState extends State<BookingStep3Screen> {
  // Bảng màu chuẩn Brand Tokens WashSmart 3T theo HTML design
  static const Color primaryColor = Color(0xFFB90538);
  static const Color primaryContainer = Color(0xFFDC2C4F);
  static const Color primaryFixed = Color(0xFFFFDADB);
  static const Color secondaryColor = Color(0xFFB4136D);
  static const Color tertiaryColor = Color(0xFF006577);
  static const Color bgSurface = Color(0xFFFFF8F7);
  static const Color cardBg = Colors.white;
  static const Color surfaceLow = Color(0xFFFFF0F0);
  static const Color surfaceContainer = Color(0xFFFFE9EA);
  static const Color surfaceHigh = Color(0xFFFFE1E3);
  static const Color surfaceVariant = Color(0xFFFFD9DC);
  static const Color onSurface = Color(0xFF370C14);
  static const Color outlineColor = Color(0xFF8F6F71);
  static const Color outlineVariant = Color(0xFFE3BDBF);

  // --- STATE QUẢN LÝ ---
  String _paymentTiming = 'pickup'; // 'pickup': Khi Shipper tới cân, 'delivery': Khi nhận lại đồ
  bool _isSubmitting = false;

  void _handleConfirmBooking() {
    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() => _isSubmitting = false);

        // 🚀 Chuyển thẳng tới Màn hình Đặt Lịch Thành Công
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const BookingSuccessScreen(),
          ),
          (route) => route.isFirst,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgSurface,

      // --- 1. HEADER ---
      appBar: AppBar(
        backgroundColor: bgSurface.withOpacity(0.95),
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: onSurface, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WASHSMART 3T',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                letterSpacing: 0.8,
              ),
            ),
            Text(
              'Tạm Tính & Xác Nhận Đặt Đơn',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: onSurface,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: primaryColor,
              child: const Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),

      // --- NỘI DUNG CHÍNH ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. PROGRESS TRACKER (BƯỚC 3/3)
            _buildProgressTracker(),
            const SizedBox(height: 12),

            // 3. NOTICE BANNER: DYNAMIC WEIGHT VERIFICATION
            _buildWeightNoticeBanner(),
            const SizedBox(height: 12),

            // 4. PACKAGE SUMMARY CARD
            _buildPackageSummaryCard(),
            const SizedBox(height: 12),

            // 5. PICKUP & ADDRESS DETAILS
            _buildPickupAddressCard(),
            const SizedBox(height: 12),

            // 6. PAYMENT CHOICE SECTION
            _buildPaymentChoiceCard(),
            const SizedBox(height: 12),

            // 7. PRICE BREAKDOWN CARD
            _buildPriceBreakdownCard(),
            const SizedBox(height: 12),

            // 8. 3T GUARANTEE TRUST BANNER
            _buildGuaranteeTrustBanner(),
            const SizedBox(height: 100), // Khoảng trống cuộn qua bottom bar
          ],
        ),
      ),

      // --- 9. STICKY BOTTOM CONFIRMATION BAR ---
      bottomSheet: _buildStickyBottomBar(context),
    );
  }

  // --- WIDGET 2: PROGRESS TRACKER ---
  Widget _buildProgressTracker() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BƯỚC 3/3 • HOÀN TẤT',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Xác nhận & Tạm tính',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: outlineColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: const LinearProgressIndicator(
              value: 1.0,
              minHeight: 6,
              backgroundColor: surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET 3: WEIGHT NOTICE BANNER ---
  Widget _buildWeightNoticeBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surfaceHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: primaryFixed,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.scale, color: primaryColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chi phí tạm tính theo ước lượng (5.0 kg)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: outlineColor,
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Hóa đơn chính thức sẽ được lập sau khi Shipper 3T tới cân trực tiếp bằng ',
                      ),
                      TextSpan(
                        text: 'cân điện tử cầm tay ',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const TextSpan(
                        text: 'trước mặt bạn. Bạn hoàn toàn an tâm chỉ trả đúng khối lượng thực tế!',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET 4: PACKAGE SUMMARY CARD ---
  Widget _buildPackageSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.local_laundry_service, color: primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Gói dịch vụ đã chọn',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: onSurface,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: surfaceContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.edit, size: 14, color: primaryColor),
                      const SizedBox(width: 4),
                      Text(
                        'Sửa gói',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: surfaceContainer),
          const SizedBox(height: 12),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://images.unsplash.com/photo-1545173168-9f1947eebb7f?q=80&w=300&auto=format&fit=crop',
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Giặt sấy Tinh Tươm 3T',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: onSurface,
                          ),
                        ),
                        Text(
                          '125.000đ',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ước tính 5.0 kg • ~15-18 món quần áo',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: outlineColor,
                      ),
                    ),
                    Text(
                      'Đơn giá: 25.000đ/kg',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: outlineColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildPerkChip(Icons.filter_vintage, 'Hương hoa ban mai (0đ)', secondaryColor),
              _buildPerkChip(Icons.verified_user, 'Túi vải seal chống nước 3T (0đ)', tertiaryColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerkChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: surfaceContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: onSurface,
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET 5: PICKUP & ADDRESS DETAILS ---
  Widget _buildPickupAddressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.pin_drop, color: primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'Lịch hẹn & Địa chỉ gom đồ',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Địa chỉ
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: surfaceContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.home, size: 18, color: onSurface),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Điểm hẹn thu gom',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: outlineColor,
                      ),
                    ),
                    Text(
                      'P.14.02, Tháp B - Chung cư Sunrise City',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: onSurface,
                      ),
                    ),
                    Text(
                      'Đường Nguyễn Hữu Thọ, Phường Tân Hưng, Quận 7, TP.HCM',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: outlineColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Khung giờ
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: surfaceContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.schedule, size: 18, color: onSurface),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Khung giờ Shipper ghé',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: outlineColor,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '14:00 - 15:00 Hôm nay',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: primaryFixed,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Khoảng 30 phút nữa',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Shield Banner
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: surfaceLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.shield, size: 18, color: outlineColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Shipper mang kèm túi niêm phong mã QR và cân điện tử đã hiệu chuẩn tận cửa.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: outlineColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET 6: PAYMENT CHOICE SECTION ---
  Widget _buildPaymentChoiceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.payments, color: primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Phương thức thanh toán',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: onSurface,
                    ),
                  ),
                ],
              ),
              Text(
                'Thu sau khi cân',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Không cần thanh toán lúc này. Bạn chỉ thanh toán đúng số kg thực tế khi Shipper in phiếu chốt.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: outlineColor,
            ),
          ),
          const SizedBox(height: 12),

          // Radio 1: Thanh toán khi Shipper tới cân
          _buildPaymentOptionTile(
            value: 'pickup',
            title: 'Thanh toán khi Shipper tới cân',
            badge: 'Tiện lợi',
            desc: 'Shipper cân xong → Trả tiền mặt hoặc quét VietQR động ngay trên app shipper.',
          ),
          const SizedBox(height: 8),

          // Radio 2: Thanh toán khi nhận lại đồ sạch
          _buildPaymentOptionTile(
            value: 'delivery',
            title: 'Thanh toán khi nhận lại đồ sạch',
            desc: 'Kiểm tra đồ giặt sấy thơm tho rồi mới thanh toán COD hoặc chuyển khoản.',
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptionTile({
    required String value,
    required String title,
    String? badge,
    required String desc,
  }) {
    final bool isSelected = _paymentTiming == value;

    return GestureDetector(
      onTap: () => setState(() => _paymentTiming = value),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? surfaceContainer : surfaceLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Radio<String>(
              value: value,
              groupValue: _paymentTiming,
              onChanged: (val) => setState(() => _paymentTiming = val!),
              activeColor: primaryColor,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: onSurface,
                        ),
                      ),
                      if (badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            badge,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: outlineColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: outlineColor,
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

  // --- WIDGET 7: PRICE BREAKDOWN CARD ---
  Widget _buildPriceBreakdownCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bảng kê chi phí tạm tính',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: onSurface,
                ),
              ),
              Text(
                '5.0 kg mẫu',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
            fontWeight: FontWeight.w600,
                  color: outlineColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildPriceRow('Tạm tính gói giặt (5.0 kg x 25.000đ)', '125.000đ'),
          const SizedBox(height: 6),
          _buildPriceRow('Hương hoa ban mai & Túi seal 3T', '0đ', valueColor: secondaryColor, icon: Icons.card_giftcard),
          const SizedBox(height: 6),
          _buildPriceRow('Phí vận chuyển 2 chiều (Gom & Giao)', 'Miễn phí', valueColor: tertiaryColor),
          const SizedBox(height: 6),
          _buildPriceRow('Ưu đãi đơn đầu (WASH3TNEW)', '-20.000đ', valueColor: primaryColor, icon: Icons.sell),
          const SizedBox(height: 10),
          const Divider(height: 1, color: surfaceContainer),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TỔNG TẠM TÍNH',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: onSurface,
                    ),
                  ),
                  Text(
                    '(Chưa thanh toán ngay)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: outlineColor,
                    ),
                  ),
                ],
              ),
              Text(
                '105.000đ',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: surfaceContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '* Số tiền thanh toán cuối cùng = (Khối lượng thực tế x 25.000đ) - 20.000đ voucher.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                color: outlineColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {Color? valueColor, IconData? icon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: onSurface,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 4),
              Icon(icon, size: 14, color: valueColor ?? onSurface),
            ],
          ],
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
           fontWeight: FontWeight.w600,
            color: valueColor ?? onSurface,
          ),
        ),
      ],
    );
  }

  // --- WIDGET 8: 3T GUARANTEE TRUST BANNER ---
  Widget _buildGuaranteeTrustBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cam kết Tận Tâm • Tinh Tươm • Tiện Lợi',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: onSurface,
                  ),
                ),
                Text(
                  'Cân đo minh bạch tại chỗ • Niêm phong túi chống thất lạc đồ 100%.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: outlineColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET 9: STICKY BOTTOM CONFIRMATION BAR ---
  Widget _buildStickyBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 20),
      decoration: BoxDecoration(
        color: bgSurface.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
        border: const Border(top: BorderSide(color: surfaceContainer)),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tạm tính ước lượng:',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: outlineColor,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '105.000đ',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(Trả sau)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: outlineColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 48,
              width: 200,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _handleConfirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  elevation: 4,
                  shadowColor: primaryColor.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Đặt lịch gom đồ',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}