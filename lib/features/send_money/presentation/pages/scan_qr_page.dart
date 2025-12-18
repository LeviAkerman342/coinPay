import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';

class ScanQrPage extends StatefulWidget {
  const ScanQrPage({super.key});

  @override
  State<ScanQrPage> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 32),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              controller.torchEnabled ? Icons.flash_off : Icons.flash_on,
              color: Colors.white,
              size: 32,
            ),
            onPressed: () => controller.switchCamera(),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          // Камера
          MobileScanner(
            controller: controller,
            onDetect: (BarcodeCapture capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;
                if (code != null && code.isNotEmpty) {
                  // Предполагаем, что QR содержит ID или phone получателя
                  debugPrint('QR Code detected: $code');

                  // Здесь можно распарсить код и сразу перейти к сумме
                  // Для примера — возвращаемся назад и заполняем получателя
                  context.pop();

                  // Если у тебя есть Cubit на предыдущем экране — можно передать данные
                  // Или просто показать snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('QR отсканирован: $code')),
                  );

                  // Если хочешь автоматически перейти к вводу суммы:
                  // context.read<SendMoneyCubit>().selectRecipientFromQr(code);

                  break;
                }
              }
            },
          ),

          // Затемнение вокруг рамки
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 4),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),

          // Угловые акценты (опционально, для красоты)
          _buildCornerOverlay(Alignment.topLeft),
          _buildCornerOverlay(Alignment.topRight),
          _buildCornerOverlay(Alignment.bottomLeft),
          _buildCornerOverlay(Alignment.bottomRight),

          // Текст снизу
          Positioned(
            bottom: 100,
            left: 40,
            right: 40,
            child: Column(
              children: const [
                Text(
                  'Scan a QR to Pay',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Hold the code in the frame, it will be scanned automatically',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCornerOverlay(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border(
            top:
                alignment == Alignment.topLeft ||
                    alignment == Alignment.topRight
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
            left:
                alignment == Alignment.topLeft ||
                    alignment == Alignment.bottomLeft
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
            right:
                alignment == Alignment.topRight ||
                    alignment == Alignment.bottomRight
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
            bottom:
                alignment == Alignment.bottomLeft ||
                    alignment == Alignment.bottomRight
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
