import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/utils/corner_border.dart';
import 'package:snacks_app/utils/modal.dart';
import 'package:snacks_app/views/home/widgets/modals/content_payment_failed.dart';

class ScanCardScreen extends StatefulWidget {
  const ScanCardScreen({Key? key}) : super(key: key);

  @override
  State<ScanCardScreen> createState() => _ScanCardScreenState();
}

class _ScanCardScreenState extends State<ScanCardScreen> {
  late MobileScannerController controller;
  final modal = AppModal();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

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
          preferredSize: const Size.fromHeight(60.0),
          child: Container(
            padding: const EdgeInsets.only(top: 15),
            color: Colors.black.withOpacity(.9),
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
                        backgroundColor: Colors.white,
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
        ),
        backgroundColor: Colors.white,
        body: Container(
          width: double.maxFinite,
          color: Colors.black.withOpacity(.9),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Leia o qr code presente no cartão',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.semiBold(25,
                      color: Colors.white.withOpacity(0.5)),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  // height: MediaQuery.of(context).size.height * 0.70,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.68,
                    maxWidth: MediaQuery.of(context).size.width * 0.88,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/snacks_logo.svg",
                        width: 90,
                        color: Colors.white,
                      ),
                      Center(child: buildQrView(context))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildQrView(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 300,
          width: 300,
          child: Center(
            child: SizedBox(
                height: 250,
                width: 250,
                child: MobileScanner(
                    allowDuplicates: false,
                    controller: controller,
                    onDetect: (barcode, args) async {
                      if (barcode.rawValue == null) {
                        debugPrint('Failed to scan Barcode');
                        modal.showModalBottomSheet(
                            context: context,
                            content: const PaymentFailedContent(
                              readError: true,
                              value: "",
                            ));
                      } else {
                        final String card_code = barcode.rawValue!;
                        Navigator.pop(context, card_code);
                      }
                    })),
          ),
        ),
        SizedBox(
          height: 285,
          width: 300,
          child: CustomPaint(
            painter: MyCustomPainter(
                padding: 15, frameSFactor: .1, color: Colors.white, stroke: 6),
            // child: Container(),
          ),
        ),
      ],
    );
  }
}
