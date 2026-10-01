import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'booking_step1_screen.dart';
import 'orders_list_screen.dart';
import 'promotions_screen.dart';
import 'profile_screen.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Bảng màu chuẩn theo hệ thống thiết kế WashSmart 3T
  static const Color primaryColor = Color(0xFFB90538);
  static const Color secondaryColor = Color(0xFFB4136D);
  static const Color tertiaryColor = Color(0xFF006577);
  static const Color bgSurface = Color(0xFFFFF8F7);
  static const Color surfaceContainer = Color(0xFFFFE9EA);
  static const Color surfaceContainerLow = Color(0xFFFFF0F0);
  static const Color textColor = Color(0xFF370C14);
  static const Color textVariantColor = Color(0xFF5B4041);

  void _onNavigateToPromotions() {
    setState(() {
      _selectedIndex = 2; // Chuyển sang tab Ưu đãi
    });
  }

  // Hàm chuyển sang tab Tài khoản
  void _onNavigateToProfile() {
    setState(() {
      _selectedIndex = 3; // Chuyển sang tab Tài khoản
    });
  }

  @override
  Widget build(BuildContext context) {
    // Danh sách các màn hình tương ứng với các tab dưới Bottom Bar
    final List<Widget> screens = [
      HomeScreenContent(
        onNavigateToPromotions: _onNavigateToPromotions,
        onNavigateToProfile: _onNavigateToProfile,
      ), // Nội dung Trang chủ (index 0)
      const OrdersListScreen(), // Màn hình Đơn hàng (index 1)
      const PromotionsScreen(), // Màn hình Ưu đãi (index 2)
      const ProfileScreen(),    // Màn hình Tài khoản (index 3)
    ];

    return Scaffold(
      backgroundColor: bgSurface,

      // 1. HEADER CỐ ĐỊNH TRÊN CÙNG
      appBar: AppBar(
        backgroundColor: bgSurface.withOpacity(0.95),
        elevation: 0.5,
        scrolledUnderElevation: 1,
        shadowColor: Colors.black12,
        titleSpacing: 16,
        title: Row(
          children: [
            // Logo thương hiệu 3T
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.local_laundry_service,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WashSmart 3T',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    height: 1.1,
                  ),
                ),
                Text(
                  _selectedIndex == 0
                      ? 'Trang Chủ'
                      : (_selectedIndex == 1
                            ? 'Đơn Hàng'
                            : (_selectedIndex == 2 ? 'Ưu Đãi' : 'Tài Khoản')),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: textVariantColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Thẻ Rose Club
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: surfaceContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified, color: secondaryColor, size: 14),
                const SizedBox(width: 4),
                Text(
                  '3T Rose Club',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Avatar người dùng trên App Bar - Bấm vào chuyển sang Tab Tài khoản
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
              },
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: primaryColor,
                child: Icon(Icons.person, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),

      // 2. NỘI DUNG THAY ĐỔI THEO TAB CHỌN
      body: IndexedStack(index: _selectedIndex, children: screens),

      // 3. THANH ĐIỀU HƯỚNG BOTTOM BAR CÓ NÚT "ĐẶT LỊCH" NỔI Ở GIỮA
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BookingStep1Screen()),
          );
        },
        backgroundColor: primaryColor,
        elevation: 6,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.local_laundry_service, 'Trang chủ'),
              _buildNavItem(1, Icons.receipt_long_outlined, 'Đơn hàng'),
              const SizedBox(width: 48), // Chừa khoảng trống cho nút + ở giữa
              _buildNavItem(2, Icons.loyalty_outlined, 'Ưu đãi'),
              _buildNavItem(3, Icons.account_circle_outlined, 'Tài khoản'),
            ],
          ),
        ),
      ),
    );
  }

  // Item Tab Bottom Navigation
  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? primaryColor : textVariantColor,
            size: 22,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? primaryColor : textVariantColor,
            ),
          ),
        ],
      ),
    );
  }
}

// TÁCH PHẦN NỘI DUNG CUỘN CỦA TRANG CHỦ RA THÀNH WIDGET RIÊNG
class HomeScreenContent extends StatelessWidget {
  final VoidCallback onNavigateToPromotions;
  final VoidCallback onNavigateToProfile;

  const HomeScreenContent({
    super.key,
    required this.onNavigateToPromotions,
    required this.onNavigateToProfile,
  });

