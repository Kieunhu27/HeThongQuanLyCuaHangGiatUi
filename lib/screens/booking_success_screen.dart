import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingSuccessScreen extends StatefulWidget {
  const BookingSuccessScreen({super.key});

  @override
  State<BookingSuccessScreen> createState() => _BookingSuccessScreenState();
}

class _BookingSuccessScreenState extends State<BookingSuccessScreen> {
  // Bảng màu chuẩn Brand Tokens WashSmart 3T
  static const Color primaryColor = Color(0xFFB90538);
  static const Color primaryFixed = Color(0xFFFFDADB);
  static const Color secondaryColor = Color(0xFFB4136D);
  static const Color secondaryFixed = Color(0xFFFFD9E4);
  static const Color tertiaryColor = Color(0xFF006577);
  static const Color tertiaryFixed = Color(0xFFACEDFF);
  static const Color bgSurface = Color(0xFFFFF8F7);
  static const Color cardBg = Colors.white;
  static const Color surfaceLow = Color(0xFFFFF0F0);
  static const Color surfaceContainer = Color(0xFFFFE9EA);
  static const Color surfaceHigh = Color(0xFFFFE1E3);
  static const Color surfaceHighest = Color(0xFFFFD9DC);
  static const Color onSurface = Color(0xFF370C14);
  static const Color onSurfaceVariant = Color(0xFF5B4041);
  static const Color outlineColor = Color(0xFF8F6F71);

  bool _isCopied = false;
  final String _orderCode = '#WS3T-8892';

