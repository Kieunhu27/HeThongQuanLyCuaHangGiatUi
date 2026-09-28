import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingSuccessScreen extends StatefulWidget {
  const BookingSuccessScreen({super.key});

  @override
  State<BookingSuccessScreen> createState() => _BookingSuccessScreenState();
}

class _BookingSuccessScreenState extends State<BookingSuccessScreen> {
  bool _isCopied = false;

  void _copyOrderCode() {
    Clipboard.setData(const ClipboardData(text: 'WS3T-8892'));
    setState(() {
      _isCopied = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã sao chép mã đơn hàng!'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFFB90538),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8F7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF370C14)),
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
        ),
        title: Text(
          'Đặt Đơn Thành Công',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF370C14),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Color(0xFF5B4041)),
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFB90538),
              child: const Icon(Icons.person, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: 140,
            ),
            child: Column(
              children: [
                // 1. HERO SECTION: Checkmark & Lời cảm ơn
                _buildHeroSection(),
                const SizedBox(height: 20),

                // 2. CARD 1: Lịch trình lấy đồ
                _buildScheduleCard(),
                const SizedBox(height: 16),

                // 3. CARD 2: Chi tiết đơn hàng & Thanh toán
                _buildOrderDetailCard(),
                const SizedBox(height: 16),

                // 4. CARD 3: Cam kết Quy trình 3T
                _buildCommitmentCard(),
                const SizedBox(height: 16),

                // Hotline hỗ trợ
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.support_agent,
                      size: 18,
                      color: Color(0xFFB90538),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Tổng đài hỗ trợ 3T: ',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: const Color(0xFF5B4041),
                      ),
                    ),
                    Text(
                      '1900 3388 (Miễn phí)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFB90538),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // STICKY BOTTOM BUTTONS
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8F7).withOpacity(0.95),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Chuyển sang màn hình Theo dõi đơn hàng
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB90538),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
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
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: TextButton.icon(
                      onPressed: () => Navigator.of(
                        context,
                      ).popUntil((route) => route.isFirst),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFFFE1E3),
                        foregroundColor: const Color(0xFFB90538),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: const Icon(Icons.home, size: 18),
                      label: Text(
                        'Về trang chủ WashSmart',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  // WIDGET: Hero Section
  Widget _buildHeroSection() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFB90538),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x40B90538),
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_circle,
                size: 50,
                color: Colors.white,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.auto_awesome,
                  size: 14,
                  color: const Color(0xFFB90538),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE1E3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFB90538),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Đã xác nhận & Đang điều phối Shipper 3T',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFB90538),
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
            color: const Color(0xFF370C14),
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Cảm ơn chị Kiều Như! Đơn đồ giặt của bạn đã được tiếp nhận và chuyển đến Shipper 3T khu vực Bến Nghé, Quận 1.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: const Color(0xFF5B4041),
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 14),
        // Mã đơn hàng & Nút chép
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFFFFE9EA)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'MÃ ĐƠN ',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color: const Color(0xFF8F6F71),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '#WS3T-8892',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFB90538),
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: _copyOrderCode,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _isCopied
                        ? const Color(0xFFACEDFF)
                        : const Color(0xFFFFE9EA),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isCopied ? Icons.check : Icons.content_copy,
                        size: 14,
                        color: const Color(0xFF370C14),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isCopied ? 'Đã chép!' : 'Sao chép',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF370C14),
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

  // WIDGET: Schedule Card
  Widget _buildScheduleCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.two_wheeler,
                    color: Color(0xFFB90538),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Lịch trình lấy đồ 3T',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF370C14),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD9E4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Lấy hẹn giờ',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3E0022),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 18,
                      color: Color(0xFFB90538),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shipper tới gom đồ:',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: const Color(0xFF5B4041),
                          ),
                        ),
                        Text(
                          'Hôm nay (24/10), 14:00 - 16:00',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFB90538),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.event_available,
                      size: 18,
                      color: Color(0xFF006577),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dự kiến giao trả tinh tươm:',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: const Color(0xFF5B4041),
                          ),
                        ),
                        Text(
                          'Ngày mai (25/10), trước 11:00',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF370C14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: Color(0xFFB90538), size: 20),
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
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '0988 ••• 321',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: const Color(0xFF8F6F71),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Căn hộ Heritage Manor, Căn 302, 128 Hai Bà Trưng, P. Bến Nghé, Quận 1, TP. Hồ Chí Minh',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: const Color(0xFF370C14),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE1E3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.chat_bubble,
                            size: 14,
                            color: Color(0xFFB90538),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Lời dặn tài xế: "Bấm chuông căn 302, mang túi gom lớn..."',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: const Color(0xFF5B4041),
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

  // WIDGET: Order Detail Card
  Widget _buildOrderDetailCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.receipt_long,
                    color: Color(0xFFB90538),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Chi tiết đơn hàng',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF370C14),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFACEDFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check, size: 12, color: Color(0xFF004E5C)),
                    const SizedBox(width: 2),
                    Text(
                      'Đã thanh toán',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF004E5C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildItemRow(
            'Giặt Sấy Tinh Tươm (5.0 kg)',
            '125.000 đ',
            subtitle: 'Hương Hoa Ban Mai • Khử khuẩn sấy nhiệt',
          ),
          _buildItemRow(
            'Ủi hơi nước chống nhăn bảo vệ sợi',
            '+20.000 đ',
            icon: Icons.iron,
          ),
          _buildItemRow(
            'Túi vải niêm phong chống nước 3T',
            'MIỄN PHÍ',
            isHighlight: true,
            icon: Icons.inventory_2,
          ),
          _buildItemRow(
            'Bồi dưỡng Shipper 3T',
            '+10.000 đ',
            icon: Icons.favorite,
          ),
          _buildItemRow(
            'Ưu đãi (3TTINHTUOM & 3T Xu)',
            '-25.000 đ',
            isDiscount: true,
          ),
          const Divider(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tổng thanh toán:',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '145.000 đ',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFB90538),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.account_balance,
                          size: 14,
                          color: Color(0xFF006577),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'VietQR / Ngân hàng tức thì',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: const Color(0xFF5B4041),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Thành công (VietQR)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF006577),
                      ),
                    ),
                  ],
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
    IconData? icon,
    bool isDiscount = false,
    bool isHighlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 14, color: const Color(0xFF5B4041)),
                      const SizedBox(width: 4),
                    ],
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: const Color(0xFF370C14),
                          fontWeight: subtitle != null
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: const Color(0xFF5B4041),
                    ),
                  ),
              ],
            ),
          ),
          Text(
            price,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDiscount
                  ? const Color(0xFFB90538)
                  : isHighlight
                  ? const Color(0xFFB90538)
                  : const Color(0xFF370C14),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET: Commitment Card
  Widget _buildCommitmentCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.verified,
                    color: Color(0xFFB4136D),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Cam kết Quy trình 3T',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF370C14),
                    ),
                  ),
                ],
              ),
              Text(
                'Tinh Tươm – Tận Tâm',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFB4136D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildStepRow(
            '1',
            'Bàn giao đồ & Kẹp Seal',
            'Trao đồ cho Shipper 3T và xác thực mã Seal chống thất lạc đồ.',
            const Color(0xFFB90538),
          ),
          const SizedBox(height: 8),
          _buildStepRow(
            '2',
            'Kiểm đếm & Cân ký trực tiếp',
            'Tiệm phân loại chất liệu, chụp ảnh hiện trạng và cập nhật số ký chuẩn xác.',
            const Color(0xFFB4136D),
          ),
          const SizedBox(height: 8),
          _buildStepRow(
            '3',
            'Giám sát quy trình trên App',
            'Xem hình ảnh giặt sấy, camera phân loại và tọa độ Shipper giao hàng.',
            const Color(0xFF006577),
          ),
        ],
      ),
    );
  }

  Widget _buildStepRow(String step, String title, String desc, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: color,
            child: Text(
              step,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
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
                    color: const Color(0xFF370C14),
                  ),
                ),
                Text(
                  desc,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: const Color(0xFF5B4041),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
