import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';

import '../../../utils/constants/app_assets.dart';
import '../../../utils/theme/constants/app_colors.dart';

class QrCodeScreen extends StatefulWidget {
  static const route = '/qr';

  const QrCodeScreen({super.key});

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  String? qrCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          MobileScanner(
            fit: BoxFit.cover,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                setState(() {
                  qrCode = barcode.rawValue ?? "Unknown";
                });
              }
            },
          ),
          Positioned.fill(
            child: ScannerOverlay(),
          ),

          if (qrCode != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black54,
                child: Text(
                  "Scanned: $qrCode",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

}
class ScannerOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth * 0.7; // scan box width
      final height = width; // square
      final left = (constraints.maxWidth - width) / 2;
      final top = (constraints.maxHeight - height) / 2;

      return Stack(
        children: [
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: HolePainter(
                  holeRect: Rect.fromLTWH(left, top, width, height),
                ),
              ),
            ),
          ),
          Positioned(
            left: 10,
            top: 30,
            child: CustomAppBar(),
          ),


          Positioned(
            left: left,
            top: top,
            width: width,
            height: height,
            child: SvgPicture.asset(AppAssets.crossHairIcon),
          ),
        ],
      );
    });
  }
}

class HolePainter extends CustomPainter {
  final Rect holeRect;
  final double borderRadius;

  HolePainter({required this.holeRect, this.borderRadius = 40});

  @override
  void paint(Canvas canvas, Size size) {
    // Dark background
    final backgroundPaint = Paint()
      ..color = AppColors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, backgroundPaint);

    // Transparent rounded hole
    final holePaint = Paint()
      ..blendMode = BlendMode.clear;

    final rrect = RRect.fromRectAndRadius(holeRect, Radius.circular(borderRadius));
    canvas.drawRRect(rrect, holePaint);

    // Glowing border around the hole
    final borderPaint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 6);

    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}