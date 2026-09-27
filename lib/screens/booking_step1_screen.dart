import 'package:flutter/material.dart';
import 'booking_step2_screen.dart';

class BookingStep1Screen extends StatefulWidget {
  const BookingStep1Screen({super.key});

  @override
  State<BookingStep1Screen> createState() => _BookingStep1ScreenState();
}

class _BookingStep1ScreenState extends State<BookingStep1Screen> {
  // --- MÀU SẮC CHỦ ĐẠO TỪ THEME ---
  static const Color primaryColor = Color(0xFFB90538);
  static const Color secondaryColor = Color(0xFFB4136D);
  static const Color backgroundColor = Color(0xFFFFF8F7);
  static const Color containerLowColor = Color(0xFFFFF0F0);
  static const Color containerColor = Color(0xFFFFE9EA);
  static const Color containerHighColor = Color(0xFFFFE1E3);

  // --- QUẢN LÝ TRẠNG THÁI SỐ LƯỢNG ---
  double kg = 3.5;
  int lenCount = 2;
  int luaCount = 1;

  // --- SELECTION (RADIO & CHECKBOX) ---
  String selectedDetergent = 'eco'; // 'eco', 'downy', 'omo'
  String selectedSoftener = 'lavender'; // 'lavender', 'passion', 'none'

  bool addonStain = true;
  bool addonUv = false;
  bool addonIron = false;
  bool addonExpress = false;

