import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'confirm_receipt_screen.dart'; // Màn hình xác nhận đã nhận hàng

class OrderTrackingScreen extends StatefulWidget {
  // Luồng nhận trạng thái đơn hàng: 'confirmed', 'collecting', 'washing', 'delivering'
  final String orderStatus;

  const OrderTrackingScreen({
    super.key,
    this.orderStatus = 'delivering', // Mặc định 'delivering' để thử nghiệm luồng chuyển màn hình
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen>
    with SingleTickerProviderStateMixin {
  // Brand Color Tokens WashSmart 3T
  static const Color primaryColor = Color(0xFFB90538);
  static const Color primaryContainer = Color(0xFFDC2C4F);
  static const Color primaryFixed = Color(0xFFFFDADB);
  static const Color secondaryColor = Color(0xFFB4136D);
  static const Color secondaryFixed = Color(0xFFFFD9E4);
  static const Color tertiaryColor = Color(0xFF006577);
  static const Color bgSurface = Color(0xFFFFF8F7);
  static const Color cardBg = Colors.white;
  static const Color surfaceLow = Color(0xFFFFF0F0);
  static const Color surfaceContainer = Color(0xFFFFE9EA);
  static const Color surfaceVariant = Color(0xFFFFD9DC);
  static const Color onSurface = Color(0xFF370C14);
  static const Color onSurfaceVariant = Color(0xFF5B4041);
  static const Color outlineVariant = Color(0xFFE3BDBF);

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    // Animation nhấp nháy chấm live & biểu tượng tiến độ
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showActionDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: onSurface,
          ),
        ),
        content: Text(
          content,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Đóng',
              style: GoogleFonts.plusJakartaSans(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF4CD7F6), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF512128),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgSurface,

      // --- 1. HEADER APP BAR ---
      appBar: _buildAppBar(context),

      // --- NỘI DUNG CHÍNH ---
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KHỐI 1: TÓM TẮT KHÁCH HÀNG & TRẠNG THÁI
            _buildCustomerStrip(),
            const SizedBox(height: 12),

            // KHỐI 2: THẺ DỊCH VỤ CHÍNH VỚI ĐỒ HỌA 3T
            _buildMainServiceCard(),
            const SizedBox(height: 12),

            // KHỐI 3: CHI TIẾT ĐỒ GỬI GIẶT (12 MÓN • 5.0 KG)
            _buildGarmentsDetailCard(),
            const SizedBox(height: 12),

            // KHỐI 4: DÒNG THỜI GIAN XỬ LÝ (5 GIAI ĐOẠN)
            _buildTimelineSection(),
            const SizedBox(height: 16),

            // KHỐI 5: NÚT HÀNH ĐỘNG VỚI LUỒNG CHUYỂN MÀN HÌNH
            _buildBottomActions(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- WIDGET 1: HEADER APP BAR ---
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: bgSurface.withOpacity(0.85),
      elevation: 0,
      scrolledUnderElevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: onSurface, size: 22),
        onPressed: () => Navigator.maybePop(context),
      ),
      centerTitle: true,
      title: Column(
        children: [
          Text(
            'Theo Dõi Tiến Độ Đơn Hàng',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeTransition(
                opacity: _pulseController,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '#WS3T-8892',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  letterSpacing: 0.5,
                ),
              ),
            ],
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
    );
  }

  // --- WIDGET 2: TÓM TẮT KHÁCH HÀNG ---
  Widget _buildCustomerStrip() {
    final bool isDelivering = widget.orderStatus == 'delivering';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: secondaryFixed,
                child: Text(
                  'KN',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3E0022),
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Kiều Như',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: onSurface,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: primaryFixed,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.workspace_premium, size: 12, color: primaryColor),
                            const SizedBox(width: 2),
                            Text(
                              'Hạng Vàng',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Hôm nay, 10:24 • Heritage Manor',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'TRẠNG THÁI',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: tertiaryColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  FadeTransition(
                    opacity: _pulseController,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isDelivering ? 'Đang giao hàng' : 'Đang giặt sấy',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- WIDGET 3: THẺ DỊCH VỤ CHÍNH ---
  Widget _buildMainServiceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.local_laundry_service, size: 14, color: primaryColor),
                          const SizedBox(width: 4),
                          Text(
                            'Giặt Sấy Tinh Tươm • 5.0 kg',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Quy Trình Tiêu Chuẩn 3T',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Khử trùng UV 99.9% & Giữ nếp vải cao cấp',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida/AEtjO1UlqQ5xc-vncnLPPs4bDmAB4aR59j2eMOgGfcaif8aFTX_LyrNL8HTnJmRJ7XyCPcBEB6srSbZ4ste2Pmp--vn4PWKVBTl5fsJrSjQlv1sgz3cIh3gghBMppjOBcXDm-YlbN23YCYiF1Di4PIMUqwjy6A3_6nGJ54rBWblQ6uoMLHfn4ohwgDMtJRx3g3k8gPjllVeY6_CeJz7R1myQ_2PZPZX7iJcLEhBfmxtrKyYUQkLjj6p3mEKuEzZl',
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 72,
                        height: 72,
                        color: surfaceContainer,
                        child: const Icon(Icons.dry_cleaning, color: primaryColor),
                      ),
                    ),
                  ),
                  Container(
                    width: 72,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.85),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                    ),
                    child: Text(
                      '5.0 KG',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildFeaturePill(Icons.spa, 'Hoa ban mai', 'Lưu hương 72h', primaryColor),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildFeaturePill(Icons.iron, 'Ủi hơi nước', 'Chống nhăn sâu', primaryColor),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildFeaturePill(Icons.verified_user, '#SEAL-3T-8892', 'Khóa an toàn', tertiaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturePill(IconData icon, String title, String sub, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: surfaceLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            sub,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9,
              color: iconColor == tertiaryColor ? tertiaryColor : onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // --- WIDGET 4: CHI TIẾT ĐỒ GỬI GIẶT ---
  Widget _buildGarmentsDetailCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chi Tiết Đồ Gửi Giặt',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Phân loại & kiểm tra theo tiêu chuẩn 3T',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Tổng: 12 món • 5.0 kg',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _buildGarmentRowItem(
            icon: Icons.dry_cleaning,
            title: 'Áo sơ mi & Áo thun',
            sub: 'Giặt sấy & Ủi hơi nước',
            count: '5 cái',
          ),
          const SizedBox(height: 8),

          _buildGarmentRowItem(
            icon: Icons.checkroom,
            title: 'Quần tây & Quần jean',
            sub: 'Giặt sấy & Ủi tạo nếp',
            count: '3 cái',
          ),
          const SizedBox(height: 8),

          // Đã sửa icon thành Icons.style chuẩn SDK Flutter
          _buildGarmentRowItem(
            icon: Icons.style,
            title: 'Đầm công sở / Váy vải lụa',
            sub: 'Giặt sấy nhiệt dịu',
            count: '2 cái',
          ),
          const SizedBox(height: 8),

          _buildGarmentRowItem(
            icon: Icons.soap,
            title: 'Khăn tắm & Đồ cotton',
            sub: 'Khử khuẩn UV & Xịt thơm',
            count: '2 cái',
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: outlineVariant,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified, size: 16, color: tertiaryColor),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Đã kiểm đếm & bấm mã Seal niêm phong trước mặt khách',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: tertiaryColor,
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

  Widget _buildGarmentRowItem({
    required IconData icon,
    required String title,
    required String sub,
    required String count,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: surfaceLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: primaryFixed.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: primaryColor),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: onSurface,
                    ),
                  ),
                  Text(
                    sub,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET 5: TIMELINE 5 GIAI ĐOẠN ---
  Widget _buildTimelineSection() {
    final bool isDelivering = widget.orderStatus == 'delivering';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dòng Thời Gian Xử Lý',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: onSurface,
                    ),
                  ),
                  Text(
                    'Cập nhật tức thời theo cảm biến máy & Shipper',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryFixed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isDelivering ? 'Giai đoạn 5/5' : 'Giai đoạn 3/5',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Stack(
            children: [
              // Line base
              Positioned(
                left: 11,
                top: 12,
                bottom: 12,
                child: Container(
                  width: 2,
                  color: surfaceVariant,
                ),
              ),
              // Line overlay
              Positioned(
                left: 11,
                top: 12,
                height: isDelivering ? 320 : 215,
                child: Container(
                  width: 2,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, primaryContainer],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              Column(
                children: [
                  // Stage 1
                  _buildTimelineNode(
                    icon: Icons.check,
                    isFinished: true,
                    title: 'Đã tiếp nhận đơn hàng',
                    time: '10:15',
                    desc: 'Cân điện tử xác nhận 5.0 kg tại sảnh Heritage Manor.',
                  ),
                  const SizedBox(height: 16),

                  // Stage 2
                  _buildTimelineNode(
                    icon: Icons.check,
                    isFinished: true,
                    title: 'Shipper đã nhận & Khóa seal',
                    time: '11:05',
                    desc: 'Mã seal bảo mật #SEAL-3T-8892 được bấm chốt nguyên vẹn.',
                    badge: '#SEAL-3T-8892',
                  ),
                  const SizedBox(height: 16),

                  // Stage 3
                  if (isDelivering)
                    _buildTimelineNode(
                      icon: Icons.check,
                      isFinished: true,
                      title: 'Giặt sấy & Khử khuẩn UV 99.9%',
                      time: '14:30',
                      desc: 'Lồng giặt riêng M-08 sấy nhiệt dịu 55°C + hương hoa ban mai.',
                    )
                  else
                    _buildTimelineActiveNode(),
                  const SizedBox(height: 16),

                  // Stage 4
                  _buildTimelineNode(
                    icon: isDelivering ? Icons.check : Icons.inventory_2,
                    isFinished: isDelivering,
                    isUpcoming: !isDelivering,
                    title: 'Đóng gói chống thấm & Niêm phong',
                    time: isDelivering ? '15:15' : 'Sắp tới • 15:45',
                    desc: 'Gấp nếp tinh tươm vào túi vải chuyên dụng 3T kháng bụi nước.',
                  ),
                  const SizedBox(height: 16),

                  // Stage 5
                  if (isDelivering)
                    _buildTimelineActiveDeliveryNode()
                  else
                    _buildTimelineNode(
                      icon: Icons.local_shipping,
                      isUpcoming: true,
                      title: 'Đang giao hàng tận cửa',
                      time: 'Dự kiến • 16:30',
                      desc: 'Kiểm tra tem niêm phong seal bảo mật #SEAL-3T-8892 trước khi nhận.',
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineNode({
    required IconData icon,
    bool isFinished = false,
    bool isUpcoming = false,
    required String title,
    required String time,
    required String desc,
    String? badge,
  }) {
    return Opacity(
      opacity: isUpcoming ? 0.6 : 1.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isFinished
                  ? primaryColor
                  : (isUpcoming ? surfaceVariant : primaryFixed),
              shape: BoxShape.circle,
              border: Border.all(color: cardBg, width: 2),
            ),
            child: Icon(
              icon,
              size: 13,
              color: isFinished ? Colors.white : onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: surfaceLow,
                borderRadius: BorderRadius.circular(10),
              ),
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
                      Text(
                        time,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: onSurfaceVariant),
                      children: [
                        TextSpan(text: desc),
                        if (badge != null) ...[
                          const WidgetSpan(child: SizedBox(width: 4)),
                          WidgetSpan(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: primaryFixed,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                badge,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineActiveNode() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeTransition(
          opacity: _pulseController,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
              border: Border.all(color: primaryFixed, width: 3),
              boxShadow: [
                BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 6),
              ],
            ),
            child: const Icon(Icons.sync, size: 14, color: Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryFixed.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Giặt sấy & Khử khuẩn UV 99.9%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '70% Xong',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Lồng giặt số M-08 đang chạy sấy nhiệt dịu 55°C chống nhăn + xịt vi hạt hương hoa ban mai.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cardBg.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.shield_outlined, size: 16, color: tertiaryColor),
                          const SizedBox(width: 6),
                          Text(
                            'Lồng giặt riêng biệt 1 máy / 1 khách',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: onSurface,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'An tâm 100%',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: tertiaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    height: 6,
                    color: surfaceVariant,
                    child: Row(
                      children: [
                        Expanded(flex: 70, child: Container(color: primaryColor)),
                        Expanded(flex: 30, child: Container(color: Colors.transparent)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineActiveDeliveryNode() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeTransition(
          opacity: _pulseController,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
              border: Border.all(color: primaryFixed, width: 3),
              boxShadow: [
                BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 6),
              ],
            ),
            child: const Icon(Icons.two_wheeler, size: 14, color: Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryFixed.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Đang giao hàng tận cửa',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Đến trong ~15 phút',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Shipper đang di chuyển tới sảnh Heritage Manor. Vui lòng kiểm tra tem seal #SEAL-3T-8892.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- WIDGET 6: NÚT HÀNH ĐỘNG VỚI LUỒNG CHUYỂN MÀN HÌNH ---
  Widget _buildBottomActions(BuildContext context) {
    final bool canConfirm = widget.orderStatus == 'delivering';

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // 🚀 LUỒNG CHUYỂN MÀN HÌNH: Kiểm tra trạng thái đơn hàng
              if (canConfirm) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConfirmReceiptScreen(),
                  ),
                );
              } else {
                // Nếu chưa tới bước giao hàng thì báo SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Đơn hàng đang giặt sấy. Bạn chỉ có thể xác nhận khi Shipper bắt đầu giao đồ!',
                            style: GoogleFonts.plusJakartaSans(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: const Color(0xFF512128),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: primaryColor.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Đã nhận được hàng',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.check_circle, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => _showActionDialog(
                context,
                'Khiếu nại sự cố đồ giặt',
                'Hệ thống tiếp nhận phản hồi & chuyên viên CSKH 3T sẽ liên hệ bạn trong 15 phút.',
              ),
              child: Row(
                children: [
                  const Icon(Icons.report_problem_outlined, size: 14, color: primaryColor),
                  const SizedBox(width: 4),
                  Text(
                    'Khiếu nại sự cố đồ giặt',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text('•', style: TextStyle(color: outlineVariant)),
            ),
            InkWell(
              onTap: () => _showToast('Đang tải hóa đơn điện tử...'),
              child: Row(
                children: [
                  const Icon(Icons.receipt_long, size: 14, color: onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    'Xem hóa đơn điện tử',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}