import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'confirm_receipt_screen.dart'; // 🚀 Giữ nguyên luồng chuyển màn hình xác nhận

class OrderTrackingScreen extends StatelessWidget {
  // 🚀 Giữ nguyên luồng trạng thái đơn hàng: 'confirmed', 'collecting', 'washing', 'delivering'
  final String orderStatus;

  const OrderTrackingScreen({
    super.key,
    this.orderStatus = 'delivering', // Mặc định là 'delivering' để kiểm thử
  });

  // Bảng màu chuẩn Brand Tokens WashSmart 3T theo HTML config mới
  static const Color primaryColor = Color(0xFFB90538);
  static const Color primaryContainer = Color(0xFFDC2C4F);
  static const Color secondaryColor = Color(0xFFB4136D);
  static const Color tertiaryColor = Color(0xFF006577);
  static const Color bgSurface = Color(0xFFFFF8F7);
  static const Color cardBg = Colors.white;
  static const Color surfaceLow = Color(0xFFFFF0F0);
  static const Color surfaceContainer = Color(0xFFFFE9EA);
  static const Color surfaceHigh = Color(0xFFFFE1E3);
  static const Color onSurface = Color(0xFF370C14);
  static const Color onSurfaceVariant = Color(0xFF5B4041);
  static const Color outlineColor = Color(0xFF8F6F71);

  // 🚀 Giữ nguyên luồng hiển thị Hộp thoại thông báo cũ
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgSurface,