  static const Color primaryColor = Color(0xFFB90538);
  static const Color secondaryColor = Color(0xFFB4136D);
  static const Color tertiaryColor = Color(0xFF006577);
  static const Color surfaceContainer = Color(0xFFFFE9EA);
  static const Color surfaceContainerLow = Color(0xFFFFF0F0);
  static const Color textColor = Color(0xFF370C14);
  static const Color textVariantColor = Color(0xFF5B4041);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        children: [
          _buildWelcomeSection(),
          const SizedBox(height: 16),
          _buildPromoBanner(),
          const SizedBox(height: 20),
          _buildActiveOrderTracker(),
          const SizedBox(height: 20),
          _buildQuickActionButton(context),
          const SizedBox(height: 20),
          _buildServicesGrid(context),
          const SizedBox(height: 16),
          _buildCarePromisesRow(),
          const SizedBox(height: 80), // Khoảng trống cho Bottom Bar
        ],
      ),
    );
  }

  // Khối 1: Thông tin chào mừng (Bấm Avatar KN chuyển sang Trang cá nhân)
  Widget _buildWelcomeSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: onNavigateToProfile,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: surfaceContainer,
                    child: Text(
                      'KN',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: tertiaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.spa, color: Colors.white, size: 10),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Xin chào, Kiều Như!',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, color: secondaryColor, size: 18),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.workspace_premium,
                            color: secondaryColor,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Hạng Vàng',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: secondaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '1.250 điểm 3T',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: textVariantColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Stack(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.notifications_none,
                color: textColor,
                size: 22,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Khối 2: Banner Ưu đãi (Cập nhật hình ảnh banner mới)
  Widget _buildPromoBanner() {
    return GestureDetector(
      onTap: onNavigateToPromotions,
      child: Container(
        height: 176,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(
            image: NetworkImage(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDwE4neSVetDCdPAsBZxl0ApN5fkzSAxJM9lI9HQovfneabm0qN7egaIxQQw9NZf0NF1NUF1ooKS0dYfNXO0Q426eSSLhmHWeqvrQvNHtoHGfmMhxUdRgVPCMwNe46JFIlBb2AGRAGZk4v1HZctqcT7sIQGf49sWYr7yV3kzaZqBGX-FtzNiTiGDfiRYt7DTlshnzJ6rv3gUyp8BGId-tDTSqPLCRxsUPmz2P8OhjaAtF2ZzWmepD_Qug',
            ),
            fit: BoxFit.cover,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.black.withOpacity(0.2),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Ưu đãi tháng này',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '01/03',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Đón hè tinh tươm',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Giảm 20% giặt sấy drap chăn gối mềm mịn',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onNavigateToPromotions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 2,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Nhận mã',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward, size: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Khối 3: Theo dõi Đơn hàng đang xử lý
  Widget _buildActiveOrderTracker() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
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
                  'Đơn hàng đang xử lý',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Row(
                children: [
                  Text(
                    'Xem tất cả',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: surfaceContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '#WS3T-8829',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '4.2 kg giặt sấy',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: textVariantColor,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: tertiaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 14,
                          color: tertiaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Hẹn 16:30 hôm nay',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: tertiaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: surfaceContainer,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.dry, color: primaryColor, size: 22),
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
                              'Đang sấy & Khử khuẩn UV',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            Text(
                              'Bước 3/5',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: const LinearProgressIndicator(
                            value: 0.6,
                            minHeight: 6,
                            backgroundColor: surfaceContainer,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFE3BDBF)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.local_shipping_outlined,
                        size: 16,
                        color: secondaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Shipper Minh Quân đang phụ trách',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: textVariantColor,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: surfaceContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Xem tiến độ',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            size: 12,
                            color: primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Khối 4: Nút Đặt Giặt Ngay
  Widget _buildQuickActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BookingStep1Screen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          elevation: 6,
          shadowColor: primaryColor.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.electric_moped,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Đặt giặt ngay',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Shipper gom tận nhà sau 30 phút',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.87),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_right,
                color: primaryColor,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Khối 5: Lưới Dịch vụ giặt ủi (Cập nhật 4 hình ảnh minh họa thực tế)
  Widget _buildServicesGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Dịch vụ giặt ủi tinh tươm',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              'Chuẩn 3T Attentive',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: textVariantColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.95,
          children: [
            _buildServiceCard(
              context,
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDwE4neSVetDCdPAsBZxl0ApN5fkzSAxJM9lI9HQovfneabm0qN7egaIxQQw9NZf0NF1NUF1ooKS0dYfNXO0Q426eSSLhmHWeqvrQvNHtoHGfmMhxUdRgVPCMwNe46JFIlBb2AGRAGZk4v1HZctqcT7sIQGf49sWYr7yV3kzaZqBGX-FtzNiTiGDfiRYt7DTlshnzJ6rv3gUyp8BGId-tDTSqPLCRxsUPmz2P8OhjaAtF2ZzWmepD_Qug',
              tag: 'Phổ biến',
              title: 'Giặt sấy theo kg',
              subtitle: 'Quần áo hàng ngày, đồ ngủ & khăn tắm',
              price: 'Từ 15k/kg',
              accentColor: primaryColor,
              tagBgColor: surfaceContainer,
            ),
            _buildServiceCard(
              context,
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDN5VHgmjvH9sJTMb3ZbwhbF8Jr-dvBUYAOLPPLvrNsGdms4SbmeCWfqyrHm_GoZOy2nZ78FDGnl8vgatt8ADbzIR-hMZxrcF7IEyR3Km1sKsSY-fnGbfTOrLQL906BBO2Sck-P_xToXih-1Icwxkn9MIBneyuRqZFjUkNcgw-m6yfTY6693guL48Rjn1zuhteDBQUKbBuaYa-8PBbcUM1QuvLKPVuUhLr4XriUd1t3Qaz85RgJ8wYLTQ',
              tag: 'Cao cấp',
              title: 'Giặt khô / Giặt hấp',
              subtitle: 'Vest, lụa tơ tằm, áo dài & đầm tiệc',
              price: 'Từ 45k/món',
              accentColor: secondaryColor,
              tagBgColor: surfaceContainer,
            ),
            _buildServiceCard(
              context,
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDrpNj8_qYGGhyk9JUNMS5EzFqU456WoREXGbAnz4VJOi3xAjuv0U3E4RlOXPUhS-SyEdXk2yhviSLr_EbuV_1NaR__8vwP8X5xLP-q3lFgBOMHdnvTFZ1i5vB1_vU20RdJLhdtBby0_adOxbCZCv-_DigloWjQcslhvA4flwv0Ehl-GKF18y-q4uNrVjPu3au9n71ZtyZ9rof5nLPMwoo8l_So94qEO-QLimRPWkv0HR2F6EwYnYRasQ',
              tag: 'Khử khuẩn UV',
              title: 'Vệ sinh giày thể thao',
              subtitle: 'Sneaker, giày da, khử mùi ion âm',
              price: 'Từ 60k/đôi',
              accentColor: tertiaryColor,
              tagBgColor: tertiaryColor.withOpacity(0.15),
            ),
            _buildServiceCard(
              context,
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCURIBGaB13vPLnA7UW_U8t0CWJpYEwWfKGO0GkRozloMUYGK2821Y7GzY3rfsP69vdr7jCaAHm8Sp24mKkdsNoo1DI35WroGefJ3Sh6OM5XScfAaLmDuuZUIxuqmXxYNrrXDWEPG6thJpuIoC1QqvC4dE9KidnjsAnOF1QvSYQtTFR4dapB1mIqr2-DFnS26kA-hRaqHndRM87UviiZ5723M1gzn5uoCX2S-HuUP3MKYaQdUNbIecyJw',
              tag: 'Tận giường',
              title: 'Rèm cửa & Chăn ga',
              subtitle: 'Tháo lắp miễn phí tại nhà, giặt diệt khuẩn',
              price: 'Từ 35k/kg',
              accentColor: primaryColor,
              tagBgColor: surfaceContainer,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required String imageUrl,
    required String tag,
    required String title,
    required String subtitle,
    required String price,
    required Color accentColor,
    required Color tagBgColor,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BookingStep1Screen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 🚀 Sử dụng Image.network thay vì Icon
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: tagBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tag,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: textVariantColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
                Icon(Icons.add_circle_outline, size: 18, color: accentColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Khối 6: Cam kết chất lượng
  Widget _buildCarePromisesRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPromiseItem(Icons.eco, 'Nước giặt hữu cơ'),
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Color(0xFFE3BDBF),
              shape: BoxShape.circle,
            ),
          ),
          _buildPromiseItem(Icons.verified_user, 'Bảo hiểm vải sợi'),
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Color(0xFFE3BDBF),
              shape: BoxShape.circle,
            ),
          ),
          _buildPromiseItem(Icons.timer, 'Giao hẹn chuẩn giờ'),
        ],
      ),
    );
  }

  Widget _buildPromiseItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: primaryColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    );
  }
}