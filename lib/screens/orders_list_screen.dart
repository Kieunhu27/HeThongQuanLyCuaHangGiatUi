import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'order_tracking_screen.dart'; // Import màn hình Chi tiết / Theo dõi tiến độ

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  // Màu sắc thiết kế theo Hệ thống Brand Tokens WashSmart 3T
  final Color primaryColor = const Color(0xFFB90538);
  final Color primaryContainer = const Color(0xFFDC2C4F);
  final Color bgSurface = const Color(0xFFFFF8F7);
  final Color cardBg = Colors.white;
  final Color surfaceLow = const Color(0xFFFFF0F0);
  final Color surfaceHigh = const Color(0xFFFFE1E3);
  final Color onSurface = const Color(0xFF370C14);
  final Color outlineColor = const Color(0xFF8F6F71);

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
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 13,
                ),
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
      appBar: AppBar(
        backgroundColor: bgSurface.withOpacity(0.95),
        elevation: 0,
        scrolledUnderElevation: 1,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: surfaceLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.local_laundry_service_rounded,
                color: primaryColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WASHSMART 3T',
                  style: GoogleFonts.plusJakartaSans(
                    color: primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  'Đơn Hàng',
                  style: GoogleFonts.plusJakartaSans(
                    color: onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: onSurface, size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.tune, color: onSurface, size: 22),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 4),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: primaryColor,
              child: const Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Khung Tìm kiếm đơn hàng
            _buildSearchBarOnly(),
            const SizedBox(height: 16),

            // 2. Card Đơn hàng nổi bật vừa đặt (#WS3T-8892)
            _buildActiveOrderCard(),
            const SizedBox(height: 20),

            // 3. Tiêu đề Lịch sử đơn hàng
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.history, color: primaryColor, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      'Đơn hàng gần đây',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: onSurface,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Xem tất cả',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 4. Đơn hàng lịch sử 1 (#WS3T-7810 - Giặt khô Áo vest & Đầm)
            _buildHistoryOrderCard(
              orderCode: 'WS3T-7810',
              dateText: 'Hoàn tất ngày 20/10/2023',
              serviceTitle: 'Giặt khô hấp Áo vest cao cấp & Đầm dạ hội',
              serviceSub: 'Khử khuẩn ozone • Mắc áo gỗ định hình 3T',
              paymentMethod: 'MoMo E-Wallet',
              price: '230.000 đ',
              iconData: Icons.dry_cleaning,
              ratingText: '5★',
            ),
            const SizedBox(height: 12),

            // 5. Đơn hàng lịch sử 2 (#WS3T-6924 - Vệ sinh Giày Sneaker)
            _buildHistoryOrderCard(
              orderCode: 'WS3T-6924',
              dateText: 'Hoàn tất ngày 15/10/2023',
              serviceTitle: 'Vệ sinh & Khử khuẩn Giày Sneaker 3T (2 đôi)',
              serviceSub: 'Sấy tia cực tím UV • Phủ Nano kháng nước',
              paymentMethod: 'Tiền mặt khi nhận',
              price: '180.000 đ',
              iconData: Icons.roller_skating,
              feedbackText: 'Góp ý',
            ),
            const SizedBox(height: 16),

            // 6. Banner Cam kết Bảo hiểm 100%
            _buildInsuranceBanner(),
            const SizedBox(height: 12),

            // 7. Banner Tiêu chuẩn 3T
            _buildBrandCareBanner(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- WIDGET THÀNH PHẦN ---

  Widget _buildSearchBarOnly() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: surfaceLow,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: outlineColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm theo mã đơn (#WS3T...), tên dịch vụ...',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: outlineColor.withOpacity(0.7),
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          Icon(Icons.mic, color: outlineColor, size: 18),
        ],
      ),
    );
  }

  Widget _buildActiveOrderCard() {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Dải màu Gradient viền trên
          Container(
            height: 5,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              gradient: LinearGradient(
                colors: [
                  primaryContainer,
                  const Color(0xFFFD56A7),
                  primaryColor,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Đơn hàng
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: surfaceHigh,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.local_laundry_service_rounded,
                            color: primaryColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '#WS3T-8892',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: onSurface,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () =>
                                      _showToast('Đã chép mã đơn #WS3T-8892'),
                                  child: Icon(
                                    Icons.content_copy,
                                    size: 14,
                                    color: outlineColor,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Hôm nay, 10:24 • Khách: Kiều Như',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: outlineColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Badge Đang điều phối Shipper
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: surfaceHigh,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'ĐIỀU PHỐI SHIPPER',
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
                const SizedBox(height: 14),

                // Stepper tiến trình nhỏ
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
                            '1. Đã đặt',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            '2. Tới lấy',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            '3. Giặt sấy',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              color: outlineColor,
                            ),
                          ),
                          Text(
                            '4. Giao nhận',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              color: outlineColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Stack(
                        children: [
                          Container(
                            height: 6,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD9DC),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.45,
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                gradient: LinearGradient(
                                  colors: [
                                    primaryContainer,
                                    const Color(0xFFFD56A7),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 14,
                                color: primaryColor,
                              ),
                              const SizedBox(width: 4),
                              RichText(
                                text: TextSpan(
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: primaryColor,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: 'Shipper dự kiến gom: ',
                                    ),
                                    TextSpan(
                                      text: '14:00 – 16:00',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(text: ' hôm nay'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Chờ lấy đồ',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              color: outlineColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Chi tiết gói dịch vụ
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle, size: 18, color: primaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Giặt Sấy Tinh Tươm (5.0 kg)',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: onSurface,
                            ),
                          ),
                          Text(
                            '+ Ủi hơi nước chống nhăn bảo vệ từng sợi vải cao cấp',
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

                // Badges dịch vụ đính kèm
                Padding(
                  padding: const EdgeInsets.only(left: 26),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _buildMiniBadge(Icons.local_florist, 'Hương Hoa Ban Mai'),
                      _buildMiniBadge(
                        Icons.card_giftcard,
                        'Túi vải niêm phong chống nước 3T',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Địa chỉ lấy đồ
                Padding(
                  padding: const EdgeInsets.only(left: 26),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: outlineColor),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Heritage Manor, Căn 302, 128 Hai Bà Trưng, P. Bến Nghé, Q.1',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: outlineColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Đường nét đứt phân cách
                const Divider(height: 1, color: Color(0xFFE3BDBF)),
                const SizedBox(height: 12),

                // Giá tiền & Thanh toán
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Đã thanh toán VietQR',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: outlineColor,
                          ),
                        ),
                        Text(
                          'Đã bao gồm 10k Tip • Đã áp 3T Xu',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            color: outlineColor.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '145.000 đ',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Cụm Nút Hành động (ĐÃ TÍCH HỢP CHUYỂN MÀN HÌNH THEO DÕI TIẾN ĐỘ)
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // 🚀 Lệnh chuyển sang màn hình Theo dõi tiến độ giặt sấy trực tiếp
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderTrackingScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryContainer,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      elevation: 2,
                    ),
                    icon: const Icon(Icons.sensors, size: 18),
                    label: Text(
                      'Theo dõi tiến độ & Khóa Seal trực tiếp',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 38,
                        child: TextButton.icon(
                          onPressed: () =>
                              _showToast('Đang tải hóa đơn VAT điện tử...'),
                          style: TextButton.styleFrom(
                            backgroundColor: surfaceHigh,
                            foregroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(19),
                            ),
                          ),
                          icon: const Icon(Icons.receipt_long, size: 16),
                          label: Text(
                            'Xem hóa đơn VAT',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 38,
                        child: TextButton.icon(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: surfaceHigh,
                            foregroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(19),
                            ),
                          ),
                          icon: const Icon(Icons.call, size: 16),
                          label: Text(
                            'Liên hệ Shipper 3T',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
    );
  }

  Widget _buildMiniBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: surfaceLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: primaryColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryOrderCard({
    required String orderCode,
    required String dateText,
    required String serviceTitle,
    required String serviceSub,
    required String paymentMethod,
    required String price,
    required IconData iconData,
    String? ratingText,
    String? feedbackText,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
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
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: surfaceLow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(iconData, color: primaryColor, size: 20),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '#$orderCode',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: onSurface,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () =>
                                _showToast('Đã sao chép mã đơn #$orderCode'),
                            child: Icon(
                              Icons.content_copy,
                              size: 12,
                              color: outlineColor,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        dateText,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: outlineColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: surfaceHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Đã giao hoàn tất',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceTitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.verified_user,
                      size: 13,
                      color: const Color(0xFF006577),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      serviceSub,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: outlineColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFE3BDBF)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paymentMethod,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: outlineColor,
                    ),
                  ),
                  Text(
                    price,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: onSurface,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  if (ratingText != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _showToast('Đánh giá của bạn: 5 sao Tinh Tươm!'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: surfaceLow,
                          foregroundColor: primaryColor,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 14,
                        ),
                        label: Text(
                          ratingText,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (feedbackText != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: TextButton(
                        onPressed: () =>
                            _showToast('Chuyên viên CSKH sẽ liên hệ lại ngay!'),
                        style: TextButton.styleFrom(
                          backgroundColor: surfaceLow,
                          foregroundColor: outlineColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          feedbackText,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ElevatedButton.icon(
                    onPressed: () =>
                        _showToast('Đang thêm lại vào giỏ hàng...'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryContainer,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.replay, size: 14),
                    label: Text(
                      'Đặt lại',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildInsuranceBanner() {
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.verified, color: primaryColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bảo hiểm vải sợi 100%',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: onSurface,
                  ),
                ),
                Text(
                  'Khóa Seal niêm phong chống tráo đổi • Hotline 24/7: 1900 3388',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: outlineColor,
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Icon(Icons.support_agent, color: primaryColor, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandCareBanner() {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1517677208171-0bc6725a3e60?q=80&w=600',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF370C14).withOpacity(0.85),
              Colors.transparent,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'TIÊU CHUẨN 3T',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFFFFB0CD),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Tận Tâm – Tinh Tươm – Tiện Lợi',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Trang phục sạch thơm như mới mỗi ngày',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFFFFD9DB),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}