      // --- 1. APP BAR (Giao diện mới + Nút luồng cũ) ---
      appBar: AppBar(
        backgroundColor: bgSurface.withOpacity(0.95),
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: onSurface, size: 22),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chi tiết đơn hàng',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: onSurface,
              ),
            ),
            Text(
              '#WS3T-8892',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: onSurfaceVariant, size: 22),
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
          ),
          IconButton(
            icon: const Icon(Icons.headset_mic_outlined, color: primaryColor, size: 22),
            onPressed: () => _showActionDialog(
              context,
              'Tổng đài CSKH 3T',
              'Đang kết nối tới hotline hỗ trợ: 1900 3388 (Miễn phí 24/7)',
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),

      // --- NỘI DUNG CHÍNH ---
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 140),
            child: Column(
              children: [
                // KHỐI 1: TRẠNG THÁI & STEPPER TIẾN TRÌNH (Theo orderStatus cũ)
                _buildStatusTrackerCard(),
                const SizedBox(height: 12),

                // KHỐI 2: GÓI GIẶT & DANH SÁCH MÓN ĐỒ GỬI (Kết hợp giao diện mới & luồng cũ)
                _buildPackageAndGarmentsCard(),
                const SizedBox(height: 12),

                // KHỐI 3: ĐỊA CHỈ & LỊCH HẸN GIAO NHẬN
                _buildDeliveryScheduleCard(),
                const SizedBox(height: 12),

                // KHỐI 4: CHI TIẾT BẢNG KÊ THANH TOÁN
                _buildPaymentCard(),
              ],
            ),
          ),

          // STICKY BOTTOM ACTIONS (Giữ nguyên luồng kiểm tra điều kiện nút xác nhận)
          _buildStickyBottomActionBar(context),
        ],
      ),
    );
  }

  // --- KHỐI 1: STATUS TRACKER & STEPPER CARD ---
  Widget _buildStatusTrackerCard() {
    final bool isDelivering = orderStatus == 'delivering';

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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
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
                      isDelivering
                          ? 'Shipper đang giao đồ sạch tới bạn'
                          : 'Đang xử lý giặt sấy chuyên sâu',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: surfaceContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '#WS3T-8892',
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

          // Progress Tracker (Dynamic theo orderStatus)
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 14,
                left: 24,
                right: 24,
                child: Container(
                  height: 3,
                  color: primaryColor,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildProgressStep('1', 'Đặt đơn', '13:30', isDone: true),
                  _buildProgressStep('2', 'Cân & Seal', '14:15 • 5.0kg', isDone: true),
                  _buildProgressStep(
                    '3',
                    'Giặt sấy 3T',
                    isDelivering ? 'Hoàn tất' : 'Đang xử lý',
                    isDone: isDelivering,
                    isActive: orderStatus == 'washing',
                  ),
                  _buildProgressStep(
                    '4',
                    'Đang giao',
                    isDelivering ? '15-20 phút' : 'Chờ giao',
                    isActive: isDelivering,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Shipper Tracking Banner Box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: surfaceLow,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: surfaceHigh),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.local_shipping, color: primaryColor, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isDelivering
                              ? 'Shipper Nguyễn Văn Nam đang tới Chung cư Sunrise City'
                              : 'Tiệm giặt đang phân loại & hấp diệt khuẩn vải',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  isDelivering ? '~15 phút' : 'Đang xử lý',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStep(String step, String label, String time, {bool isDone = false, bool isActive = false}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: isActive ? primaryColor : (isDone ? primaryColor : surfaceHigh),
          child: isActive
              ? const Icon(Icons.two_wheeler, size: 15, color: Colors.white)
              : (isDone
                  ? const Icon(Icons.check, size: 15, color: Colors.white)
                  : Text(
                      step,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: onSurfaceVariant,
                      ),
                    )),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
            color: isActive ? primaryColor : onSurface,
          ),
        ),
        Text(
          time,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive ? primaryColor : onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  // --- KHỐI 2: PACKAGE & GARMENT LIST CARD ---
  Widget _buildPackageAndGarmentsCard() {
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
          // Tiêu đề gói
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.local_laundry_service, color: primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Gói Giặt sấy Tinh Tươm 3T',
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
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Ước tính 5.0 kg',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Quy đổi món
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: surfaceLow,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: surfaceHigh),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.scale, color: primaryColor, size: 16),
                    const SizedBox(width: 6),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: onSurfaceVariant,
                        ),
                        children: [
                          const TextSpan(text: 'Quy đổi: '),
                          TextSpan(
                            text: '~15–18 món quần áo',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.bold,
                              color: onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  '25.000đ/kg',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 🚀 GIỮ NGUYÊN DANH SÁCH MÓN ĐỒ TỪ CODE CŨ (4 MỤC • 7 MÓN)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DANH SÁCH ĐỒ GỬI (4 MỤC • 7 MÓN)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: outlineColor,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Đã kiểm KCS',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          _buildGarmentItem(
            icon: Icons.dry_cleaning,
            title: 'Áo sơ mi công sở & áo thun',
            desc: 'Giặt sấy diệt khuẩn & Là phẳng',
            quantity: 'x3',
          ),
          const SizedBox(height: 6),
          _buildGarmentItem(
            icon: Icons.straighten,
            title: 'Quần tây âu & quần jean',
            desc: 'Giặt hấp giữ nếp, khử khuẩn UV',
            quantity: 'x2',
          ),
          const SizedBox(height: 6),
          _buildGarmentItem(
            icon: Icons.layers,
            title: 'Áo khoác gió lót lụa',
            desc: 'Giặt khô nhẹ tay, chống thấm',
            quantity: 'x1',
          ),
          const SizedBox(height: 6),
          _buildGarmentItem(
            icon: Icons.checkroom,
            title: 'Đầm lụa hồng pastel',
            desc: 'Giặt tay chuyên sâu, ủi hơi nước',
            quantity: 'x1',
            isHighlight: true,
          ),
          const SizedBox(height: 12),

          // Dịch vụ kèm theo
          Text(
            'DỊCH VỤ KÈM THEO & BỔ SUNG',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: outlineColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),

          _buildPerkRow(
            icon: Icons.local_florist,
            title: 'Hương hoa ban mai cao cấp',
            subtitle: 'Tinh dầu thơm dịu lưu hương 48h',
            tag: 'Miễn phí 0đ',
          ),
          const SizedBox(height: 6),
          _buildPerkRow(
            icon: Icons.verified,
            title: 'Túi vải niêm phong chống nước 3T',
            subtitle: 'Bảo mật seal mã QR một chiều',
            tag: 'Miễn phí 0đ',
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primaryColor.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: primaryColor, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Cân đo thực tế tại xưởng 3T',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: onSurface,
                      ),
                    ),
                  ],
                ),
                Text(
                  '5.0 kg (Chuẩn khớp)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGarmentItem({
    required IconData icon,
    required String title,
    required String desc,
    required String quantity,
    bool isHighlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: surfaceLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: surfaceHigh),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: surfaceContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: isHighlight ? secondaryColor : primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: onSurface,
                    ),
                  ),
                  Text(
                    desc,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: outlineColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: surfaceHigh,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              quantity,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isHighlight ? secondaryColor : primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerkRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required String tag,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(icon, color: primaryColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        subtitle,
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
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              tag,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- KHỐI 3: DELIVERY & SCHEDULE CARD ---
  Widget _buildDeliveryScheduleCard() {
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
                  const Icon(Icons.location_on, color: primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Địa chỉ & Lịch hẹn',
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
                  color: surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Giao nhận tận cửa',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: surfaceHigh),
          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.person, size: 16, color: outlineColor),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chị Kiều Như • 0988 ••• 321',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'P.14.02, Tháp B – Chung cư Sunrise City, Đường Nguyễn Hữu Thọ, P. Tân Hưng, Q.7, TP.HCM',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: onSurfaceVariant,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.two_wheeler, size: 16, color: primaryColor),
              const SizedBox(width: 8),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: onSurfaceVariant,
                  ),
                  children: [
                    const TextSpan(text: 'Đang giao hàng: '),
                    TextSpan(
                      text: 'Dự kiến đến trong 15–20 phút',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(Icons.event_available, size: 16, color: outlineColor),
              const SizedBox(width: 8),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: onSurfaceVariant,
                  ),
                  children: [
                    const TextSpan(text: 'Thời gian giao trả: '),
                    TextSpan(
                      text: 'Trước 12:00 trưa mai',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
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
    );
  }

  // --- KHỐI 4: PAYMENT & BILLING CARD ---
  Widget _buildPaymentCard() {
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
                  const Icon(Icons.receipt_long, color: primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Chi tiết thanh toán',
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
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Đã cân thực tế: 5.0 kg',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: surfaceHigh),
          const SizedBox(height: 12),

          _buildBillingRow('Gói giặt sấy thực tế (5.0 kg x 25.000đ)', '125.000 đ'),
          const SizedBox(height: 6),
          _buildBillingRow('Hương hoa ban mai & Túi niêm phong', '0 đ (Miễn phí)', isFree: true),
          const SizedBox(height: 6),
          _buildBillingRow('Phí vận chuyển 2 chiều', 'Miễn phí', isFree: true),
          const SizedBox(height: 6),
          _buildBillingRow('Voucher ưu đãi (WASH3TNEW)', '-20.000 đ', isDiscount: true),
          const SizedBox(height: 10),
          const Divider(height: 1, color: surfaceHigh),
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
                    'TỔNG THANH TOÁN',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: onSurface,
                    ),
                  ),
                  Text(
                    'Thanh toán khi nhận đồ sạch',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: outlineColor,
                    ),
                  ),
                ],
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
          const SizedBox(height: 12),

          // Mã Seal túi
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: surfaceLow,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: surfaceHigh),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.verified, size: 16, color: primaryColor),
                    const SizedBox(width: 6),
                    Text(
                      'Mã Seal túi: #SEAL-3T-8892 (Nguyên vẹn)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '* Bạn kiểm tra seal niêm phong cùng Shipper trước khi nhận đồ và thanh toán.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
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

  Widget _buildBillingRow(String label, String value, {bool isFree = false, bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: isFree || isDiscount ? FontWeight.w600 : FontWeight.normal,
            color: isFree || isDiscount ? primaryColor : onSurface,
          ),
        ),
      ],
    );
  }

  // --- 🚀 STICKY BOTTOM ACTIONS BAR (GIỮ NGUYÊN LUỒNG ĐIỀU KIỆN XÁC NHẬN) ---
  Widget _buildStickyBottomActionBar(BuildContext context) {
    final bool canConfirm = orderStatus == 'delivering';

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
              // 🚀 Nút hành động chính: Kiểm tra điều kiện canConfirm
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (canConfirm) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConfirmReceiptScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.info_outline, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Đơn hàng đang xử lý/giặt sấy. Bạn chỉ có thể xác nhận khi Shipper bắt đầu giao đồ!',
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
                    backgroundColor: canConfirm ? primaryColor : Colors.grey.shade400,
                    elevation: canConfirm ? 4 : 0,
                    shadowColor: primaryColor.withOpacity(0.25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            canConfirm ? Icons.verified : Icons.lock_clock,
                            size: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            canConfirm ? 'Xác nhận đã nhận hàng' : 'Chờ giao hàng để xác nhận',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        canConfirm ? Icons.arrow_forward : Icons.info_outline,
                        size: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Nút phụ: Hotline CSKH
              SizedBox(
                width: double.infinity,
                height: 40,
                child: TextButton.icon(
                  onPressed: () => _showActionDialog(
                    context,
                    'Tổng đài CSKH WashSmart 3T',
                    'Đang kết nối tới hotline hỗ trợ: 1900 3388 (Miễn phí 24/7)',
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: surfaceContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(Icons.support_agent, size: 18, color: primaryColor),
                  label: Text(
                    'Hotline hỗ trợ: 1900 3388',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
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