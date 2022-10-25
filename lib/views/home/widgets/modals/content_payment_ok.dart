import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snacks_app/core/app.images.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/utils/modal.dart';
import 'package:snacks_app/views/success/success_screen.dart';

class PaymentSuccessContent extends StatelessWidget {
  const PaymentSuccessContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        children: [
          Text('Pagamento realizado com sucesso!',
              style: AppTextStyles.semiBold(26, color: Colors.black)),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Número do pedido',
                          style:
                              AppTextStyles.medium(16, color: Colors.black38),
                        ),
                        Text('#0002',
                            style: AppTextStyles.medium(20,
                                color: Colors.black87)),
                      ]),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Valor do pedido',
                          style:
                              AppTextStyles.medium(16, color: Colors.black38)),
                      Text(r'R$ 75,00',
                          style:
                              AppTextStyles.medium(20, color: Colors.black87)),
                    ],
                  )
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              const MiniSnacksCard()
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AppModal().showIOSModalBottomSheet(
                  context: context,
                  drag: false,
                  content: const SuccessScreen(
                    title: "Pedido realizado!",
                    backButton: true,
                    description:
                        'Aguarde que você receberá uma notificação de quando estiver pronto! :-)',
                  ));
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                primary: Colors.black,
                fixedSize: const Size(double.maxFinite, 59)),
            child: Text(
              'Ok',
              style: AppTextStyles.regular(16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class MiniSnacksCard extends StatelessWidget {
  const MiniSnacksCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 190,
        width: 150,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              AppImages.snacks_logo,
              width: 50,
              color: Colors.white,
            ),
            const Spacer(),
            Text(
              'Saldo restante',
              style: AppTextStyles.medium(10, color: Colors.white60),
            ),
            const SizedBox(height: 3),
            Text(
              r'R$ 25,00',
              style: AppTextStyles.medium(20, color: Colors.white70),
            ),
          ],
        ));
  }
}
