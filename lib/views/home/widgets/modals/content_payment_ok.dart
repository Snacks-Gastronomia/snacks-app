import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:snacks_app/core/app.images.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/utils/modal.dart';
import 'package:snacks_app/views/success/success_screen.dart';

class PaymentSuccessContent extends StatelessWidget {
  const PaymentSuccessContent({
    Key? key,
    required this.order_value,
    required this.rest_value,
    required this.customer,
    required this.action,
  }) : super(key: key);

  final String order_value;
  final String rest_value;
  final String customer;
  final VoidCallback action;

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
                          'Cliente',
                          style:
                              AppTextStyles.medium(16, color: Colors.black38),
                        ),
                        Text(customer,
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
                      Text(order_value,
                          style:
                              AppTextStyles.medium(20, color: Colors.black87)),
                    ],
                  )
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              MiniSnacksCard(
                value: rest_value,
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              action();
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
  const MiniSnacksCard({
    Key? key,
    required this.value,
  }) : super(key: key);

  final String value;

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
              value,
              style: AppTextStyles.medium(20, color: Colors.white70),
            ),
          ],
        ));
  }
}
