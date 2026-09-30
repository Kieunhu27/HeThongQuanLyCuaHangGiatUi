import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class VietQRPaymentScreen extends StatefulWidget {
  const VietQRPaymentScreen({super.key});

  @override
  State<VietQRPaymentScreen> createState() => _VietQRPaymentScreenState();
}

class _VietQRPaymentScreenState extends State<VietQRPaymentScreen>
    with SingleTickerProviderStateMixin {
  // Brand Color Tokens WashSmart 3T
  static const Color primaryColor = Color(0xFFB90538);
  static const Color secondaryColor = Color(0xFFB4136D);
  static const Color tertiaryColor = Color(0xFF006577);
  static const Color bgSurface = Color(0xFFFFF8F7);
  static const Color cardBg = Colors.white;
  static const Color surfaceLow = Color(0xFFFFF0F0);
  static const Color surfaceHigh = Color(0xFFFFE1E3);
  static const Color onSurface = Color(0xFF370C14);
  static const Color outlineColor = Color(0xFF8F6F71);

  // Countdown Timer Logic (14 phút 58 giây)
  late Timer _timer;
  int _startSeconds = 14 * 60 + 58;

  // Animation controller cho tia quét QR
  late AnimationController _scanAnimationController;

  @override
  void initState() {
    super.initState();
    _startTimer();

    _scanAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startSeconds == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _startSeconds--;
        });
      }
    });
  }

  String get _formattedTime {
    int minutes = _startSeconds ~/ 60;
    int seconds = _startSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    _showToast('Đã sao chép $label vào bộ nhớ tạm!');
  }

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
  void dispose() {
    _timer.cancel();
    _scanAnimationController.dispose();
    super.dispose();
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
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: surfaceLow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.local_laundry_service,
                color: primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WASHSMART 3T',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  'Vietqr Payment',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          CircleAvatar(
            radius: 16,
            backgroundColor: primaryColor,
            child: const Icon(Icons.person, color: Colors.white, size: 18),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: onSurface, size: 22),
            onPressed: () => Navigator.maybePop(context),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            // 1. HEADER MÃ ĐƠN & TỔNG TIỀN
            _buildAmountHeader(),
            const SizedBox(height: 14),

            // 2. KHUNG MÃ VIETQR TRUNG TÂM
            _buildQRCodeCard(),
            const SizedBox(height: 14),

            // 3. THÔNG TIN CHUYỂN KHOẢN CHI TIẾT
            _buildTransferDetailsCard(),
            const SizedBox(height: 14),

            // 4. THÔNG BÁO TỰ ĐỘNG NHẬN DIỆN THANH TOÁN
            _buildAutoDetectionCard(),
            const SizedBox(height: 20),

            // 5. NÚT ĐỔI PHƯƠNG THỨC & TỔNG ĐÀI HỖ TRỢ
            _buildBottomActions(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // --- 1. AMOUNT & ORDER CODE HEADER ---
  Widget _buildAmountHeader() {
    return Column(
      children: [
        InkWell(
          onTap: () => _copyToClipboard('WS3T-8892', 'Mã đơn #WS3T-8892'),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: surfaceHigh,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Mã đơn: ',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: outlineColor,
                  ),
                ),
                Text(
                  '#WS3T-8892',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.content_copy, size: 14, color: primaryColor),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '145.000',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              'đ',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ],
        ),
        Text(
          'Giặt sấy 5.0kg & Ủi hơi nước tinh tươm',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: outlineColor,
          ),
        ),
      ],
    );
  }

  // --- 2. QR CODE CARD ---
  Widget _buildQRCodeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header VietQR Napas 247 & Timer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'VietQR',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: secondaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                    'NAPAS 247',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: tertiaryColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: surfaceHigh,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.hourglass_top, size: 14, color: primaryColor),
                    const SizedBox(width: 4),
                    Text(
                      _formattedTime,
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

          // Mã VietQR chuẩn tương tác
          Container(
            width: 240,
            height: 240,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: surfaceHigh, width: 1.5),
            ),
            child: Stack(
              children: [
                // 4 Góc khung định vị Rose Pink
                Positioned(top: 0, left: 0, child: _buildCorner(top: true, left: true)),
                Positioned(top: 0, right: 0, child: _buildCorner(top: true, left: false)),
                Positioned(bottom: 0, left: 0, child: _buildCorner(top: false, left: true)),
                Positioned(bottom: 0, right: 0, child: _buildCorner(top: false, left: false)),

                // Mã QR Giả lập chính xác theo thiết kế WashSmart 3T
                Center(
                  child: CustomPaint(
                    size: const Size(200, 200),
                    painter: QRPainter(),
                  ),
                ),

                // Logo Biểu tượng 3T ở tâm QR
                Center(
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: Center(
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '3T',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Tia quét Laser chạy qua chạy lại
                AnimatedBuilder(
                  animation: _scanAnimationController,
                  builder: (context, child) {
                    return Positioned(
                      top: _scanAnimationController.value * 200,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              primaryColor.withOpacity(0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Nút Lưu ảnh QR
          TextButton.icon(
            onPressed: () => _showToast('Đã lưu ảnh mã VietQR vào thư viện ảnh!'),
            icon: const Icon(Icons.download, size: 16, color: primaryColor),
            label: Text(
              'Lưu ảnh QR về máy',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner({required bool top, required bool left}) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        border: Border(
          top: top ? const BorderSide(color: primaryColor, width: 3) : BorderSide.none,
          bottom: !top ? const BorderSide(color: primaryColor, width: 3) : BorderSide.none,
          left: left ? const BorderSide(color: primaryColor, width: 3) : BorderSide.none,
          right: !left ? const BorderSide(color: primaryColor, width: 3) : BorderSide.none,
        ),
      ),
    );
  }

  // --- 3. TRANSFER DETAILS CARD ---
  Widget _buildTransferDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Dòng Ngân hàng
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ngân hàng',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: outlineColor),
              ),
              Text(
                'MBBank',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: onSurface,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, color: surfaceLow),
          ),

          // Dòng Số tài khoản + Sao chép
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Số tài khoản',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: outlineColor),
                  ),
                  Text(
                    '0888 333 8892',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: onSurface,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _copyToClipboard('08883338892', 'Số tài khoản'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: surfaceHigh,
                  foregroundColor: primaryColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: Text(
                  'Sao chép',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                label: const Icon(Icons.content_copy, size: 14),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, color: surfaceLow),
          ),

          // Dòng Nội dung chuyển khoản + Nút Nổi bật
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nội dung chuyển khoản',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: outlineColor),
                  ),
                  Text(
                    'WS3T 8892',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _copyToClipboard('WS3T 8892', 'Nội dung chuyển khoản'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: Text(
                  'Sao chép',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                label: const Icon(Icons.content_copy, size: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 4. AUTO DETECTION CARD ---
  Widget _buildAutoDetectionCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: surfaceHigh,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.autorenew,
              color: primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đang tự động nhận diện thanh toán...',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                Text(
                  'Hệ thống sẽ tự chuyển trang ngay khi nhận được tiền',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: outlineColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 5. BOTTOM ACTIONS ---
  Widget _buildBottomActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: TextButton.icon(
            onPressed: () => _showToast('Đang mở danh sách phương thức thanh toán khác...'),
            style: TextButton.styleFrom(
              backgroundColor: surfaceHigh,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            icon: const Icon(Icons.arrow_back, color: primaryColor, size: 18),
            label: Text(
              'Đổi phương thức thanh toán',
              style: GoogleFonts.plusJakartaSans(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _showToast('Đang gọi tổng đài CSKH 1900 3388...'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.support_agent, size: 14, color: outlineColor),
              const SizedBox(width: 4),
              Text(
                'Hỗ trợ 24/7: 1900 3388 (Miễn phí)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: outlineColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// CUSTOM PAINTER VẼ MÃ QR DẠNG MATRIX CHUẨN ĐẸP
class QRPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintDark = Paint()..color = const Color(0xFF370C14);
    final paintPrimary = Paint()..color = const Color(0xFFB90538);

    double block = size.width / 21;

    // 3 Góc định vị QR chính (Finder Patterns)
    _drawFinder(canvas, 0, 0, block, paintDark, paintPrimary);
    _drawFinder(canvas, 14 * block, 0, block, paintDark, paintPrimary);
    _drawFinder(canvas, 0, 14 * block, block, paintDark, paintPrimary);

    // Vẽ ngẫu nhiên các điểm ma trận QR
    final matrix = [
      [7, 2], [8, 2], [10, 2], [12, 2],
      [7, 4], [9, 4], [11, 4], [13, 4],
      [2, 7], [4, 7], [8, 7], [10, 7], [12, 7], [16, 7], [18, 7],
      [3, 9], [5, 9], [7, 9], [11, 9], [15, 9], [17, 9],
      [1, 11], [6, 11], [8, 11], [10, 11], [14, 11], [19, 11],
      [3, 13], [7, 13], [9, 13], [13, 13], [17, 13],
      [8, 15], [10, 15], [12, 15], [16, 15], [18, 15],
      [7, 17], [9, 17], [11, 17], [15, 17], [19, 17],
      [8, 19], [12, 19], [14, 19], [16, 19], [18, 19]
    ];

    for (var pos in matrix) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(pos[0] * block, pos[1] * block, block * 1.6, block * 1.6),
          const Radius.circular(2),
        ),
        paintDark,
      );
    }
  }

  void _drawFinder(Canvas canvas, double x, double y, double block, Paint dark, Paint primary) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, 7 * block, 7 * block),
        const Radius.circular(8),
      ),
      dark,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + block, y + block, 5 * block, 5 * block),
        const Radius.circular(5),
      ),
      Paint()..color = Colors.white,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + 2 * block, y + 2 * block, 3 * block, 3 * block),
        const Radius.circular(3),
      ),
      primary,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}