import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Bảng màu thiết kế theo Brand Tokens WashSmart 3T
  static const Color primaryColor = Color(0xFFB90538);
  static const Color secondaryColor = Color(0xFFB4136D);
  static const Color tertiaryColor = Color(0xFF006577);
  static const Color bgSurface = Color(0xFFFFF8F7);
  static const Color cardBg = Colors.white;
  static const Color surfaceLow = Color(0xFFFFF0F0);
  static const Color surfaceHigh = Color(0xFFFFE1E3);
  static const Color onSurface = Color(0xFF370C14);
  static const Color outlineColor = Color(0xFF8F6F71);

  void _showToast(BuildContext context, String message) {
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
        backgroundColor: bgSurface.withOpacity(0.85),
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
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.local_laundry_service_rounded,
                color: primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Tài Khoản',
              style: GoogleFonts.plusJakartaSans(
                color: onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: onSurface, size: 22),
            onPressed: () => _showToast(context, 'Không có thông báo mới'),
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. THẺ THÔNG TIN CÁ NHÂN (USER PROFILE CARD)
            _buildUserProfileCard(context),
            const SizedBox(height: 16),

            // 2. HÀNG THỐNG KÊ (3T XU, VOUCHER, ĐÃ GIẶT)
            _buildStatsRow(),
            const SizedBox(height: 20),

            // 3. MENU CÀI ĐẶT & DỊCH VỤ
            Text(
              'Cài đặt & Dịch vụ',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: onSurface,
              ),
            ),
            const SizedBox(height: 8),
            _buildSettingsMenu(context),
            const SizedBox(height: 24),

            // 4. NÚT ĐĂNG XUẤT & PHIÊN BẢN
            _buildLogoutSection(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // --- 1. USER PROFILE CARD ---
  Widget _buildUserProfileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Avatar chữ Kiều Như với Tích Xanh VIP
              Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [primaryColor, Color(0xFFFD56A7)],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'KN',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: secondaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified,
                        size: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              // Thông tin Tên, SĐT, Hạng Thẻ
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Kiều Như',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: onSurface,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.spa,
                        size: 16,
                        color: primaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '0988 321 •••',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: outlineColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: surfaceHigh,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.workspace_premium,
                          size: 13,
                          color: secondaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Hạng Vàng VIP',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Nút Chỉnh sửa thông tin
          CircleAvatar(
            radius: 18,
            backgroundColor: surfaceLow,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.edit, size: 18, color: primaryColor),
              onPressed: () => _showToast(context, 'Đang mở màn hình chỉnh sửa hồ sơ...'),
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. STATS ROW ---
  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStatItem('1.595', '3T Xu', isPrimary: true),
          Container(width: 1, height: 30, color: surfaceLow),
          _buildStatItem('3', 'Voucher'),
          Container(width: 1, height: 30, color: surfaceLow),
          _buildStatItem('12', 'Đã giặt'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, {bool isPrimary = false}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isPrimary ? primaryColor : onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: outlineColor,
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. SETTINGS MENU LIST ---
  Widget _buildSettingsMenu(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.location_on,
            iconColor: primaryColor,
            title: 'Sổ địa chỉ nhận đồ',
            subtitle: 'Heritage Manor, Q.1',
            onTap: () => _showToast(context, 'Sổ địa chỉ nhận đồ'),
          ),
          const Divider(height: 1, indent: 60, color: surfaceLow),
          _buildMenuItem(
            icon: Icons.receipt_long,
            iconColor: secondaryColor,
            title: 'Lịch sử đơn hàng & Hóa đơn',
            subtitle: 'Tra cứu chi tiết & xuất hóa đơn VAT',
            onTap: () => _showToast(context, 'Chuyển đến Lịch sử đơn hàng'),
          ),
          const Divider(height: 1, indent: 60, color: surfaceLow),
          _buildMenuItem(
            icon: Icons.account_balance_wallet,
            iconColor: tertiaryColor,
            title: 'Phương thức thanh toán',
            subtitle: 'VietQR Auto, Ví MoMo',
            onTap: () => _showToast(context, 'Quản lý Phương thức thanh toán'),
          ),
          const Divider(height: 1, indent: 60, color: surfaceLow),
          _buildMenuItem(
            icon: Icons.support_agent,
            iconColor: primaryColor,
            title: 'Hỗ trợ & Tổng đài',
            subtitle: '1900 3388 (24/7)',
            badgeText: 'Miễn cước',
            onTap: () => _showToast(context, 'Đang gọi 1900 3388 (Miễn cước)...'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? badgeText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: surfaceLow,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: onSurface,
                        ),
                      ),
                      if (badgeText != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: surfaceHigh,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            badgeText,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: outlineColor,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFE3BDBF), size: 20),
          ],
        ),
      ),
    );
  }

  // --- 4. LOGOUT SECTION ---
  Widget _buildLogoutSection(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã đăng xuất tài khoản thành công!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: surfaceLow,
              foregroundColor: primaryColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            icon: const Icon(Icons.logout, size: 18),
            label: Text(
              'Đăng xuất',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'WashSmart 3T v2.4.0',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: outlineColor.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}