  // --- HÀM TÍNH TỔNG TIỀN ĐỘNG ---
  int calculateTotal() {
    double base = (kg * 18000) + (lenCount * 25000) + (luaCount * 50000);

    if (addonStain) base += 15000;
    if (addonUv) base += 10000;
    if (addonIron) base += 10000;
    if (addonExpress) base = base * 1.3;

    return base.round();
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = calculateTotal();
    int totalItems = lenCount + luaCount;

    return Scaffold(
      backgroundColor: backgroundColor,
      // 1. THANH HEADER TRÊN CÙNG
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Chi Tiết Dịch Vụ',
          style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida/AEtjO1WPa14-Gu1lGEuCFeupI6LQHyolb_Z76YemKA4M9TkVUyjlNl34_077Ov_z7CPdxeuPjOZgIq8f-7fTE0jmNPaDfvixwRcBuJhrygMjfOzbLV03lqqWBc0XIeASfSu6b7Rndhl_a1Nd5ZrhbH8avYtolK38EVocgWywWKekj2yYtp5FoyQoXf_7l-QlCU6Ary1ZpdKFwHO4aAKI7DOPtRogPEGE1sgFYInSG6TuG8UcrDCNfZ6VDhhMZHQA'),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STEPPER BAR (BƯỚC 1/3)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'BƯỚC 1 / 3',
                        style: TextStyle(color: primaryColor, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Đang chọn đồ',
                          style: TextStyle(color: primaryColor, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chọn dịch vụ & Chi tiết đồ',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      Icon(Icons.local_laundry_service, color: primaryColor, size: 20),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Container(height: 6, decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(3)))),
                      const SizedBox(width: 4),
                      Expanded(child: Container(height: 6, decoration: BoxDecoration(color: containerHighColor, borderRadius: BorderRadius.circular(3)))),
                      const SizedBox(width: 4),
                      Expanded(child: Container(height: 6, decoration: BoxDecoration(color: containerHighColor, borderRadius: BorderRadius.circular(3)))),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // QUICK CATEGORIES NAV
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryChip('Giặt sấy theo kg', Icons.local_laundry_service, isSelected: true),
                  _buildCategoryChip('Giặt khô & hấp', Icons.dry_cleaning),
                  _buildCategoryChip('Giày & Túi xách', Icons.roller_skating),
                  _buildCategoryChip('Rèm & Chăn ga', Icons.curtains),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // SECTION: DANH MỤC ĐỒ CẦN GIẶT
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.checkroom, color: secondaryColor, size: 22),
                    SizedBox(width: 6),
                    Text('Danh mục đồ cần giặt', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                Text('Tối thiểu 1 món', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 12),

            // ITEM 1: Đồ thường hàng ngày (kg)
            _buildLaundryItem(
              title: 'Đồ thường hàng ngày',
              price: '18.000đ/kg',
              subtitle: 'Áo thun, sơ mi thông dụng, quần shorts, đồ mặc nhà',
              tag: 'Phân loại màu tự động',
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCTZkBvDvYP-suhIvgnwDsym3FLfWctPYsdpGg2v2CoDIVKakwhYbuK3jwSgUvd2IqlZ1ekmpv0isqYATr4kLzdBposUiQcbuW51UdDUUilVe4LvBceqZOKk3390CPgEVshfwSweJ8c9bRJmTsApmbbvDwGzdu9MUz_0P30bZVfQc6VYK1ExrEyuvAOIq4O8L0TopoDOHLmyiFJzHSa0NRxrzoOF3oTF62WBWnFa1_xcrCMMMvdHEDBrw',
              controlWidget: _buildStepperControl(
                label: 'Ước tính khối lượng:',
                valueText: '$kg kg',
                onMinus: () {
                  if (kg > 0.5) setState(() => kg = (kg - 0.5));
                },
                onPlus: () => setState(() => kg = (kg + 0.5)),
              ),
            ),
            const SizedBox(height: 12),

            // ITEM 2: Len Cashmere
            _buildLaundryItem(
              title: 'Len Cashmere / Dạ tweed',
              price: '25.000đ/cái',
              subtitle: 'Bảo vệ cấu trúc sợi, chống dão & co rút',
              tag: 'Giặt lồng riêng',
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBBKXP9LJWR_0iI7eCyEAbb7Kx4dPqz5lnE2H7q_6wPufno3nCATKdhYAXAIN70-AojsazJ-wXEqA89YHUOrlTN1rkvMzNG6ZB--jfNhX0cFruqcxwsKOj-6JBcMikkCBbSw0DLU1N50KPxJKKCUMzxwXatNsaxjgAIRbCQimfwkY0JSZaXcz3WsUopaSTgMCxJc8qUD1BDZ2GtJ2nKm8AjoyD0EZwfUdHOHP_EM840KhG2d3B0IeqP1A',
              controlWidget: _buildStepperControl(
                label: 'Số lượng áo:',
                valueText: '$lenCount cái',
                onMinus: () {
                  if (lenCount > 0) setState(() => lenCount--);
                },
                onPlus: () => setState(() => lenCount++),
              ),
            ),
            const SizedBox(height: 12),

            // ITEM 3: Đầm lụa
            _buildLaundryItem(
              title: 'Đầm lụa / Đồ dạ hội',
              price: '50.000đ/cái',
              subtitle: 'Ủi phom dáng 3D chuyên sâu',
              tag: 'Hấp dung môi hữu cơ',
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDIsD0spI5ZXxHjf_X8p1Juaxs8R--8TvkT_ZT_slLVlK2AcYDmqmMUY43TlnYegwxhpA4e_Swvl5IX04T2DnjoDELq3TQRP0rCXyqJJLZv_ipuYOI8N5m-CAh5By5rAgXG64PGhe3eQ-oegYei2SQfVSukV6ydSPcQ_zYYCn07hwzdD2nLiUeIhb014_pjbseU25s4KoI-bYNXjS88dGZNlF921MYsCfJLf9wGZlUnW77PXH4naJA5nQ',
              controlWidget: _buildStepperControl(
                label: 'Số lượng váy/đầm:',
                valueText: '$luaCount cái',
                onMinus: () {
                  if (luaCount > 0) setState(() => luaCount--);
                },
                onPlus: () => setState(() => luaCount++),
              ),
            ),
            const SizedBox(height: 24),

            // SECTION: NƯỚC GIẶT XẢ & XỬ LÝ 3T
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.tune, color: primaryColor, size: 22),
                    SizedBox(width: 6),
                    Text('Nước giặt xả & Xử lý 3T', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                Text('Chuẩn Spa Vải', style: TextStyle(fontSize: 12, color: primaryColor, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),

            // NƯỚC GIẶT CAO CẤP
            _buildCardOptionGroup(
              title: 'Nước giặt cao cấp',
              subTitle: 'Miễn phí',
              children: [
                _buildRadioOption('eco', 'Organic Eco Dịu Nhẹ', 'Chiết xuất dừa & hoa trà tự nhiên, lành tính da em bé', selectedDetergent, (v) => setState(() => selectedDetergent = v!), badge: 'Khuyên dùng'),
                _buildRadioOption('downy', 'Downy Nắng Mai', 'Hương thơm thanh mát, sảng khoái suốt 48h', selectedDetergent, (v) => setState(() => selectedDetergent = v!)),
                _buildRadioOption('omo', 'OMO Khử Mùi Thể Thao', 'Kháng khuẩn, diệt mồ hôi sâu trong từng thớ vải', selectedDetergent, (v) => setState(() => selectedDetergent = v!)),
              ],
            ),
            const SizedBox(height: 12),

            // NƯỚC XẢ VẢI LƯU HƯƠNG
            _buildCardOptionGroup(
              title: 'Nước xả vải lưu hương',
              subTitle: 'Miễn phí',
              children: [
                _buildRadioOption('lavender', 'Comfort Hoa Oải Hương Pháp', 'Hương thơm thư giãn, tinh dầu kháng khuẩn tự nhiên', selectedSoftener, (v) => setState(() => selectedSoftener = v!)),
                _buildRadioOption('passion', 'Downy Nước Hoa Đam Mê', 'Nồng nàn, sang trọng tựa nước hoa Pháp', selectedSoftener, (v) => setState(() => selectedSoftener = v!)),
                _buildRadioOption('none', 'Không dùng nước xả', 'Dành cho làn da siêu nhạy cảm hoặc vải chuyên dụng', selectedSoftener, (v) => setState(() => selectedSoftener = v!)),
              ],
            ),
            const SizedBox(height: 12),

            // XỬ LÝ TĂNG CƯỜNG (CHECKBOX)
            _buildCardOptionGroup(
              title: 'Xử lý tăng cường (Tùy chọn)',
              subTitle: 'Tùy nhu cầu',
              children: [
                _buildCheckboxOption('Tẩy ố cổ áo, nách áo chuyên sâu', 'Sử dụng hoạt chất oxy sinh học bóc tách vết ố vàng', '+15.000đ', addonStain, (v) => setState(() => addonStain = v!)),
                _buildCheckboxOption('Xử lý diệt khuẩn tia cực tím UV', 'Loại bỏ 99.9% vi khuẩn, ẩm mốc ẩn sâu', '+10.000đ', addonUv, (v) => setState(() => addonUv = v!)),
                _buildCheckboxOption('Ủi phẳng li & Màng bọc sinh học', 'Ủi hơi nước đứng, bọc màng chống bụi mịn', '+10.000đ', addonIron, (v) => setState(() => addonIron = v!)),
                _buildCheckboxOption('Giặt hỏa tốc 4h', 'Ưu tiên máy giặt riêng, giao ngay trong buổi', '+30% phí', addonExpress, (v) => setState(() => addonExpress = v!), badge: 'Siêu nhanh'),
              ],
            ),
            const SizedBox(height: 16),

            // GHI CHÚ
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.edit_note, color: primaryColor, size: 20),
                      SizedBox(width: 6),
                      Text('Lưu ý đặc biệt cho thợ giặt 3T', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Nhập lưu ý vết bẩn khó giặt, loại cúc áo dễ vỡ hoặc hướng dẫn bảo quản mác áo...',
                      hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                      fillColor: containerLowColor,
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    children: [
                      Icon(Icons.verified_user, color: Colors.teal, size: 14),
                      SizedBox(width: 4),
                      Text('Cam kết kiểm tra túi áo & bảo hiểm áo quần 100%', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),

      // 2. STICKY BOTTOM SUMMARY BAR & NÚT CHUYỂN BƯỚC
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: primaryColor.withOpacity(0.12), blurRadius: 16, offset: const Offset(0, -4)),
          ],
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
                      Text('Tạm tính ước lượng ($totalItems món & ${kg}kg)', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            '${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
                          ),
                          const SizedBox(width: 6),
                          const Text('195.000đ', style: TextStyle(fontSize: 11, color: Colors.grey, decoration: TextDecoration.lineThrough)),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: secondaryColor.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                    child: const Row(
                      children: [
                        Icon(Icons.local_shipping, size: 12, color: secondaryColor),
                        SizedBox(width: 4),
                        Text('Freeship nội khu', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: secondaryColor)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BookingStep2Screen(),
                  ),
                );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                   padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Tiếp tục: Chọn lịch & Địa chỉ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- HÀM TẠO CHIP DANH MỤC ---
  Widget _buildCategoryChip(String title, IconData icon, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? primaryColor : containerLowColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.black87),
          const SizedBox(width: 6),
          Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : Colors.black87)),
        ],
      ),
    );
  }

  // --- HÀM TẠO MÓN ĐỒ GIẶT ---
  Widget _buildLaundryItem({
    required String title,
    required String price,
    required String subtitle,
    required String tag,
    required String imageUrl,
    required Widget controlWidget,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: containerHighColor, borderRadius: BorderRadius.circular(10)),
                          child: Text(price, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: primaryColor)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: containerLowColor, borderRadius: BorderRadius.circular(6)),
                      child: Text(tag, style: const TextStyle(fontSize: 10, color: primaryColor, fontWeight: FontWeight.w500)),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          controlWidget,
        ],
      ),
    );
  }

  // --- HÀM TẠO NÚT TĂNG GIẢM ---
  Widget _buildStepperControl({
    required String label,
    required String valueText,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: containerLowColor, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black87)),
          Row(
            children: [
              InkWell(
                onTap: onMinus,
                child: const CircleAvatar(radius: 12, backgroundColor: Colors.white, child: Icon(Icons.remove, size: 14, color: primaryColor)),
              ),
              SizedBox(width: 40, child: Text(valueText, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              InkWell(
                onTap: onPlus,
                child: const CircleAvatar(radius: 12, backgroundColor: primaryColor, child: Icon(Icons.add, size: 14, color: Colors.white)),
              ),
            ],
          )
        ],
      ),
    );
  }

  // --- HÀM TẠO KHUNG CARD TÙY CHỌN ---
  Widget _buildCardOptionGroup({required String title, required String subTitle, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(subTitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  // --- HÀM TẠO RADIO OPTION ---
  Widget _buildRadioOption(String val, String title, String desc, String groupVal, ValueChanged<String?> onChanged, {String? badge}) {
    bool isSelected = val == groupVal;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isSelected ? containerLowColor : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: RadioListTile<String>(
        value: val,
        groupValue: groupVal,
        onChanged: onChanged,
        activeColor: primaryColor,
        dense: true,
        title: Row(
          children: [
            Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            if (badge != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                child: Text(badge, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: primaryColor)),
              ),
            ]
          ],
        ),
        subtitle: Text(desc, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ),
    );
  }

  // --- HÀM TẠO CHECKBOX OPTION ---
  Widget _buildCheckboxOption(String title, String desc, String priceText, bool isChecked, ValueChanged<bool?> onChanged, {String? badge}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isChecked ? containerLowColor : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CheckboxListTile(
        value: isChecked,
        onChanged: onChanged,
        activeColor: primaryColor,
        dense: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(child: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                  if (badge != null) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(color: secondaryColor.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                      child: Text(badge, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: secondaryColor)),
                    ),
                  ]
                ],
              ),
            ),
            Text(priceText, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isChecked ? primaryColor : Colors.grey)),
          ],
        ),
        subtitle: Text(desc, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ),
    );
  }
}