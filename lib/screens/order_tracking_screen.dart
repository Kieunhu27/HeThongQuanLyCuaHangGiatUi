import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'confirm_receipt_screen.dart'; // 🚀 1. Import màn hình Xác nhận đã nhận hàng

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  // Bảng màu thiết kế chuẩn WashSmart 3T
  static const Color primaryColor = Color(0xFFB90538);
  static const Color primaryContainer = Color(0xFFDC2C4F);
  static const Color secondaryColor = Color(0xFFB4136D);
  static const Color tertiaryColor = Color(0xFF006577);
  static const Color bgSurface = Color(0xFFFFF8F7);
  static const Color cardBg = Colors.white;
  static const Color surfaceLow = Color(0xFFFFF0F0);
  static const Color surfaceHigh = Color(0xFFFFE1E3);
  static const Color onSurface = Color(0xFF370C14);
  static const Color outlineColor = Color(0xFF8F6F71);

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF4CD7F6), size: 18),
            const SizedBox(width: 8),
            Text(
              'Đã sao chép $label vào bộ nhớ tạm!',
              style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 12),
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
      appBar: AppBar(
        backgroundColor: bgSurface.withOpacity(0.95),
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: onSurface, size: 22),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          'Chi tiết đơn hàng',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: outlineColor, size: 22),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            // 1. MÃ ĐƠN HÀNG & BƯỚC TIẾN TRÌNH CHÍNH
            _buildOrderHeaderCard(context),
            const SizedBox(height: 12),

            // 2. MÃ SEAL NIÊM PHONG AN TOÀN
            _buildSealCard(),
            const SizedBox(height: 12),

            // 3. DỊCH VỤ & ĐỒ GỬI
            _buildServicesSummaryCard(),
            const SizedBox(height: 12),

            // 4. LỊCH SỬ BƯỚC TIẾN ĐỘ TỪNG CHẶNG (TIMELINE)
            _buildTimelineProgressCard(),
            const SizedBox(height: 12),

            // 5. ĐỊA CHỈ & THỜI GIAN LẤY / GIAO
            _buildAddressAndTimeCard(),
            const SizedBox(height: 12),

            // 6. THÔNG TIN THANH TOÁN
            _buildPaymentSummaryCard(),
            const SizedBox(height: 16),

            // 7. THẺ XÁC NHẬN ĐÃ NHẬN HÀNG & HOTLINE
            _buildConfirmationSection(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // --- 1. ORDER HEADER & MAIN PROGRESS BAR ---
  Widget _buildOrderHeaderCard(BuildContext context) {
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
                  Text(
                    '#WS3T-8892',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: onSurface,
                    ),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () => _copyToClipboard(context, '#WS3T-8892', 'Mã đơn'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: surfaceLow,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.content_copy, size: 14, color: primaryColor),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.schedule, size: 14, color: outlineColor),
                  const SizedBox(width: 4),
                  Text(
                    '24/10/2023, 10:24',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: outlineColor),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text(
                  'Túi đồ đã giao tới nơi • Sẵn sàng mở niêm phong',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 4 Node Tiến trình chính
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 14,
                left: 20,
                right: 20,
                child: Container(height: 3, color: primaryColor),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMainStepNode(Icons.check, 'Xác nhận', isDone: true),
                  _buildMainStepNode(Icons.check, 'Gom đồ', isDone: true),
                  _buildMainStepNode(Icons.check, 'Giặt sấy', isDone: true),
                  _buildMainStepNode(Icons.where_to_vote, 'Giao trả', isCurrent: true),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainStepNode(IconData icon, String label, {bool isDone = false, bool isCurrent = false}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: isCurrent ? primaryContainer : primaryColor,
          child: Icon(icon, size: 14, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
            color: isCurrent ? primaryColor : onSurface,
          ),
        ),
      ],
    );
  }

  // --- 2. SEAL CARD ---
  Widget _buildSealCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(color: surfaceLow, shape: BoxShape.circle),
                child: const Icon(Icons.verified_user, color: primaryColor, size: 18),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Khóa Seal chống tráo đổi',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: onSurface),
                  ),
                  Text(
                    'Kiểm tra chốt seal khi giao nhận',
                    style: GoogleFonts.plusJakartaSans(fontSize: 10, color: outlineColor),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: surfaceLow, borderRadius: BorderRadius.circular(6)),
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
    );
  }

  // --- 3. SERVICES SUMMARY CARD ---
  Widget _buildServicesSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.inventory_2, color: primaryColor, size: 18),
              const SizedBox(width: 6),
              Text(
                'Dịch vụ & Đồ gửi',
                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold, color: onSurface),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: surfaceLow, borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Giặt Sấy Tinh Tươm (5.0 kg)',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: onSurface),
                    ),
                    Text(
                      '125.000 đ',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Kèm ủi hơi nước chống nhăn (+20.000 đ) & Túi niêm phong 3T (Miễn phí)',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: outlineColor),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ghi chú: Áo lụa hồng giặt nhẹ tay, bấm chuông căn 302.',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, fontStyle: FontStyle.italic, color: primaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. TIMELINE PROGRESS CARD ---
  Widget _buildTimelineProgressCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
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
                  const Icon(Icons.check_circle, color: primaryColor, size: 20),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TRẠNG THÁI HIỆN TẠI',
                        style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.bold, color: outlineColor),
                      ),
                      Text(
                        'GIẶT SẤY HOÀN TẤT • ĐÃ TỚI ĐIỂM GIAO',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(12)),
                child: Text(
                  'Bước 5/5',
                  style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: surfaceLow, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Icon(Icons.task_alt, color: primaryColor, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: onSurface),
                      children: [
                        const TextSpan(text: 'Đã hoàn thành giặt sấy & ủi thơm: '),
                        TextSpan(
                          text: '15:45 Hôm nay',
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: primaryColor),
                        ),
                        const TextSpan(text: ' (Đúng tiến độ)'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Danh sách 5 bước Timeline
          _buildTimelineItem(
            step: '1',
            title: '1. Đã gom đồ & Khóa niêm phong',
            time: '14:15',
            subtitle: 'Túi seal an toàn #SEAL-3T-8892 đã chốt.',
            isDone: true,
          ),
          _buildTimelineItem(
            step: '2',
            title: '2. Phân loại & Giặt sạch chuyên sâu',
            time: '14:45',
            subtitle: 'Đã giặt nước ấm 40°C & Khử khuẩn tia UV chuyên sâu - ĐÃ XONG',
            isDone: true,
          ),
          _buildTimelineItem(
            step: '3',
            title: '3. Sấy khô & Ủi hơi nước chống nhăn',
            time: '15:20',
            subtitle: 'Sấy nhiệt kiểm soát sợi vải & ủi phẳng phiu - ĐÃ XONG',
            isDone: true,
          ),
          _buildTimelineItem(
            step: '4',
            title: '4. KCS & Đóng gói túi thơm 3T',
            time: '15:45',
            subtitle: 'Kiểm tra từng chiếc áo quần, gấp gọn & xịt thơm hoa anh đào - ĐÃ XONG',
            isDone: true,
          ),
          _buildTimelineItem(
            step: '5',
            title: '5. Giao trả đồ sạch tận nơi',
            time: '16:20',
            subtitle: 'Shipper đã gửi đồ tại sảnh lễ tân Căn 302 Heritage Manor - Đang đợi khách nhận',
            isActive: true,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String step,
    required String title,
    required String time,
    required String subtitle,
    bool isDone = false,
    bool isActive = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 11,
                backgroundColor: isActive ? primaryContainer : primaryColor,
                child: Icon(
                  isActive ? Icons.where_to_vote : Icons.check,
                  size: 12,
                  color: Colors.white,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: primaryColor,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
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
                          fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                          color: isActive ? primaryColor : onSurface,
                        ),
                      ),
                      Text(
                        time,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                          color: isActive ? primaryColor : outlineColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: isActive ? primaryColor : outlineColor,
                      fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
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

  // --- 5. ADDRESS & TIME CARD ---
  Widget _buildAddressAndTimeCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: primaryColor, size: 18),
              const SizedBox(width: 6),
              Text(
                'Địa chỉ & Thời gian',
                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold, color: onSurface),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Chị Kiều Như • 0988 321 •••',
            style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: onSurface),
          ),
          const SizedBox(height: 2),
          Text(
            'Căn 302, Chung cư Heritage Manor, 128 Hai Bà Trưng, P. Bến Nghé, Quận 1',
            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: outlineColor),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: surfaceLow, borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Thu gom:', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: outlineColor)),
                      Text(
                        'Hôm nay 14:00 - 16:00',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold, color: primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: surfaceLow, borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Giao trả:', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: outlineColor)),
                      Text(
                        'Ngày mai trước 11:00',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold, color: secondaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 6. PAYMENT SUMMARY CARD ---
  Widget _buildPaymentSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Tổng thanh toán: ', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: outlineColor)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(color: surfaceHigh, borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      'Đã thanh toán',
                      style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'VietQR MBBank (VQR8892KN)',
                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: outlineColor),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '145.000 đ',
                style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
              ),
              Text('Đã gồm 8% VAT', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: outlineColor)),
            ],
          ),
        ],
      ),
    );
  }

  // --- 7. CONFIRMATION & HOTLINE SECTION ---
  Widget _buildConfirmationSection(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primaryColor.withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: surfaceHigh, borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      'ĐƠN HÀNG ĐÃ TỚI NƠI',
                      style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                  ),
                  Text(
                    '#WS3T-8892',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(color: surfaceLow, shape: BoxShape.circle),
                    child: const Icon(Icons.mark_email_read, color: primaryColor, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bấm để kiểm tra & Xác nhận đã nhận đồ',
                          style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold, color: onSurface),
                        ),
                        Text(
                          'Kiểm tra mã seal niêm phong, kiểm đếm đồ giặt và gửi phản hồi khiếu nại (nếu có).',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: outlineColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  // 🚀 2. Cập nhật lệnh chuyển hướng sang ConfirmReceiptScreen
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConfirmReceiptScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  icon: const Icon(Icons.verified, color: Colors.white, size: 18),
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tiến hành Xác nhận đã nhận hàng',
                        style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: TextButton.icon(
            onPressed: () => _showActionDialog(
              context,
              'Tổng đài CSKH 24/7',
              'Đang kết nối tổng đài 1900 3388...',
            ),
            style: TextButton.styleFrom(
              backgroundColor: surfaceLow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            ),
            icon: const Icon(Icons.support_agent, color: primaryColor, size: 18),
            label: Text(
              'Hotline hỗ trợ: 1900 3388',
              style: GoogleFonts.plusJakartaSans(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}