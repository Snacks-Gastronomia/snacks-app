import 'package:flutter/material.dart';

import 'package:snacks_app/core/app.text.dart';

class PaymentFailedContent extends StatelessWidget {
  const PaymentFailedContent({
    Key? key,
    required this.value,
    this.readError = false,
  }) : super(key: key);
  final String value;
  final bool readError;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        children: [
          Text('Não foi possível realizar o pagamento!',
              style: AppTextStyles.semiBold(26, color: Colors.black)),
          const SizedBox(
            height: 10,
          ),
          Text(
              readError
                  ? 'Não foi possível identificar o cartão snacks!'
                  : 'Seu cartão snacks não tem saldo suficiente! '
                      'Realize uma recarga ou escolha outra opção de pagamento. : -)',
              style: AppTextStyles.light(14, color: const Color(0xffBE0101))),
          const SizedBox(
            height: 30,
          ),
          if (!readError)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade200),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Saldo',
                      style: AppTextStyles.regular(16, color: Colors.black)),
                  Text(value,
                      style: AppTextStyles.regular(16, color: Colors.black)),
                ],
              ),
            ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                primary: Colors.black,
                fixedSize: const Size(double.maxFinite, 59)),
            child: Text(
              'Voltar para o pagamento',
              style: AppTextStyles.regular(16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
