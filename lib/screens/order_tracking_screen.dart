import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'confirm_receipt_screen.dart';

class OrderTrackingScreen extends StatelessWidget {
  // Trạng thái đơn hàng: 'confirmed' (Xác nhận), 'collecting' (Gom đồ), 'washing' (Giặt sấy), 'delivering' (Đang giao)
  final String orderStatus;

  const OrderTrackingScreen({
    super.key,
    this.orderStatus = 'delivering', // Mặc định là 'delivering' để kiểm thử
  });

  // Bảng màu thiết kế chuẩn Brand Tokens WashSmart 3T
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
  static const Color outlineColor = Color(0xFF8F6F71);

  void _showActionDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Text(
          content,
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Đóng',
              style: GoogleFonts.plusJakartaSans(color: primaryColor, fontWeight: FontWeight.bold),
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

      // 1. APP BAR
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
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: onSurface,
              ),
            ),
            Text(
              '#WS3T-8892',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: onSurface, size: 22),
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
          ),
          IconButton(
            icon: const Icon(Icons.headset_mic_outlined, color: primaryColor, size: 22),
            onPressed: () => _showActionDialog(
              context,
              'Tổng đài 3T',
              'Đang gọi Hotline hỗ trợ: 1900 3388 (24/7)',
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),

      // 2. NỘI DUNG CHÍNH
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            // KHỐI 1: TRẠNG THÁI & STEPPER TIẾN TRÌNH GIAO HÀNG
            _buildStatusTrackerCard(),
            const SizedBox(height: 14),

            // KHỐI 2: DANH SÁCH ĐỒ GỬI (4 MỤC • 7 MÓN)
            _buildItemsListCard(),
            const SizedBox(height: 14),

            // KHỐI 3: GIAO NHẬN & THANH TOÁN
            _buildDeliveryPaymentCard(),
            const SizedBox(height: 20),

            // KHỐI 4: CỤM NÚT HÀNH ĐỘNG (KIỂM TRA ĐIỀU KIỆN XÁC NHẬN)
            _buildActionButtons(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // --- KHỐI 1: STATUS TRACKER & STEPPER CARD ---
  Widget _buildStatusTrackerCard() {
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      orderStatus == 'delivering'
                          ? 'Đang giao tới cửa • Sắp hoàn tất'
                          : 'Đang xử lý giặt sấy',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
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
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '#SEAL-3T-8892',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 14,
                left: 30,
                right: 30,
                child: Container(
                  height: 3,
                  color: primaryColor,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStepNode(Icons.check, 'Xác nhận', isDone: true),
                  _buildStepNode(Icons.check, 'Gom đồ', isDone: true),
                  _buildStepNode(
                    orderStatus == 'delivering' ? Icons.check : Icons.local_laundry_service,
                    'Giặt sấy',
                    isDone: orderStatus == 'delivering',
                    isActive: orderStatus == 'washing',
                  ),
                  _buildStepNode(
                    Icons.where_to_vote,
                    'Đang giao',
                    isActive: orderStatus == 'delivering',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: surfaceLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.local_shipping, size: 18, color: primaryColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          orderStatus == 'delivering'
                              ? 'Shipper đã gửi đồ tại sảnh lễ tân Căn 302'
                              : 'Cửa hàng đang xử lý đồ giặt tươm tất',
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
                  '16:20',
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

  Widget _buildStepNode(IconData icon, String label, {bool isDone = false, bool isActive = false}) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isActive ? primaryContainer : (isDone ? primaryColor : Colors.grey.shade300),
            shape: BoxShape.circle,
            boxShadow: [
              if (isActive || isDone)
                BoxShadow(
                  color: primaryColor.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Icon(
            icon,
            size: 15,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive || isDone ? primaryColor : outlineColor,
          ),
        ),
      ],
    );
  }

  // --- KHỐI 2: DANH SÁCH ĐỒ GỬI CARD ---
  Widget _buildItemsListCard() {
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
                  const Icon(Icons.checkroom, color: primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Danh sách đồ gửi (4 mục • 7 món)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
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
                  'Đã kiểm KCS',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _buildGarmentItem(
            icon: Icons.dry_cleaning,
            title: 'Áo sơ mi công sở & áo thun',
            desc: 'Giặt sấy diệt khuẩn & Là phẳng',
            quantity: 'x3',
          ),
          const SizedBox(height: 8),
          _buildGarmentItem(
            icon: Icons.straighten,
            title: 'Quần tây âu & quần jean',
            desc: 'Giặt hấp giữ nếp, khử khuẩn UV',
            quantity: 'x2',
          ),
          const SizedBox(height: 8),
          _buildGarmentItem(
            icon: Icons.layers,
            title: 'Áo khoác gió lót lụa',
            desc: 'Giặt khô nhẹ tay, chống thấm',
            quantity: 'x1',
          ),
          const SizedBox(height: 8),
          _buildGarmentItem(
            icon: Icons.checkroom,
            title: 'Đầm lụa hồng pastel',
            desc: 'Giặt tay chuyên sâu, ủi hơi nước',
            quantity: 'x1',
            isHighlight: true,
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
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: surfaceLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: surfaceHigh),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: surfaceContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: isHighlight ? secondaryColor : primaryColor,
                ),
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
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isHighlight ? secondaryColor : primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- KHỐI 3: GIAO NHẬN & THANH TOÁN CARD ---
  Widget _buildDeliveryPaymentCard() {
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
                  const Icon(Icons.receipt_long, color: primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Giao nhận & Thanh toán',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
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
                  'Đã thanh toán',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: outlineColor),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chị Kiều Như • 0988 321 •••',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: onSurface,
                      ),
                    ),
                    Text(
                      'Căn 302, Chung cư Heritage Manor, 128 Hai Bà Trưng, Q.1',
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
          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.schedule, size: 16, color: outlineColor),
              const SizedBox(width: 6),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: outlineColor),
                  children: [
                    const TextSpan(text: 'Giao trả: '),
                    TextSpan(
                      text: 'Hôm nay trước 17:00',
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
          const SizedBox(height: 12),
          const Divider(height: 1, color: surfaceHigh),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'VietQR MBBank',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: outlineColor,
                ),
              ),
              Row(
                children: [
                  Text(
                    '145.000 đ',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(Đã gồm 8% VAT)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: outlineColor,
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

  // --- KHỐI 4: CỤM NÚT HÀNH ĐỘNG DỰA TRÊN TRẠNG THÁI ---
  Widget _buildActionButtons(BuildContext context) {
    final bool canConfirm = orderStatus == 'delivering';

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
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
              shadowColor: primaryColor.withOpacity(0.35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      canConfirm ? Icons.verified : Icons.lock_clock,
                      color: Colors.white,
                      size: 20,
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
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          height: 44,
          child: TextButton.icon(
            onPressed: () => _showActionDialog(
              context,
              'Tổng đài CSKH WashSmart 3T',
              'Đang kết nối tới hotline hỗ trợ: 1900 3388 (24/7)',
            ),
            style: TextButton.styleFrom(
              backgroundColor: surfaceContainer,
              foregroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            icon: const Icon(Icons.support_agent, size: 18),
            label: Text(
              'Hotline hỗ trợ: 1900 3388',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}