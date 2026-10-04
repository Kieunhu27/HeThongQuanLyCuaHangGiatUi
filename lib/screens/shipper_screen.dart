import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum OrderType { pickup, delivery }
enum ShipperOrderStatus {
  available,      // Đơn mới chưa ai nhận / Chờ shipper nhận
  pickingUp,      // Shipper đang tới nhà khách lấy đồ
  inStore,        // Đã về cửa hàng (đang giặt sấy)
  delivering,     // Shipper đang giao đồ sạch tới nhà khách
  completed,      // Đã hoàn thành
  cancelled,      // Đơn sự cố / Hủy
}

class ShipperOrderModel {
  final String id;
  final String customerName;
  final String customerPhone;
  final String pickupAddress;
  final String deliveryAddress;
  final double distanceKm;
  final OrderType type;
  ShipperOrderStatus status;
  final String serviceDetails;
  final double weightKg;
  final double codAmount;
  final bool isPaidOnline;
  final String timeWindow;
  final String customerNote;
  final String? proofPhotoUrl;
  final List<Map<String, dynamic>> items; // Danh sách đồ gửi kèm: loại đồ, khối lượng (kg), dịch vụ, trạng thái

  ShipperOrderModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.distanceKm,
    required this.type,
    required this.status,
    required this.serviceDetails,
    required this.weightKg,
    required this.codAmount,
    required this.isPaidOnline,
    required this.timeWindow,
    required this.customerNote,
    this.proofPhotoUrl,
    this.items = const [],
  });
}

class ShipperScreen extends StatefulWidget {
  const ShipperScreen({super.key});

  @override
  State<ShipperScreen> createState() => _ShipperScreenState();
}

