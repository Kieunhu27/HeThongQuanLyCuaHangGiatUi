import 'package:flutter/material.dart';
import 'booking_step3_screen.dart';

class BookingStep2Screen extends StatefulWidget {
  final double totalPrice;

  const BookingStep2Screen({super.key, this.totalPrice = 178000});

  @override
  State<BookingStep2Screen> createState() => _BookingStep2ScreenState();
}

class _BookingStep2ScreenState extends State<BookingStep2Screen> {
  // Brand Colors (Đồng bộ tone màu Rose Pink)
  final Color primaryColor = const Color(0xFFB90538);
  final Color surfaceContainer = const Color(0xFFFFE9EA);
  final Color surfaceContainerLow = const Color(0xFFFFF0F0);
  final Color surfaceContainerHighest = const Color(0xFFFFD9DC);

  // State Variables
  int _selectedAddressIndex = 0;
  bool _sameDeliveryAddress = true;
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = 0;

  final TextEditingController _shipperNoteController = TextEditingController();

  final List<Map<String, String>> _dates = [
    {'title': 'Hôm nay', 'date': '26/09', 'sub': 'Thứ 7'},
    {'title': 'Ngày mai', 'date': '27/09', 'sub': 'Chủ nhật'},
    {'title': 'Thứ 2', 'date': '28/09', 'sub': 'Tháng 9'},
    {'title': 'Thứ 3', 'date': '29/09', 'sub': 'Tháng 9'},
  ];

  final List<Map<String, String>> _timeSlots = [
    {'time': '08:00 - 10:00', 'tag': 'Khung giờ phổ biến'},
    {'time': '10:00 - 12:00', 'tag': 'Còn 3 lượt nhận'},
    {'time': '14:00 - 16:00', 'tag': 'Buổi chiều'},
    {'time': '16:00 - 18:00', 'tag': 'Tan tầm'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Đặt Lịch Thu Giao Hàng',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '3T Express',
              style: TextStyle(
                color: primaryColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Stepper Progress
                  _buildStepperHeader(),
                  const SizedBox(height: 20),

                  // 2. Address Selection Section
                  _buildSectionTitle(
                    title: 'Địa chỉ thu & Trả đồ',
                    icon: Icons.location_on,
                    trailing: TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text(
                        'Thêm mới',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildAddressCard(
                    index: 0,
                    title: 'Nhà riêng',
                    isDefault: true,
                    phone: '0935 *** 029',
                    name: 'Nguyễn Kiều Như',
                    address:
                        'Căn hộ Heritage Manor, Căn 302, 128 Hai Bà Trưng, P. Bến Nghé, Quận 1, TP. Hồ Chí Minh',
                  ),
                  const SizedBox(height: 10),
                  _buildAddressCard(
                    index: 1,
                    title: 'Trường Đại học HUIT',
                    isDefault: false,
                    phone: '0935 *** 029',
                    name: 'Nguyễn Kiều Như - Phòng Thí nghiệm CNTT',
                    address:
                        '140 Lê Trọng Tấn, P. Tây Thạnh, Q. Tân Phú, TP. Hồ Chí Minh',
                  ),
                  const SizedBox(height: 10),
                  _buildSameAddressToggle(),
                  const SizedBox(height: 24),

                  // 3. Pickup Date & Time Picker
                  _buildSectionTitle(
                    title: 'Giờ Shipper qua lấy đồ',
                    icon: Icons.local_shipping,
                    trailing: Row(
                      children: const [
                        Icon(Icons.bolt, size: 16, color: Color(0xFF006577)),
                        Text(
                          'Lấy đồ trong 30p',
                          style: TextStyle(
                            color: Color(0xFF006577),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDatePicker(),
                  const SizedBox(height: 12),
                  _buildTimeSlotGrid(),
                  const SizedBox(height: 20),

                  // 4. Delivery Estimation Notice
                  _buildEstimateBanner(),
                  const SizedBox(height: 16),

                  // 5. Shipper Notes
                  _buildShipperNoteInput(),
                  const SizedBox(
                    height: 100,
                  ), // Khoảng trống cuộn tránh che đè button
                ],
              ),
            ),
          ),

          // Sticky Bottom Bar
          _buildBottomCTA(),
        ],
      ),
    );
  }

  // --- WIDGET HELPER METHODS ---

  Widget _buildStepperHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BƯỚC 2 / 3',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Lịch & Địa chỉ',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Chọn địa chỉ & Hẹn giờ Shipper',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.schedule, color: primaryColor, size: 20),
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
                    color: surfaceContainerHighest,
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

  Widget _buildSectionTitle({
    required String title,
    required IconData icon,
    Widget? trailing,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: primaryColor, size: 22),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildAddressCard({
    required int index,
    required String title,
    required bool isDefault,
    required String phone,
    required String name,
    required String address,
  }) {
    bool isSelected = _selectedAddressIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedAddressIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Radio<int>(
              value: index,
              groupValue: _selectedAddressIndex,
              activeColor: primaryColor,
              onChanged: (val) => setState(() => _selectedAddressIndex = val!),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          if (isDefault) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Mặc định',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        phone,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    address,
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSameAddressToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.sync_alt, size: 18, color: Color(0xFF006577)),
              SizedBox(width: 8),
              Text(
                'Giao lại đồ cùng địa chỉ thu',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Checkbox(
            value: _sameDeliveryAddress,
            activeColor: primaryColor,
            onChanged: (val) =>
                setState(() => _sameDeliveryAddress = val ?? true),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _dates.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedDateIndex == index;
          var item = _dates[index];
          return GestureDetector(
            onTap: () => setState(() => _selectedDateIndex = index),
            child: Container(
              width: 85,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? primaryColor : surfaceContainerHighest,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 6,
                    ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item['title']!,
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected ? Colors.white70 : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['date']!,
                    style: TextStyle(
                      fontSize: 15,
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['sub']!,
                    style: TextStyle(
                      fontSize: 9,
                      color: isSelected ? Colors.white : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeSlotGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _timeSlots.length,
      itemBuilder: (context, index) {
        bool isSelected = _selectedTimeIndex == index;
        var item = _timeSlots[index];
        return GestureDetector(
          onTap: () => setState(() => _selectedTimeIndex = index),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? primaryColor : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['time']!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['tag']!,
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected ? primaryColor : Colors.grey,
                      ),
                    ),
                  ],
                ),
                Icon(
                  isSelected
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: isSelected ? primaryColor : Colors.grey,
                  size: 18,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEstimateBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(color: Color(0xFF006577), width: 4),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF006577), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Thời gian dự kiến trả đồ sạch:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2),
                Text(
                  'Giặt sấy tiêu chuẩn mất khoảng 24h. Dự kiến trả đồ lúc 10:00 Sáng mai (27/09).',
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShipperNoteInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.directions_bike, color: primaryColor, size: 18),
              const SizedBox(width: 6),
              const Text(
                'Ghi chú cho Shipper thu đồ',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _shipperNoteController,
            maxLines: 2,
            style: const TextStyle(fontSize: 12),
            decoration: InputDecoration(
              hintText:
                  'Ví dụ: Gọi trước 10 phút, gửi đồ ở lễ tân chung cư A2...',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 11),
              fillColor: surfaceContainerLow,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCTA() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
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
                    const Text(
                      'Tổng thanh toán tạm tính',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    Row(
                      children: [
                        Text(
                          '${widget.totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          '(Freeship 0đ)',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF006577),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Hẹn: ${_timeSlots[_selectedTimeIndex]['time']}',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingStep3Screen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      ' Xác nhận và Thanh toán tạm tính ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18, color: Colors.white),
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
