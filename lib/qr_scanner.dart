import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:absensi_mobile_apps/result_scanner.dart';

const bgColor = Color(0xfffafafa);
String? kodeBarcode;

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  bool isScanCompleted = false;
  bool isFlashon = false;
  bool isFontCamera = false;
  MobileScannerController controller = MobileScannerController();

  void closeScreen() {
    isScanCompleted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isFlashon = !isFlashon;
                });
                controller.toggleTorch();
              },
              icon: Icon(Icons.flash_on,
                  color: isFlashon ? Colors.black : Colors.white)),
        ],
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
        title: const Text(
          "QR Scanner",
          style: TextStyle(
            color: Colors.white,
            // fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        // padding: const EdgeInsets.all(20),
        padding:
            const EdgeInsets.only(top: 50, left: 15, right: 15, bottom: 50),
        child: Column(
          children: [
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Place the QR code in the area",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Scanning will be started automatically",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    MobileScanner(
                        controller: controller,
                        allowDuplicates: true,
                        onDetect: (barcode, args) {
                          if (!isScanCompleted) {
                            kodeBarcode = barcode.rawValue ?? '----';
                            isScanCompleted = true;
                            Get.to(() => ResultScanner(
                                  closeScreen: closeScreen,
                                  code: kodeBarcode.toString(),
                                ));
                          }
                        }),
                  ],
                )),
            // Expanded(
            Container(
              alignment: Alignment.center,
              child: const Text(
                "",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
            )
            // ),
          ],
        ),
      ),
    );
  }
}
