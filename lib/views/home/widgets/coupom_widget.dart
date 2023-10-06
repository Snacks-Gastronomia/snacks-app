import 'package:flutter/material.dart';
import 'package:snacks_app/core/app.colors.dart';
import 'package:snacks_app/utils/modal.dart';
import 'package:snacks_app/views/home/widgets/modals/coupom_code.dart';

class CoupomWidget extends StatelessWidget {
  const CoupomWidget(
      {super.key, required this.hasCoupom, required this.restaurantId});
  final bool hasCoupom;
  final String restaurantId;

  @override
  Widget build(BuildContext context) {
    if (hasCoupom) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.check,
            color: AppColors.highlight,
          ),
          const SizedBox(width: 15),
          Text(
            "Cupom adicionado",
            style: TextStyle(color: AppColors.highlight),
          )
        ],
      );
    } else {
      return TextButton(
          onPressed: () {
            AppModal().showModalBottomSheet(
                context: context,
                content: CoupomCode(
                  context: context,
                  restaurantId: restaurantId,
                ));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.local_offer_outlined),
              SizedBox(width: 15),
              Text(
                "Adicionar cupom de desconto",
              )
            ],
          ));
    }
  }
}
