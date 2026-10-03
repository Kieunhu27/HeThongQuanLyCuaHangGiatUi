import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'booking_step2_screen.dart'; // 🚀 Chuyển bước 2 theo code cũ của Như

class BookingStep1Screen extends StatefulWidget {
  const BookingStep1Screen({super.key});

  @override
  State<BookingStep1Screen> createState() => _BookingStep1ScreenState();
}

class _BookingStep1ScreenState extends State<BookingStep1Screen> {
  // --- BẢNG MÀU CHUẨN BRAND TOKENS WASHSMART 3T ---
  static const Color primaryColor = Color(0xFFF43F5E);
  static const Color primaryContainer = Color(0xFFDC2C4F);
  static const Color secondaryColor = Color(0xFFB4136D);
  static const Color bgSurface = Color(0xFFFFF8F7);
  static const Color cardBg = Colors.white;
  static const Color surfaceLow = Color(0xFFFFF0F0);
  static const Color surfaceContainer = Color(0xFFFFE9EA);
  static const Color surfaceHigh = Color(0xFFFFE1E3);
  static const Color onSurface = Color(0xFF370C14);
  static const Color outlineColor = Color(0xFF8F6F71);
  static const Color outlineVariant = Color(0xFFE3BDBF);

  // --- QUẢN LÝ TRẠNG THÁI CHỌN ĐƠN HÀNG ---
  int selectedService = 1; // 1: Giặt sấy tinh tươm, 2: Giặt hấp cao cấp
  int selectedWeightIndex = 1; // 0: 3.0kg, 1: 5.0kg, 2: 8.0kg, 3: Chưa rõ kg

  // Dịch vụ bổ sung
  bool addonIron = false; // Ủi hơi nước chống nhăn (+20.000đ)
  bool addonFragrance = true; // Hương hoa ban mai (Miễn phí)
  bool addonBag = true; // Túi vải niêm phong 3T (Miễn phí)

  // Danh sách tùy chọn khối lượng
  final List<Map<String, dynamic>> weightOptions = [
    {
      'label': '3.0 kg',
      'sub': '~ 8-10 chiếc',
      'price': 75000,
      'isPopular': false,
    },
    {
      'label': '5.0 kg',
      'sub': '~ 15-18 chiếc',
      'price': 125000,
      'isPopular': true,
    },
    {
      'label': '8.0 kg',
      'sub': 'Chăn ga & nhiều đồ',
      'price': 200000,
      'isPopular': false,
    },
    {
      'label': 'Chưa rõ kg',
      'sub': 'Shipper cân sau',
      'price': 0,
      'isPopular': false,
    },
  ];

