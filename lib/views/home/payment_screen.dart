import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snacks_app/core/app.images.dart';
import 'package:snacks_app/core/app.routes.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/utils/modal.dart';
import 'package:snacks_app/views/success/success_screen.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  void action(context) {
    AppModal().showIOSModalBottomSheet(
        context: context,
        drag: false,
        content: const SuccessScreen(
          title: "Pedido realizado!",
          backButton: true,
          description:
              'Em breve o garçom será direcionado até sua mesa para finalizar o pagamento. :-)',
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        // bottomNavigationBar: Padding(
        //   padding: const EdgeInsets.only(left: 25, right: 25, bottom: 30),
        //   child: ElevatedButton(
        //     onPressed: () {},
        //     style: ElevatedButton.styleFrom(
        //         shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(15)),
        //         primary: Colors.black,
        //         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        //         fixedSize: const Size(double.maxFinite, 59)),
        //     child: Text(
        //       'Continuar',
        //       style: AppTextStyles.regular(16, color: Colors.white),
        //     ),
        //   ),
        // ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Container(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: Row(
              children: [
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        primary: const Color(0xffF6F6F6),
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
        body: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pagamento',
                  style: AppTextStyles.medium(20),
                ),
                const SizedBox(
                  height: 10,
                  // height: 41,
                ),
                Text(
                  'Escolha o melhor metodo de pagamento para voce. ;-)',
                  style:
                      AppTextStyles.medium(16, color: const Color(0xff8391A1)),
                ),
                const SizedBox(
                  height: 40,
                  // height: 41,
                ),
                GestureDetector(
                  onTap: () => action(context),
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xffF7F8F9),
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.credit_card_rounded),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Cartão de crédito/débito'),
                          ],
                        ),
                        const Icon(Icons.arrow_forward)
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () => action(context),
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xffF7F8F9),
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.credit_card_rounded),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Pix'),
                          ],
                        ),
                        const Icon(Icons.arrow_forward)
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.scanCard),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              AppImages.snacks_logo,
                              color: Colors.white,
                              width: 30,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Cartão snacks',
                              style:
                                  AppTextStyles.medium(14, color: Colors.white),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
