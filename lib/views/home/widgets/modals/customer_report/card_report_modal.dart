import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:snacks_app/components/custom_submit_button.dart';

import 'package:snacks_app/core/app.images.dart';
import 'package:snacks_app/core/app.routes.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/utils/enums.dart';
import 'package:snacks_app/utils/modal.dart';
import 'package:snacks_app/views/home/state/card_state/card_cubit.dart';
import 'package:snacks_app/views/home/widgets/modals/customer_report/report_screen.dart';

class CardDetailsModal extends StatelessWidget {
  const CardDetailsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Cartão snacks',
                style: AppTextStyles.semiBold(28),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Escaneie o cartão para ver o saldo disponível e o extrato de consumo.',
              style: AppTextStyles.light(14),
            ),
            const SizedBox(
              height: 15,
            ),
            // BlocBuilder<CardCubit, CardState>(
            //   builder: (context, state) {
            //     return CardWidget(
            //         name: state.nome,
            //         value: state.value,
            //         hasData: state.hasData,
            //         loading: state.status == AppStatus.loading,
            //         onTap: () async {
            //           var cubit = context.read<CardCubit>();
            //           await Navigator.pushNamed(context, AppRoutes.scanCard)
            //               .then((code) async =>
            //                   await cubit.readCard(code, context));
            //         });
            //   },
            // ),
            const SizedBox(
              height: 15,
            ),

            BlocBuilder<CardCubit, CardState>(
              builder: (context, state) {
                return CustomSubmitButton(
                    onPressedAction: () async {
                      var nav = Navigator.of(context);
                      var cubit = context.read<CardCubit>();
                      await Navigator.pushNamed(context, AppRoutes.scanCard)
                          .then((code) async =>
                              await cubit.readCard(code, context).then((value) {
                                nav.pop();
                                AppModal().showIOSModalBottomSheet(
                                  drag: false,
                                  context: context,
                                  content: const CustomerReportScreen(),
                                );
                              }));
                    },
                    label: "Ler cartão",
                    loading_label: "Escaneando",
                    loading: state.status == AppStatus.loading);
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<CardCubit>().clear();
              },
              child: Text(
                'Fechar',
                style: AppTextStyles.regular(16, color: Colors.black),
              ),
            )
          ],
        ));
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({
    Key? key,
    required this.name,
    required this.value,
    required this.hasData,
    required this.loading,
    required this.onTap,
  }) : super(key: key);

  final String name;
  final double value;
  final bool hasData;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(20),
          height: 220,
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(15)),
          child: !loading
              ? !hasData
                  ? Center(
                      child: Text(
                        "Pressione para escaneiar",
                        style: AppTextStyles.medium(16, color: Colors.white54),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            SvgPicture.asset(
                              AppImages.snacks_logo,
                              height: 60,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              name,
                              style: AppTextStyles.regular(20,
                                  color: Colors.white70),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              NumberFormat.currency(
                                      locale: "pt", symbol: r"R$ ")
                                  .format(value),
                              style: AppTextStyles.light(18,
                                  color: Colors.white70),
                            ),
                          ],
                        )
                      ],
                    )
              : const Center(
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                )),
    );
  }
}
