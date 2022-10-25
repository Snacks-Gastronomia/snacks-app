import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:snacks_app/core/app.routes.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/services/firebase/custom_token_auth.dart';
import 'package:snacks_app/utils/corner_border.dart';

class ScanQrCodeScreen extends StatefulWidget {
  const ScanQrCodeScreen({Key? key}) : super(key: key);

  @override
  State<ScanQrCodeScreen> createState() => _ScanQrCodeScreenState();
}

class _ScanQrCodeScreenState extends State<ScanQrCodeScreen> {
  // Barcode? result;

  late MobileScannerController controller;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {}
  //   // controller!.stop();
  //   // controller!.d();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = MobileScannerController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      primary: Colors.white,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(41, 41)),
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.black,
                    size: 19,
                  )),
            ],
          ),
        ),
        // AppBar(
        //   elevation: 0,
        //   leading: ElevatedButton(
        //       onPressed: () {},
        //       style: ElevatedButton.styleFrom(
        //           padding: EdgeInsets.zero,
        //           primary: Colors.white,
        //           fixedSize: const Size(41, 41)),
        //       child: const Icon(
        //         Icons.arrow_back_ios_rounded,
        //         color: Colors.black,
        //       )),
        // ),
        backgroundColor: Colors.black,
        body: Padding(
          padding:
              const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.qr_code_scanner_rounded,
                      size: 40, color: Colors.white.withOpacity(0.5)),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      'Escaneie o qrcode na mesa!',
                      style: AppTextStyles.semiBold(30,
                          color: Colors.white.withOpacity(0.5)),
                    ),
                  ),
                ],
              ),
              // Container(
              //   width: 300,
              //   height: 300,
              //   margin: const EdgeInsets.only(bottom: 50),
              //   // color: Colors.white24,
              //   child:
              // ),
              buildQrView(context),
              const SizedBox(height: 35),
              SizedBox(
                height: 60,
                child: SvgPicture.asset(
                  "assets/icons/snacks.svg",
                  color: Colors.white.withOpacity(.20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQrView(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 350,
          width: 350,
          child: Center(
            child: SizedBox(
                height: 300,
                width: 300,
                child: MobileScanner(
                    allowDuplicates: false,
                    controller: controller,
                    onDetect: (barcode, args) async {
                      if (barcode.rawValue == null) {
                        debugPrint('Failed to scan Barcode');
                      } else {
                        final String code = barcode.rawValue!;

                        debugPrint('Barcode found! $code');
                        Navigator.pop(context, code);
                      }
                    })),
          ),
        ),
        SizedBox(
          height: 350,
          width: 350,
          child: CustomPaint(
            painter: MyCustomPainter(
                padding: 20, frameSFactor: .1, color: Colors.white, stroke: 6),
            // child: Container(),
          ),
        ),
      ],
    );
  }

//**

// */
  //   QRView(
  //       key: qrKey,
  //       onQRViewCreated: (QRViewController qrViewController) {
  //         setState(() => controller = qrViewController);

  //         qrViewController.scannedDataStream.listen((barcode) async {});
  //       },
  //       // overlayMargin: const EdgeInsets.all(10),

  //       overlay: QrScannerOverlayShape(
  //           overlayColor: Colors.black,
  //           borderRadius: 10,
  //           borderColor: Colors.white,
  //           borderLength: 30,
  //           borderWidth: 15,
  //           cutOutSize: MediaQuery.of(context).size.width * 0.85));
  // }
}