  // --- HÀM TÍNH TỔNG TIỀN TỰ ĐỘNG ---
  int calculateTotal() {
    if (selectedService == 2) {
      // Giặt hấp cao cấp (tạm tính 1 món 60k)
      int base = 60000;
      if (addonIron) base += 20000;
      return base;
    } else {
      // Giặt sấy tinh tươm theo kg
      int basePrice = weightOptions[selectedWeightIndex]['price'] as int;
      if (basePrice == 0) return 0; // Chưa rõ kg -> Shipper cân sau
      if (addonIron) basePrice += 20000;
      return basePrice;
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = calculateTotal();
    String currentWeightLabel = weightOptions[selectedWeightIndex]['label'];

    return Scaffold(
      backgroundColor: bgSurface,

      // 1. THANH HEADER TRÊN CÙNG
      appBar: AppBar(
        backgroundColor: bgSurface.withOpacity(0.95),
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Đặt Lịch Giặt Sấy',
              style: GoogleFonts.plusJakartaSans(
                color: onSurface,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Bước 1/3: Chọn dịch vụ & khối lượng',
              style: GoogleFonts.plusJakartaSans(
                color: outlineColor,
                fontSize: 11,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                'https://lh3.googleusercontent.com/aida/AEtjO1WPa14-Gu1lGEuCFeupI6LQHyolb_Z76YemKA4M9TkVUyjlNl34_077Ov_z7CPdxeuPjOZgIq8f-7fTE0jmNPaDfvixwRcBuJhrygMjfOzbLV03lqqWBc0XIeASfSu6b7Rndhl_a1Nd5ZrhbH8avYtolK38EVocgWywWKekj2yYtp5FoyQoXf_7l-QlCU6Ary1ZpdKFwHO4aAKI7DOPtRogPEGE1sgFYInSG6TuG8UcrDCNfZ6VDhhMZHQA',
              ),
            ),
          ),
        ],
      ),

      // BODY NỘI DUNG CHÍNH
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STEPPER BAR (BƯỚC 1/3)
            _buildProgressStepper(),
            const SizedBox(height: 16),

            // SECTION 1: CHỌN GÓI GIẶT (2 THẺ SONG SONG)
            _buildServiceSelector(),
            const SizedBox(height: 20),

            // SECTION 2: KHỐI LƯỢNG ƯỚC TÍNH (LƯỚI 2X2)
            _buildWeightGridSelector(),
            const SizedBox(height: 20),

            // SECTION 3: DỊCH VỤ BỔ SUNG
            _buildAddonsSection(),
            const SizedBox(height: 16),

            // SECTION 4: THẺ GỢI Ý & TRẤN AN AN TÂM
            _buildTrustAndGuideCards(),
            const SizedBox(height: 100), // Khoảng trống cho bottom sheet
          ],
        ),
      ),

      // 2. STICKY BOTTOM SUMMARY BAR & NÚT CHUYỂN BƯỚC
      bottomSheet: _buildStickyBottomBar(context, totalPrice, currentWeightLabel),
    );
  }

  // --- WIDGET 1: STEPPER PROGRESS BAR ---
  Widget _buildProgressStepper() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: surfaceContainer),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BƯỚC 1 / 3',
                style: GoogleFonts.plusJakartaSans(
                  color: primaryColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Đang chọn dịch vụ & kg',
                  style: GoogleFonts.plusJakartaSans(
                    color: primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: surfaceHigh,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: surfaceHigh,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- WIDGET 2: CHỌN GÓI GIẶT ---
  Widget _buildServiceSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Chọn gói giặt',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: onSurface,
              ),
            ),
            Text(
              '2 lựa chọn',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: outlineColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedService = 1),
                child: _buildServiceCard(
                  title: 'Giặt sấy tinh tươm',
                  sub: 'Giặt sạch, sấy khô thơm tho',
                  price: '25.000đ/kg',
                  icon: Icons.local_laundry_service,
                  isSelected: selectedService == 1,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedService = 2),
                child: _buildServiceCard(
                  title: 'Giặt hấp cao cấp',
                  sub: 'Vest, dạ, lụa & váy tiệc',
                  price: '60.000đ/món',
                  icon: Icons.dry_cleaning,
                  isSelected: selectedService == 2,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String sub,
    required String price,
    required IconData icon,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? primaryColor.withOpacity(0.05) : cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? primaryColor : outlineVariant.withOpacity(0.6),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor.withOpacity(0.15) : surfaceLow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isSelected ? primaryColor : outlineColor,
                ),
              ),
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 20,
                color: isSelected ? primaryColor : outlineVariant,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: outlineColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: surfaceHigh),
          const SizedBox(height: 6),
          Text(
            price,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? primaryColor : outlineColor,
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET 3: KHỐI LƯỢNG ƯỚC TÍNH (LƯỚI 2X2) ---
  Widget _buildWeightGridSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Khối lượng ước tính',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: onSurface,
              ),
            ),
            Text(
              'Cân lại khi nhận đồ',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: outlineColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: weightOptions.length,
          itemBuilder: (context, index) {
            final option = weightOptions[index];
            final bool isSelected = selectedWeightIndex == index;
            final bool isUnclear = index == 3;

            return GestureDetector(
              onTap: () => setState(() => selectedWeightIndex = index),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor.withOpacity(0.05) : cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? primaryColor : outlineVariant.withOpacity(0.6),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (isUnclear) ...[
                              const Icon(Icons.balance, size: 16, color: primaryColor),
                              const SizedBox(width: 4),
                            ],
                            Text(
                              option['label'],
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: onSurface,
                              ),
                            ),
                            if (option['isPopular'] == true) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'PHỔ BIẾN',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Icon(
                          isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                          size: 18,
                          color: isSelected ? primaryColor : outlineVariant,
                        ),
                      ],
                    ),
                    Text(
                      option['sub'],
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: outlineColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // --- WIDGET 4: DỊCH VỤ BỔ SUNG ---
  Widget _buildAddonsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Dịch vụ bổ sung',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: onSurface,
              ),
            ),
            Text(
              'Tùy chọn thêm',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: outlineColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        _buildAddonTile(
          icon: Icons.iron,
          title: 'Ủi hơi nước chống nhăn',
          sub: 'Áo sơ mi, đầm & quần âu',
          priceTag: '+20.000đ',
          isFree: false,
          isChecked: addonIron,
          onTap: () => setState(() => addonIron = !addonIron),
        ),
        const SizedBox(height: 8),

        _buildAddonTile(
          icon: Icons.local_florist,
          title: 'Hương hoa ban mai cao cấp',
          sub: 'Lưu hương dài lâu dịu nhẹ',
          priceTag: 'MIỄN PHÍ',
          isFree: true,
          isChecked: addonFragrance,
          onTap: () => setState(() => addonFragrance = !addonFragrance),
        ),
        const SizedBox(height: 8),

        _buildAddonTile(
          icon: Icons.verified,
          title: 'Túi vải niêm phong 3T',
          sub: 'Bảo vệ quần áo chống ẩm & mưa bụi',
          priceTag: 'MIỄN PHÍ',
          isFree: true,
          isChecked: addonBag,
          onTap: () => setState(() => addonBag = !addonBag),
        ),
      ],
    );
  }

  Widget _buildAddonTile({
    required IconData icon,
    required String title,
    required String sub,
    required String priceTag,
    required bool isFree,
    required bool isChecked,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isChecked ? primaryColor.withOpacity(0.05) : cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isChecked ? primaryColor.withOpacity(0.4) : outlineVariant.withOpacity(0.6),
          ),
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
                    color: isChecked ? primaryColor.withOpacity(0.15) : surfaceLow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: isChecked ? primaryColor : outlineColor,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: onSurface,
                          ),
                        ),
                        if (isFree) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: secondaryColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'MIỄN PHÍ',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: secondaryColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      sub,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: outlineColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                if (!isFree)
                  Text(
                    priceTag,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                const SizedBox(width: 8),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isChecked ? primaryColor : cardBg,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isChecked ? primaryColor : outlineVariant,
                    ),
                  ),
                  child: isChecked
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET 5: TRUST & GUIDE CARDS ---
  Widget _buildTrustAndGuideCards() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: surfaceLow,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: surfaceContainer),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shopping_bag, size: 14, color: primaryColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: onSurface, height: 1.4),
                    children: [
                      TextSpan(
                        text: 'Gợi ý: ',
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: primaryColor),
                      ),
                      const TextSpan(text: '5.0 kg tương đương khoảng '),
                      TextSpan(
                        text: '15 – 20 món đồ ',
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: '(5 áo thun, 3 quần jean, 4 đồ lót, 2 khăn tắm, 2 áo khoác nhẹ).'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: outlineVariant.withOpacity(0.6)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('💡', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: outlineColor, height: 1.4),
                    children: [
                      TextSpan(
                        text: 'Đừng lo nếu chưa chọn chuẩn kg! ',
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: onSurface),
                      ),
                      const TextSpan(
                        text: 'Shipper 3T sẽ mang cân điện tử tới cân lại thực tế khi nhận đồ và chốt hóa đơn chính xác cho bạn.',
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

  // --- WIDGET 6: STICKY BOTTOM BAR & CHUYỂN BƯỚC ---
  Widget _buildStickyBottomBar(BuildContext context, int totalPrice, String weightLabel) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 20),
      decoration: BoxDecoration(
        color: bgSurface.withOpacity(0.98),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.12),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      totalPrice == 0
                          ? 'Tạm tính (Shipper cân sau)'
                          : 'Tạm tính ước lượng (Gói $weightLabel)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: outlineColor,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          totalPrice == 0
                              ? 'Tính sau'
                              : '${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        if (totalPrice > 0) ...[
                          const SizedBox(width: 6),
                          Text(
                            '${(totalPrice + 20000).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: outlineColor,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_shipping, size: 12, color: secondaryColor),
                      const SizedBox(width: 4),
                      Text(
                        'Freeship nội khu',
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
            const SizedBox(height: 10),

            // Nút bấm lớn chuyển sang Bước 2
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // 🚀 Chuyển hướng sang BookingStep2Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookingStep2Screen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  elevation: 4,
                  shadowColor: primaryColor.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tiếp tục: Chọn lịch & Địa chỉ',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}