  void _copyOrderCode() {
    Clipboard.setData(ClipboardData(text: _orderCode));
    setState(() => _isCopied = true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Đã sao chép mã đơn $_orderCode',
          style: GoogleFonts.plusJakartaSans(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isCopied = false);
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
          icon: const Icon(Icons.close, color: onSurface, size: 22),
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
        title: Text(
          'Đặt Đơn Thành Công',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: onSurfaceVariant, size: 22),
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 4.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: primaryColor,
              child: const Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),

      // --- NỘI DUNG CHÍNH ---
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 140),
            child: Column(
              children: [
                // 2. HERO SECTION
                _buildHeroSection(),
                const SizedBox(height: 16),

                // 3. CARD 1: LỊCH TRÌNH LẤY ĐỒ 3T
                _buildScheduleCard(),
                const SizedBox(height: 12),

                // 4. CARD 2: CHI TIẾT ĐƠN HÀNG
                _buildOrderDetailCard(),
                const SizedBox(height: 12),

                // 5. CARD 3: CAM KẾT QUY TRÌNH 3T
                _buildCommitmentCard(),
                const SizedBox(height: 16),

                // 6. HOTLINE HỖ TRỢ
                _buildSupportHotline(),
              ],
            ),
          ),

          // --- 7. STICKY BOTTOM ACTION BAR ---
          _buildStickyBottomBar(context),
        ],
      ),
    );
  }

  // WIDGET: HERO SECTION
  Widget _buildHeroSection() {
    return Column(
      children: [
        // Badge Checkmark
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: secondaryFixed.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.check_circle, color: Colors.white, size: 42),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: cardBg,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: const Icon(Icons.auto_awesome, color: primaryColor, size: 16),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: surfaceHigh,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_laundry_service, color: secondaryColor, size: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Tag trạng thái
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: surfaceHigh,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Đã xác nhận & Đang điều phối Shipper 3T',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        Text(
          'Đặt đơn thành công!',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: onSurfaceVariant,
                height: 1.4,
              ),
              children: [
                const TextSpan(text: 'Cảm ơn chị '),
                TextSpan(
                  text: 'Kiều Như',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    color: onSurface,
                  ),
                ),
                const TextSpan(
                  text: '! Đơn đồ giặt của bạn đã được tiếp nhận và chuyển đến Shipper 3T khu vực Tân Hưng, Quận 7.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Mã đơn & Sao chép
        Container(
          padding: const EdgeInsets.only(left: 14, right: 6, top: 6, bottom: 6),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'MÃ ĐƠN ',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: outlineColor,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                _orderCode,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: _copyOrderCode,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _isCopied ? tertiaryFixed : surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isCopied ? Icons.check : Icons.content_copy,
                        size: 14,
                        color: _isCopied ? tertiaryColor : onSurface,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isCopied ? 'Đã chép!' : 'Sao chép',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _isCopied ? tertiaryColor : onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // WIDGET: SCHEDULE CARD
  Widget _buildScheduleCard() {
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
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: surfaceHigh,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.two_wheeler, color: primaryColor, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Lịch trình lấy đồ 3T',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: onSurface,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: secondaryFixed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Lấy hẹn giờ',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: secondaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Lịch trình
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: surfaceLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: primaryFixed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.access_time_filled, color: primaryColor, size: 14),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shipper tới gom đồ:',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              color: onSurfaceVariant,
                            ),
                          ),
                          Text(
                            'Hôm nay, 14:00 – 15:00 (Khoảng 30 phút nữa)',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: surfaceHighest,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.event_available, color: tertiaryColor, size: 14),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dự kiến giao trả tinh tươm:',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              color: onSurfaceVariant,
                            ),
                          ),
                          Text(
                            'Trước 12:00 trưa ngày mai (25/10)',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Địa chỉ
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: primaryColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Chị Kiều Như',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: onSurface,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '0988 ••• 321',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: outlineColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'P.14.02, Tháp B – Chung cư Sunrise City, Đường Nguyễn Hữu Thọ, Phường Tân Hưng, Quận 7, TP.HCM',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: onSurface,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: surfaceHigh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.chat_bubble, color: primaryColor, size: 14),
                          const SizedBox(width: 6),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  color: onSurfaceVariant,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Ghi chú: ',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.bold,
                                      color: onSurface,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: '"Shipper mang kèm cân điện tử và túi vải niêm phong 3T"',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // WIDGET: ORDER DETAIL CARD
  Widget _buildOrderDetailCard() {
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
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: surfaceHigh,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.receipt_long, color: primaryColor, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Chi tiết đơn hàng',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: onSurface,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: surfaceHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.schedule, size: 12, color: primaryColor),
                    const SizedBox(width: 4),
                    Text(
                      'Chưa thanh toán (Thu sau khi cân)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _buildItemRow('Giặt sấy Tinh Tươm 3T (Ước tính 5.0 kg)', '125.000 đ', subtitle: 'Phân loại & Giặt riêng từng mẻ'),
          const SizedBox(height: 8),
          _buildItemRow('Hương hoa ban mai & Túi seal 3T', 'MIỄN PHÍ (0Đ)', isFree: true, icon: Icons.spa, iconColor: secondaryColor),
          const SizedBox(height: 8),
          _buildItemRow('Phí vận chuyển 2 chiều (Gom & Giao)', 'MIỄN PHÍ', isFree: true, icon: Icons.two_wheeler, iconColor: tertiaryColor),
          const SizedBox(height: 8),
          _buildItemRow('Ưu đãi đơn đầu (WASH3TNEW)', '-20.000 đ', isDiscount: true, icon: Icons.loyalty, iconColor: primaryColor),
          const SizedBox(height: 12),

          // Khung tổng tiền
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: surfaceLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tổng tạm tính:',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: onSurface,
                      ),
                    ),
                    Text(
                      '105.000 đ',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.payments, color: tertiaryColor, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Hình thức thanh toán:',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Thanh toán cho Shipper khi tới cân',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: onSurface,
                          ),
                        ),
                        Text(
                          '(Tiền mặt hoặc VietQR)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            color: outlineColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(height: 1, color: surfaceHigh),
                const SizedBox(height: 6),
                Text(
                  '* Số tiền chính xác sẽ được chốt sau khi Shipper cân thực tế bằng cân điện tử',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    color: outlineColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(
    String title,
    String price, {
    String? subtitle,
    bool isFree = false,
    bool isDiscount = false,
    IconData? icon,
    Color? iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 14, color: iconColor ?? primaryColor),
                    const SizedBox(width: 6),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: subtitle != null ? FontWeight.bold : FontWeight.normal,
                        color: onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: isFree || isDiscount || subtitle != null ? FontWeight.bold : FontWeight.w600,
                color: isDiscount || isFree ? primaryColor : onSurface,
              ),
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.local_laundry_service, size: 12, color: secondaryColor),
              const SizedBox(width: 4),
              Text(
                subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color: onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // WIDGET: COMMITMENT CARD
  Widget _buildCommitmentCard() {
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
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: secondaryFixed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified, color: secondaryColor, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Cam kết Quy trình 3T',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: onSurface,
                    ),
                  ),
                ],
              ),
              Text(
                'Tinh Tươm – Tận Tâm',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Banner Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://images.unsplash.com/photo-1545173168-9f1947eebb7f?q=80&w=600&auto=format&fit=crop',
                  height: 110,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.75)],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 10,
                right: 10,
                child: Row(
                  children: [
                    const Icon(Icons.eco, color: tertiaryFixed, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '100% dung dịch giặt xả sinh học cao cấp an toàn cho da',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 3 Bước quy trình
          _buildStepRow('1', 'Bàn giao đồ & Kẹp Seal', 'Trao đồ cho Shipper 3T và xác thực mã Seal chống thất lạc đồ.', primaryColor),
          const SizedBox(height: 8),
          _buildStepRow('2', 'Kiểm đếm & Cân ký trực tiếp', 'Tiệm phân loại chất liệu, chụp ảnh hiện trạng và cập nhật số ký chuẩn xác.', secondaryColor),
          const SizedBox(height: 8),
          _buildStepRow('3', 'Giám sát quy trình trên App', 'Xem hình ảnh giặt sấy, camera phân loại và tọa độ Shipper giao hàng.', tertiaryColor),
        ],
      ),
    );
  }

  Widget _buildStepRow(String stepNumber, String title, String desc, Color stepColor) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: surfaceLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: stepColor,
            child: Text(
              stepNumber,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: onSurface,
                  ),
                ),
                Text(
                  desc,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET: HOTLINE HỖ TRỢ
  Widget _buildSupportHotline() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.support_agent, size: 18, color: primaryColor),
        const SizedBox(width: 6),
        Text(
          'Tổng đài hỗ trợ 3T: ',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: onSurfaceVariant,
          ),
        ),
        Text(
          '1900 3388 (Miễn phí)',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  // WIDGET: STICKY BOTTOM BAR
  Widget _buildStickyBottomBar(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 20),
        decoration: BoxDecoration(
          color: bgSurface.withOpacity(0.95),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
          border: const Border(top: BorderSide(color: surfaceContainer)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Button 1: Theo dõi tiến độ
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Đang mở trang Theo dõi tiến độ đơn hàng...',
                          style: GoogleFonts.plusJakartaSans(color: Colors.white),
                        ),
                        backgroundColor: primaryColor,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: primaryColor.withOpacity(0.25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  icon: const Icon(Icons.explore, size: 20),
                  label: Text(
                    'Theo dõi tiến độ đơn hàng',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Button 2: Về trang chủ
              SizedBox(
                width: double.infinity,
                height: 40,
                child: TextButton.icon(
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  style: TextButton.styleFrom(
                    backgroundColor: surfaceHigh,
                    foregroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(Icons.home, size: 18),
                  label: Text(
                    'Về trang chủ WashSmart',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}