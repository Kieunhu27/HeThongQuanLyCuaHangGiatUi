import 'package:flutter/material.dart';
import 'booking_success_screen.dart';

class BookingStep3Screen extends StatefulWidget {
  const BookingStep3Screen({super.key});

  @override
  State<BookingStep3Screen> createState() => _BookingStep3ScreenState();
}

class _BookingStep3ScreenState extends State<BookingStep3Screen> {
  // Màu sắc chủ đạo theo thiết kế
  final Color primaryColor = const Color(0xFFB90538);
  final Color primaryLight = const Color(0xFFFFD9DC);
  final Color bgSurface = const Color(0xFFFFF8F7);
  final Color cardBg = Colors.white;
  final Color subCardBg = const Color(0xFFFFF0F0);

  // States chọn lựa
  bool usePoints = true;
  String selectedPayment = 'vietqr'; // vietqr, cod, ewallet, card
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    // Tính toán tổng tiền động dựa theo việc bật/tắt xu
    int basePrice = 140000;
    int pointsDiscount = usePoints ? 5000 : 0;
    int totalPrice = basePrice - pointsDiscount;

    return Scaffold(
      backgroundColor: bgSurface,
      appBar: AppBar(
        backgroundColor: bgSurface.withOpacity(0.95),
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF370C14)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Xác Nhận & Thanh Toán',
          style: TextStyle(
            color: Color(0xFF370C14),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: primaryColor,
              child: const Text(
                'KN',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            // 1. Step Progress Bar (Bước 3/3)
            _buildStepTracker(),
            const SizedBox(height: 12),

            // 2. Banner truyền cảm hứng
            _buildBanner(),
            const SizedBox(height: 12),

            // 3. Chi tiết gói dịch vụ
            _buildServiceSummary(),
            const SizedBox(height: 12),

            // 4. Lịch trình lấy & giao trả
            _buildScheduleSection(),
            const SizedBox(height: 12),

            // 5. Ưu đãi & Tích điểm
            _buildVoucherAndPoints(),
            const SizedBox(height: 12),

            // 6. Phương thức thanh toán
            _buildPaymentMethods(),
            const SizedBox(height: 12),

            // 7. Bóc tách chi phí
            _buildCostBreakdown(totalPrice),
            const SizedBox(height: 12),

            // 8. Cam kết bảo hiểm
            _buildInsuranceCommitment(),
            const SizedBox(height: 100), // Khoảng trống cuộn qua bottom bar
          ],
        ),
      ),
      bottomSheet: _buildBottomActionBar(totalPrice),
    );
  }

  // --- WIDGETS THÀNH PHẦN ---

  Widget _buildStepTracker() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStepNode(Icons.check, '1. Dịch vụ', isDone: true),
              _buildStepNode(Icons.check, '2. Lịch hẹn', isDone: true),
              _buildStepNode(Icons.credit_card, '3. Thanh toán', isActive: true),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, size: 14, color: primaryColor),
                const SizedBox(width: 4),
                Text(
                  'Bước 3/3: Xác nhận đơn & Thanh toán an toàn',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStepNode(IconData icon, String label, {bool isDone = false, bool isActive = false}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: isActive ? primaryColor : (isDone ? primaryColor : Colors.grey.shade300),
          child: Icon(icon, size: 16, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive || isDone ? FontWeight.bold : FontWeight.normal,
            color: isActive || isDone ? primaryColor : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1517677208171-0bc6725a3e60?q=80&w=600'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'TINH HOA CHĂM SÓC VẢI VÓC',
              style: TextStyle(color: Color(0xFFFFB0CD), fontSize: 10, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2),
            Text(
              'Đồ sạch thơm mát, tinh tươm tới tay bạn',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceSummary() {
    return _buildCardWrapper(
      title: 'Chi tiết gói dịch vụ',
      icon: Icons.local_laundry_service,
      badgeText: 'Tiết kiệm 25%',
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: subCardBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Gói Giặt Sấy Tinh Tươm (5.0 kg)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.spa, size: 12, color: primaryColor),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Sấy thơm hương hoa ban mai • Gấp vuông vức',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Text('125.000 đ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
            const Divider(height: 16),
            _buildServiceItemRow(Icons.iron, 'Ủi hơi nước chống nhăn bảo vệ sợi vải', '+20.000 đ'),
            const SizedBox(height: 6),
            _buildServiceItemRow(Icons.inventory_2, 'Túi vải niêm phong chống nước 3T', 'Miễn phí (0 đ)', highlight: 'Miễn phí'),
            const SizedBox(height: 6),
            _buildServiceItemRow(Icons.verified_user, 'Khử khuẩn sâu tia cực tím UV-C', 'Đã bao gồm', highlight: 'Đã bao gồm'),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItemRow(IconData icon, String title, String price, {String? highlight}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(icon, size: 14, color: primaryColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 11, color: Color(0xFF370C14))),
              ),
            ],
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: 11,
            fontWeight: highlight != null ? FontWeight.bold : FontWeight.w600,
            color: highlight == 'Miễn phí' ? const Color(0xFF006577) : (highlight == 'Đã bao gồm' ? const Color(0xFFB4136D) : Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleSection() {
    return _buildCardWrapper(
      title: 'Lịch trình lấy & giao trả',
      icon: Icons.local_shipping,
      actionText: 'Thay đổi',
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: subCardBg, borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, color: primaryColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Chị Kiều Như • 0988 ••• 321', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      SizedBox(height: 2),
                      Text(
                        'Căn hộ Heritage Manor, Căn 302, 128 Hai Bà Trưng, P. Bến Nghé, Quận 1, TP. HCM',
                    style: TextStyle(fontSize: 11, color: const Color(0xB3000000)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Column(
              children: [
                _buildTimelineNode(
                  icon: Icons.south,
                  iconBg: primaryColor,
                  title: 'Shipper 3T tới gom đồ',
                  time: 'Hôm nay (24/10), 14:00 - 16:00',
                  hasLine: true,
                ),
                _buildTimelineNode(
                  icon: Icons.checkroom,
                  iconBg: const Color(0xFF006577),
                  title: 'Dự kiến giao thơm tho tận cửa',
                  time: 'Ngày mai (25/10), trước 11:00',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: primaryLight.withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Icon(Icons.edit_note, color: primaryColor, size: 16),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'Dặn dò: "Bấm chuông căn 302, mang túi gom lớn chống nước, gọi trước 10 phút"',
                  style: TextStyle(fontSize: 10, color: const Color(0xCC000000)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTimelineNode({required IconData icon, required Color iconBg, required String title, required String time, bool hasLine = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(radius: 10, backgroundColor: iconBg, child: Icon(icon, size: 10, color: Colors.white)),
            if (hasLine) Container(width: 2, height: 24, color: Colors.grey.shade300),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
            Text(time, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }

  Widget _buildVoucherAndPoints() {
    return _buildCardWrapper(
      title: 'Ưu đãi & Tích điểm',
      icon: Icons.confirmation_number,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: subCardBg, borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 14, backgroundColor: primaryLight, child: Icon(Icons.local_offer, size: 14, color: primaryColor)),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('3TTINHTUOM', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 12)),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(4)),
                              child: const Text('Đã áp dụng', style: TextStyle(color: Colors.white, fontSize: 9)),
                            )
                          ],
                        ),
                        Text('Giảm ngay 20.000 đ cho giặt sấy', style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
                      ],
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(40, 20)),
                  child: Text('Đổi mã', style: TextStyle(color: primaryColor, fontSize: 11, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: subCardBg, borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(radius: 14, backgroundColor: Color(0xFFFFD9E4), child: Icon(Icons.savings, size: 14, color: Color(0xFFB4136D))),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Dùng 500 điểm 3T Xu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text('Số dư: 1.450 Xu (Giảm 5.000 đ)', style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
                      ],
                    ),
                  ],
                ),
                Switch(
                  value: usePoints,
                  activeColor: primaryColor,
                  onChanged: (val) => setState(() => usePoints = val),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return _buildCardWrapper(
      title: 'Phương thức thanh toán',
      icon: Icons.account_balance_wallet,
      child: Column(
        children: [
          _buildPaymentOption('vietqr', Icons.qr_code_2, 'VietQR / Ngân hàng tức thì', 'Quét mã nhanh mọi app ngân hàng • Miễn phí GD', badge: 'Khuyên dùng'),
          const SizedBox(height: 8),
          _buildPaymentOption('cod', Icons.payments, 'Tiền mặt khi giao trả (COD)', 'Thanh toán trực tiếp cho Shipper khi nhận đồ'),
          const SizedBox(height: 8),
          _buildPaymentOption('ewallet', Icons.wallet, 'Ví điện tử MoMo / ZaloPay', 'Liên kết thanh toán 1 chạm siêu tốc'),
          const SizedBox(height: 8),
          _buildPaymentOption('card', Icons.credit_card, 'Thẻ ATM Nội địa / Quốc tế', 'Visa, MasterCard, JCB hoặc Napas'),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String value, IconData icon, String title, String subtitle, {String? badge}) {
    bool isSelected = selectedPayment == value;
    return GestureDetector(
      onTap: () => setState(() => selectedPayment = value),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? subCardBg : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? primaryColor : Colors.grey.shade200, width: isSelected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: selectedPayment,
              activeColor: primaryColor,
              onChanged: (val) => setState(() => selectedPayment = val!),
            ),
            Icon(icon, color: isSelected ? primaryColor : Colors.grey.shade600, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      if (badge != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(color: const Color(0xFFFFD9E4), borderRadius: BorderRadius.circular(10)),
                          child: const Text('Khuyên dùng', style: TextStyle(color: Color(0xFF3E0022), fontSize: 9, fontWeight: FontWeight.bold)),
                        )
                      ]
                    ],
                  ),
                  Text(subtitle, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: primaryColor, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildCostBreakdown(int total) {
    return _buildCardWrapper(
      title: 'Bóc tách chi phí minh bạch',
      icon: Icons.receipt_long,
      child: Column(
        children: [
          _buildCostRow('Tạm tính tiền giặt & ủi:', '145.000 đ'),
          _buildCostRow('Phí vận chuyển 2 chiều (Gom & Giao):', '30.000 đ'),
          _buildCostRow('Hỗ trợ phí ship thành viên VIP:', '-15.000 đ', color: const Color(0xFF006577)),
          _buildCostRow('Khuyến mãi Voucher (3TTINHTUOM):', '-20.000 đ', color: primaryColor),
          if (usePoints) _buildCostRow('Điểm tích lũy 3T (500 Xu):', '-5.000 đ', color: const Color(0xFFB4136D)),
          const Divider(height: 16),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: subCardBg, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tổng cộng thanh toán:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text('Bạn đã tiết kiệm được ${usePoints ? "40.000" : "35.000"} đ!', style: TextStyle(fontSize: 10, color: primaryColor, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${_formatCurrency(total)} đ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor)),
                    const Text('(Đã bao gồm VAT)', style: TextStyle(fontSize: 9, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCostRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
         Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color ?? Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildInsuranceCommitment() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: primaryLight, borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified, color: primaryColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Cam kết an tâm chuẩn 3T', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                 style: TextStyle(fontSize: 10, color: const Color(0xCC000000)),
                    children: [
                      const TextSpan(text: 'Khóa seal niêm phong chống tráo đổi • Bồi thường '),
                      TextSpan(text: '100% giá trị đồ', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                      const TextSpan(text: ' nếu xảy ra thất lạc hoặc co rút sợi vải theo chính sách bảo hiểm.'),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(int total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tổng thanh toán:', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    Row(
                      children: [
                        Text('${_formatCurrency(total)} đ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                        const SizedBox(width: 6),
                        const Text('175.000 đ', style: TextStyle(fontSize: 11, color: Colors.grey, decoration: TextDecoration.lineThrough)),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  width: 180,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : _handleConfirmOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: isSubmitting
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Xác nhận đặt đơn', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                            ],
                          ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 6),
            const Text('Nhấn xác nhận đồng nghĩa bạn đồng ý với Điều khoản dịch vụ 3T Care', style: TextStyle(fontSize: 9, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildCardWrapper({required String title, required IconData icon, required Widget child, String? badgeText, String? actionText}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: primaryLight, borderRadius: BorderRadius.circular(8)),
                    child: Icon(icon, color: primaryColor, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: primaryLight, borderRadius: BorderRadius.circular(10)),
                  child: Text(badgeText, style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              if (actionText != null)
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(40, 20)),
                  child: Text(actionText, style: TextStyle(color: primaryColor, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  // --- HÀM XỬ LÝ CHUYỂN TRANG ---
  void _handleConfirmOrder() {
    setState(() => isSubmitting = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => isSubmitting = false);
        
        // Chuyển sang Màn hình Đặt Đơn Thành Công
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>  BookingSuccessScreen(),
          ),
          (route) => route.isFirst,
        );
      }
    });
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllRegExp(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.');
  }
}

extension RegExpExtension on String {
  String replaceAllRegExp(RegExp regex, String replacement) {
    return replaceAllMapped(regex, (match) => replacement);
  }
}