class _ShipperScreenState extends State<ShipperScreen> with SingleTickerProviderStateMixin {
  // Brand Color Tokens
  static const Color primaryColor = Color(0xFFB90538);
  static const Color secondaryColor = Color(0xFFB4136D);
  static const Color tertiaryColor = Color(0xFF006577);
  static const Color bgSurface = Color(0xFFFFF8F7);
  static const Color cardBg = Colors.white;
  static const Color surfaceLow = Color(0xFFFFF0F0);
  static const Color surfaceHigh = Color(0xFFFFE1E3);
  static const Color onSurface = Color(0xFF370C14);
  static const Color outlineColor = Color(0xFF8F6F71);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);

  bool _isOnline = true;
  int _selectedFilterIndex = 0; // 0: Cần lấy, 1: Cần giao, 2: Đã hoàn tất
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  late TabController _tabController;

  // Shipper Stats
  static const double _kpiPerOrder = 30000; // Thưởng KPI mỗi đơn hoàn thành
  static const double _baseSalary = 10000000; // Lương cứng cố định
  double _violationFee = 50000; // Phí vi phạm (mock)
  int _todayCompletedCount = 7;

  double get kpiEarnings => _todayCompletedCount * _kpiPerOrder;
  double get totalIncome => kpiEarnings + _baseSalary - _violationFee;

  // Mock data đơn hàng shipper
  final List<ShipperOrderModel> _orders = [
    ShipperOrderModel(
      id: 'WS3T-9102',
      customerName: 'Trần Thị Mai',
      customerPhone: '0903 123 456',
      pickupAddress: 'Căn 402, Chung cư Horizon, 214 Trần Quang Khải, Q.1',
      deliveryAddress: 'Tiệm WashSmart 3T - 45 Nguyễn Huệ, P. Bến Nghé, Q.1',
      distanceKm: 1.4,
      type: OrderType.pickup,
      status: ShipperOrderStatus.available,
      serviceDetails: 'Giặt sấy tinh tươm + Ủi hơi nước 3T',
      weightKg: 5.2,
      codAmount: 135000,
      isPaidOnline: false,
      timeWindow: '14:30 - 15:30 Hôm nay',
      customerNote: 'Gọi trước khi đến 10 phút, bấm chuông mã 402.',
      items: [
        {'type': 'Áo thun', 'kg': 1.4, 'service': 'Giặt sấy tinh tươm', 'status': 'Đã xác nhận'},
        {'type': 'Quần jean', 'kg': 1.6, 'service': 'Giặt sấy tinh tươm', 'status': 'Đang giặt'},
        {'type': 'Áo sơ mi', 'kg': 2.2, 'service': 'Ủi hơi nước 3T', 'status': 'Đang sấy'},
      ],
    ),
    ShipperOrderModel(
      id: 'WS3T-8892',
      customerName: 'Nguyễn Kiều Như',
      customerPhone: '0988 777 999',
      pickupAddress: 'Tiệm WashSmart 3T - 45 Nguyễn Huệ, Q.1',
      deliveryAddress: 'Heritage Manor, Căn 302, 128 Hai Bà Trưng, Q.1',
      distanceKm: 2.1,
      type: OrderType.delivery,
      status: ShipperOrderStatus.delivering,
      serviceDetails: 'Giặt sấy thơm lâu + Mắc áo niêm phong UV',
      weightKg: 4.2,
      codAmount: 0,
      isPaidOnline: true,
      timeWindow: 'Giao trước 16:30',
      customerNote: 'Gửi bảo vệ tòa nhà nếu không nghe máy.',
      items: [
        {'type': 'Chăn ga gối', 'kg': 2.4, 'service': 'Giặt sấy thơm lâu', 'status': 'Đang giặt'},
        {'type': 'Bộ drap giường', 'kg': 1.8, 'service': 'Mắc áo niêm phong UV', 'status': 'Hoàn tất'},
      ],
    ),
    ShipperOrderModel(
      id: 'WS3T-9055',
      customerName: 'Lê Hoàng Nam',
      customerPhone: '0912 345 678',
      pickupAddress: '158 Điện Biên Phủ, P.15, Q. Bình Thạnh',
      deliveryAddress: 'Tiệm WashSmart 3T - 45 Nguyễn Huệ, Q.1',
      distanceKm: 3.5,
      type: OrderType.pickup,
      status: ShipperOrderStatus.pickingUp,
      serviceDetails: 'Giặt khô hấp 2 Bộ Vest & 1 Đầm dạ hội',
      weightKg: 3.0,
      codAmount: 220000,
      isPaidOnline: false,
      timeWindow: '15:00 - 16:00',
      customerNote: 'Cần túi niêm phong riêng cho áo vest.',
      items: [
        {'type': 'Bộ Vest nam', 'kg': 2.0, 'service': 'Giặt khô hấp', 'status': 'Đã xác nhận'},
        {'type': 'Đầm dạ hội', 'kg': 1.0, 'service': 'Giặt khô hấp', 'status': 'Đang ủi'},
      ],
    ),
    ShipperOrderModel(
      id: 'WS3T-8740',
      customerName: 'Phạm Minh Anh',
      customerPhone: '0977 112 233',
      pickupAddress: 'Tiệm WashSmart 3T - 45 Nguyễn Huệ, Q.1',
      deliveryAddress: '72 Lê Thánh Tôn, P. Bến Nghé, Q.1',
      distanceKm: 0.8,
      type: OrderType.delivery,
      status: ShipperOrderStatus.completed,
      serviceDetails: 'Vệ sinh 2 đôi Giày Sneaker + Phủ Nano',
      weightKg: 1.5,
      codAmount: 180000,
      isPaidOnline: false,
      timeWindow: 'Đã giao lúc 11:20',
      customerNote: 'Khách đã nhận đủ và ký xác nhận.',
      items: [
        {'type': 'Giày Sneaker', 'kg': 0.8, 'service': 'Vệ sinh chuyên sâu', 'status': 'Hoàn tất'},
        {'type': 'Giày Sneaker (Phủ Nano)', 'kg': 0.7, 'service': 'Phủ Nano chống bẩn', 'status': 'Hoàn tất'},
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<ShipperOrderModel> get filteredOrders {
    return _orders.where((order) {
      // Filter by tab (0: Cần lấy, 1: Cần giao, 2: Đã hoàn tất)
      if (_selectedFilterIndex == 0) {
        if (order.type != OrderType.pickup || order.status == ShipperOrderStatus.completed) return false;
      }
      if (_selectedFilterIndex == 1) {
        if (order.type != OrderType.delivery || order.status == ShipperOrderStatus.completed) return false;
      }
      if (_selectedFilterIndex == 2 && order.status != ShipperOrderStatus.completed) return false;

      // Filter by search text
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchId = order.id.toLowerCase().contains(q);
        final matchName = order.customerName.toLowerCase().contains(q);
        final matchPhone = order.customerPhone.contains(q);
        final matchAddr = order.pickupAddress.toLowerCase().contains(q) || order.deliveryAddress.toLowerCase().contains(q);
        return matchId || matchName || matchPhone || matchAddr;
      }
      return true;
    }).toList();
  }

  void _showToast(String message, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle_rounded : Icons.info_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess ? tertiaryColor : primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _updateOrderStatus(ShipperOrderModel order, ShipperOrderStatus newStatus) {
    setState(() {
      order.status = newStatus;
      if (newStatus == ShipperOrderStatus.completed) {
        _todayCompletedCount += 1;
      }
    });

    String statusText = '';
    switch (newStatus) {
      case ShipperOrderStatus.pickingUp:
        statusText = 'Đã nhận đơn lấy hàng #${order.id}';
        break;
      case ShipperOrderStatus.inStore:
        statusText = 'Đã mang hàng #${order.id} về tiệm giặt';
        break;
      case ShipperOrderStatus.delivering:
        statusText = 'Đã nhận đơn và bắt đầu giao #${order.id}';
        break;
      case ShipperOrderStatus.completed:
        statusText = 'Đã hoàn tất đơn hàng #${order.id} thành công!';
        break;
      default:
        statusText = 'Cập nhật trạng thái đơn #${order.id}';
    }

    _showToast(statusText);
  }

  @override
  Widget build(BuildContext context) {
    int pickupCount = _orders.where((o) => o.type == OrderType.pickup && o.status != ShipperOrderStatus.completed).length;
    int deliveryCount = _orders.where((o) => o.type == OrderType.delivery && o.status != ShipperOrderStatus.completed).length;

    return Scaffold(
      backgroundColor: bgSurface,
      appBar: AppBar(
        backgroundColor: bgSurface.withOpacity(0.95),
        elevation: 0,
        scrolledUnderElevation: 1,
        titleSpacing: 16,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: onSurface),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.local_laundry_service_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SHIPPER 3T PRO',
                  style: GoogleFonts.plusJakartaSans(
                    color: primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  'Điều Phối Lấy & Giao',
                  style: GoogleFonts.plusJakartaSans(
                    color: onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Toggle Online/Offline Status
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _isOnline ? successColor.withOpacity(0.15) : outlineColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isOnline ? successColor : outlineColor,
                width: 1,
              ),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  _isOnline = !_isOnline;
                });
                _showToast(
                  _isOnline ? 'Bạn đã BẬT chế độ sẵn sàng nhận đơn' : 'Bạn đã TẮT chế độ nhận đơn (Tạm nghỉ)',
                  isSuccess: _isOnline,
                );
              },
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _isOnline ? successColor : outlineColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isOnline ? 'Trực tuyến' : 'Tạm nghỉ',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _isOnline ? successColor : outlineColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Shipper Header Info Card
            _buildShipperProfileCard(),
            const SizedBox(height: 16),

            // 2. Stats Dashboard Cards (Daily Performance & COD)
            _buildDashboardStats(),
            const SizedBox(height: 16),

            // 3. Search Bar
            _buildSearchBar(),
            const SizedBox(height: 12),

            // 4. Custom Filter Chips
            _buildFilterTabs(pickupCount, deliveryCount),
            const SizedBox(height: 16),

            // 5. Header Title & Count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Danh sách đơn (${filteredOrders.length})',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: onSurface,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _orders.shuffle();
                    });
                    _showToast('Đã làm mới danh sách đơn');
                  },
                  icon: const Icon(Icons.refresh, size: 16, color: primaryColor),
                  label: Text(
                    'Làm mới',
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

            // 6. Orders List
            filteredOrders.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredOrders.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      return _buildOrderCard(filteredOrders[index]);
                    },
                  ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  Widget _buildShipperProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB90538), Color(0xFF800326)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, size: 34, color: Colors.white),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: successColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 12, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Shipper Nguyễn Văn Hùng',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, color: Colors.amber, size: 16),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            '4.9 (128 Đánh giá)',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Xe máy 59-P1 888.99',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _showShipperWalletDialog,
            icon: const Icon(Icons.account_balance_wallet, color: Colors.white),
            tooltip: 'Ví Shipper',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Thu nhập KPI',
            value: '${(kpiEarnings / 1000).toStringAsFixed(0)}k đ',
            icon: Icons.monetization_on,
            iconBg: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            title: 'Lương cứng',
            value: '${(_baseSalary / 1000).toStringAsFixed(0)}k đ',
            icon: Icons.payments,
            iconBg: const Color(0xFFFEF3C7),
            iconColor: const Color(0xFFD97706),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            title: 'Đã xong',
            value: '$_todayCompletedCount đơn',
            icon: Icons.task_alt,
            iconBg: const Color(0xFFD1FAE5),
            iconColor: const Color(0xFF059669),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: outlineColor,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: surfaceLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
        decoration: InputDecoration(
          hintText: 'Tìm theo mã đơn, tên khách, số điện thoại, đường...',
          hintStyle: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: outlineColor.withOpacity(0.7),
          ),
          prefixIcon: const Icon(Icons.search, color: outlineColor, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18, color: outlineColor),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilterTabs(int pickupCount, int deliveryCount) {
    final filterItems = [
      //{'label': 'Tất cả', 'count': _orders.length},
      {'label': 'Cần lấy ($pickupCount)', 'count': pickupCount},
      {'label': 'Cần giao ($deliveryCount)', 'count': deliveryCount},
      {'label': 'Đã hoàn tất', 'count': _todayCompletedCount},
    ];

    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filterItems.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedFilterIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(
                filterItems[index]['label'] as String,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? Colors.white : onSurface,
                ),
              ),
              selected: isSelected,
              selectedColor: primaryColor,
              backgroundColor: cardBg,
              elevation: isSelected ? 2 : 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? primaryColor : const Color(0xFFFFD9DC),
                ),
              ),
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedFilterIndex = index;
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(ShipperOrderModel order) {
    bool isPickup = order.type == OrderType.pickup;
    Color statusBgColor;
    Color statusTextColor;
    String statusTitle;

    switch (order.status) {
      case ShipperOrderStatus.available:
        statusBgColor = const Color(0xFFFEF3C7);
        statusTextColor = const Color(0xFFD97706);
        statusTitle = isPickup ? 'CHỜ LẤY HÀNG' : 'SẴN SÀNG GIAO';
        break;
      case ShipperOrderStatus.pickingUp:
        statusBgColor = const Color(0xFFE0F2FE);
        statusTextColor = const Color(0xFF0284C7);
        statusTitle = 'ĐANG ĐẾN LẤY HÀNG';
        break;
      case ShipperOrderStatus.delivering:
        statusBgColor = surfaceHigh;
        statusTextColor = primaryColor;
        statusTitle = 'ĐANG TRÊN ĐƯỜNG GIAO';
        break;
      case ShipperOrderStatus.completed:
        statusBgColor = const Color(0xFFD1FAE5);
        statusTextColor = const Color(0xFF059669);
        statusTitle = 'HOÀN THÀNH';
        break;
      default:
        statusBgColor = surfaceLow;
        statusTextColor = outlineColor;
        statusTitle = 'ĐANG XỬ LÝ';
    }

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: order.status == ShipperOrderStatus.pickingUp || order.status == ShipperOrderStatus.delivering
              ? primaryColor.withOpacity(0.5)
              : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showOrderDetailSheet(order),
        borderRadius: BorderRadius.circular(20),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isPickup ? tertiaryColor.withOpacity(0.08) : primaryColor.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPickup ? tertiaryColor : primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isPickup ? Icons.arrow_circle_up_rounded : Icons.local_shipping_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isPickup ? 'LẤY HÀNG TẬN NƠI' : 'GIAO HÀNG TẬN TAY',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '#${order.id}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: onSurface,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusTitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: statusTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer Name & Phone & Distance
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.customerName,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.phone, size: 14, color: outlineColor),
                              const SizedBox(width: 4),
                              Text(
                                order.customerPhone,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: outlineColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: surfaceLow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.near_me, size: 14, color: primaryColor),
                          const SizedBox(width: 4),
                          Text(
                            '${order.distanceKm} km',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Pickup / Delivery Address Block
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: surfaceLow,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.trip_origin, size: 16, color: tertiaryColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isPickup ? 'Điểm lấy hàng (Nhà khách):' : 'Điểm lấy (Cửa hàng):',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    color: outlineColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  order.pickupAddress,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.0),
                        child: Divider(height: 1, color: Color(0xFFFFD9DC)),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on, size: 16, color: primaryColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isPickup ? 'Điểm đến (Cửa hàng):' : 'Điểm giao (Nhà khách):',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    color: outlineColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  order.deliveryAddress,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Service Details & Customer Notes
                Row(
                  children: [
                    const Icon(Icons.inventory_2_outlined, size: 16, color: secondaryColor),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${order.serviceDetails} (${order.weightKg} kg)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (order.customerNote.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, size: 14, color: warningColor),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Ghi chú: ${order.customerNote}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: const Color(0xFF92400E),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),

                // Danh sách đồ gửi kèm (số lượng & dịch vụ)
                if (order.items.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF2F8),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: secondaryColor.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.checklist_rounded, size: 14, color: secondaryColor),
                            const SizedBox(width: 6),
                            Text(
                              'ĐỒ GỬI KÈM (${order.items.length} loại - ${order.weightKg} kg)',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: secondaryColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...order.items.take(3).map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: secondaryColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${item['kg']} kg',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: secondaryColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${item['type']} • ${item['service']} • ${item['status']}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: onSurface,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        if (order.items.length > 3)
                          Text(
                            '+ ${order.items.length - 3} món khác...',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: outlineColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // COD & Payment Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          order.isPaidOnline ? Icons.verified_user : Icons.payments,
                          size: 16,
                          color: order.isPaidOnline ? successColor : primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          order.isPaidOnline
                              ? 'Đã thanh toán Online'
                              : 'Thu hộ COD: ${order.codAmount.toStringAsFixed(0)} đ',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: order.isPaidOnline ? successColor : primaryColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 14, color: outlineColor),
                        const SizedBox(width: 4),
                        Text(
                          order.timeWindow,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: outlineColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Action Buttons Bar (Quick Call, Maps, Action)
                Row(
                  children: [
                    // Call button
                    IconButton.filledTonal(
                      onPressed: () => _simulateCallCustomer(order),
                      icon: const Icon(Icons.call, color: primaryColor),
                      style: IconButton.styleFrom(
                        backgroundColor: surfaceLow,
                      ),
                      tooltip: 'Gọi cho khách',
                    ),
                    // Navigation Maps button
                    IconButton.filledTonal(
                      onPressed: () => _showNavigationModal(order),
                      icon: const Icon(Icons.map, color: tertiaryColor),
                      style: IconButton.styleFrom(
                        backgroundColor: tertiaryColor.withOpacity(0.1),
                      ),
                      tooltip: 'Mở chỉ đường',
                    ),
                    const SizedBox(width: 6),
                    // Main Action Button
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () => _handleOrderMainAction(order),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getActionButtonColor(order),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            _getActionButtonText(order),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
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
      ),
    );
  }

  // Bottom sheet chi tiết đơn hàng: đồ gửi kèm (số lượng) & dịch vụ giặt
  void _showOrderDetailSheet(ShipperOrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.08),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.receipt_long, color: primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Chi tiết đơn #${order.id}',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thông tin khách
                    Row(
                      children: [
                        const Icon(Icons.person, size: 18, color: primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          order.customerName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          order.customerPhone,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: outlineColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Địa chỉ
                    Text(
                      order.type == OrderType.pickup ? 'Điểm lấy hàng:' : 'Điểm giao hàng:',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: outlineColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      order.type == OrderType.pickup ? order.pickupAddress : order.deliveryAddress,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Bảng đồ gửi kèm
                    Row(
                      children: [
                        const Icon(Icons.checklist_rounded, size: 18, color: secondaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'ĐỒ GỬI KÈM (${order.items.length} loại - ${order.weightKg} kg)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: secondaryColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    if (order.items.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: surfaceLow,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          'Chưa có thông tin đồ gửi kèm.',
                          style: GoogleFonts.plusJakartaSans(fontSize: 12, color: outlineColor),
                        ),
                      )
                    else ...[
                      // Header bảng
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: secondaryColor.withOpacity(0.1),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text('LOẠI ĐỒ', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: secondaryColor)),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text('DỊCH VỤ GIẶT', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: secondaryColor)),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text('KG', textAlign: TextAlign.right, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: secondaryColor)),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text('TRẠNG THÁI', textAlign: TextAlign.right, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: secondaryColor)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: secondaryColor.withOpacity(0.2)),
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                        ),
                        child: Column(
                          children: List.generate(order.items.length, (i) {
                            final item = order.items[i];
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: i.isEven ? Colors.white : surfaceLow.withOpacity(0.5),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      item['type'].toString(),
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: onSurface,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      item['service'].toString(),
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: outlineColor,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${item['kg']} kg',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: _getItemStatusColor(item['status'].toString()).withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          item['status'].toString(),
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: _getItemStatusColor(item['status'].toString()),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),

                    // Tổng quan dịch vụ & khối lượng
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: surfaceLow,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow(Icons.local_laundry_service, 'Gói dịch vụ:', order.serviceDetails),
                          const SizedBox(height: 8),
                          _buildDetailRow(Icons.scale, 'Tổng khối lượng:', '${order.weightKg} kg'),
                          const SizedBox(height: 8),
                          _buildDetailRow(Icons.schedule, 'Thời gian:', order.timeWindow),
                          const SizedBox(height: 8),
                          _buildDetailRow(
                            order.isPaidOnline ? Icons.verified_user : Icons.payments,
                            'Thanh toán:',
                            order.isPaidOnline ? 'Đã thanh toán Online' : 'COD: ${order.codAmount.toStringAsFixed(0)} đ',
                          ),
                          if (order.customerNote.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            _buildDetailRow(Icons.chat_bubble_outline, 'Ghi chú:', order.customerNote),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Nút hành động chính
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleOrderMainAction(order);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getActionButtonColor(order),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    _getActionButtonText(order),
                    style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Màu badge trạng thái của từng loại đồ trong chi tiết đơn
  Color _getItemStatusColor(String status) {
    switch (status) {
      case 'Đã xác nhận':
        return const Color(0xFF0284C7);
      case 'Đang giặt':
        return const Color(0xFFD97706);
      case 'Đang sấy':
        return secondaryColor;
      case 'Đang ủi':
        return const Color(0xFF7C3AED);
      case 'Hoàn tất':
        return successColor;
      default:
        return outlineColor;
    }
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: outlineColor),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(fontSize: 12, color: outlineColor, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: onSurface),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox, size: 56, color: outlineColor.withOpacity(0.5)),
          const SizedBox(height: 12),
          Text(
            'Không tìm thấy đơn hàng phù hợp',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Vui lòng thử đổi bộ lọc hoặc kéo xuống để làm mới.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: outlineColor,
            ),
          ),
        ],
      ),
    );
  }

  // --- LOGIC HELPERS & DIALOGS ---

  Color _getActionButtonColor(ShipperOrderModel order) {
    switch (order.status) {
      case ShipperOrderStatus.available:
        return primaryColor;
      case ShipperOrderStatus.pickingUp:
        return tertiaryColor;
      case ShipperOrderStatus.delivering:
        return successColor;
      case ShipperOrderStatus.completed:
        return outlineColor;
      default:
        return primaryColor;
    }
  }

  String _getActionButtonText(ShipperOrderModel order) {
    if (order.type == OrderType.pickup) {
      switch (order.status) {
        case ShipperOrderStatus.available:
          return 'Nhận đơn lấy hàng';
        case ShipperOrderStatus.pickingUp:
          return 'Đã lấy đồ từ khách';
        case ShipperOrderStatus.inStore:
          return 'Đã về tiệm giặt';
        case ShipperOrderStatus.completed:
          return 'Đã hoàn thành';
        default:
          return 'Cập nhật';
      }
    } else {
      switch (order.status) {
        case ShipperOrderStatus.available:
          return 'Nhận đơn giao hàng';
        case ShipperOrderStatus.delivering:
          return 'Xác nhận đã giao';
        case ShipperOrderStatus.completed:
          return 'Đã hoàn thành';
        default:
          return 'Cập nhật';
      }
    }
  }

  void _handleOrderMainAction(ShipperOrderModel order) {
    if (order.type == OrderType.pickup) {
      if (order.status == ShipperOrderStatus.available) {
        _updateOrderStatus(order, ShipperOrderStatus.pickingUp);
      } else if (order.status == ShipperOrderStatus.pickingUp) {
        _showProofPhotoDialog(order, isPickup: true);
      }
    } else {
      if (order.status == ShipperOrderStatus.available) {
        _updateOrderStatus(order, ShipperOrderStatus.delivering);
      } else if (order.status == ShipperOrderStatus.delivering) {
        _showProofPhotoDialog(order, isPickup: false);
      }
    }
  }

  void _simulateCallCustomer(ShipperOrderModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.phone_in_talk, color: primaryColor),
            const SizedBox(width: 10),
            Text(
              'Gọi cho khách hàng',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.customerName,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              order.customerPhone,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: surfaceLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Ghi chú: ${order.customerNote.isEmpty ? 'Không có' : order.customerNote}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: outlineColor,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng', style: GoogleFonts.plusJakartaSans(color: outlineColor)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _showToast('Đang kết nối cuộc gọi tới ${order.customerPhone}...');
            },
            icon: const Icon(Icons.call, color: Colors.white, size: 18),
            label: Text('Gọi ngay', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: successColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  void _showNavigationModal(ShipperOrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.map, color: tertiaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'Lộ trình di chuyển (${order.distanceKm} km)',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: onSurface,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Map Mock Canvas
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=600&auto=format&fit=crop',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Dự kiến 8 phút',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.navigation, color: Colors.white, size: 28),
                        const SizedBox(width: 8),
                        Text(
                          'Mô phỏng bản đồ dẫn đường GPS',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Địa chỉ cần tới:',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: outlineColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              order.type == OrderType.pickup ? order.pickupAddress : order.deliveryAddress,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: onSurface,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _showToast('Đang mở ứng dụng Google Maps...');
                },
                icon: const Icon(Icons.near_me, color: Colors.white),
                label: Text(
                  'Mở Google Maps chỉ đường',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: tertiaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProofPhotoDialog(ShipperOrderModel order, {required bool isPickup}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.camera_alt, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      isPickup ? 'Chụp ảnh túi đồ niêm phong' : 'Chụp ảnh giao hàng thành công',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: onSurface,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: surfaceLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryColor.withOpacity(0.3), style: BorderStyle.solid),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_a_photo_outlined, size: 42, color: primaryColor),
                  const SizedBox(height: 8),
                  Text(
                    'Nhấn để chụp ảnh minh chứng',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  Text(
                    isPickup ? '(Hình ảnh túi quần áo có dán mã seal 3T)' : '(Hình ảnh khách nhận túi giặt sạch)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: outlineColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (!isPickup && !order.isPaidOnline && order.codAmount > 0) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.payments, color: Color(0xFFD97706)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Số tiền COD cần thu mặt:',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: const Color(0xFF92400E),
                            ),
                          ),
                          Text(
                            '${order.codAmount.toStringAsFixed(0)} đ',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF92400E),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.check_box_outlined, color: Color(0xFFD97706)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _updateOrderStatus(order, ShipperOrderStatus.completed);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: successColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  isPickup ? 'Xác nhận đã nhận đồ & Niêm phong' : 'Xác nhận đã giao & Thu tiền',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showShipperWalletDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.account_balance_wallet, color: primaryColor),
            const SizedBox(width: 10),
            Text(
              'Ví Shipper 3T',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWalletRow('Thu nhập KPI:', '${kpiEarnings.toStringAsFixed(0)} đ'),
            const SizedBox(height: 8),
            _buildWalletRow('Lương cứng:', '${_baseSalary.toStringAsFixed(0)} đ'),
            const SizedBox(height: 8),
            _buildWalletRow('Số đơn đã xong:', '$_todayCompletedCount đơn'),
            const SizedBox(height: 8),
            _buildWalletRow('Phí vi phạm:', '- ${_violationFee.toStringAsFixed(0)} đ'),
            const Divider(height: 20),
            _buildWalletRow('Tổng thu nhập:', '${totalIncome.toStringAsFixed(0)} đ'),
            const SizedBox(height: 8)
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng', style: GoogleFonts.plusJakartaSans(color: primaryColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: outlineColor)),
        Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold, color: onSurface)),
      ],
    );
  }
}
