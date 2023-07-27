import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:snacks_app/components/custom_submit_button.dart';
import 'package:snacks_app/core/app.images.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/views/home/state/card_state/card_cubit.dart';

class CustomerReportScreen extends StatelessWidget {
  const CustomerReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<CardCubit>(context);
    final state = cubit.state;
    return Column(
      children: [
        // BlocBuilder<CardCubit, CardState>(
        //   builder: (context, state) {
        CardWidget(
            name: state.nome,
            value: state.value,
            hasData: state.hasData,
            loading: false,
            onTap: () {}),
        //   },
        // ),

        const SizedBox(height: 20),
        Text(
          'Consumo',
          style: AppTextStyles.semiBold(18),
        ),

        const SizedBox(height: 10),
        ListView.builder(
          itemBuilder: (context, index) {
            // return Card(
            //   elevation: 0,
            //   child: ListTile(
            //     contentPadding: const EdgeInsets.all(8),
            //     title: Text(
            //       item.data()["restaurant_name"] + item.data()["part_code"],
            //       style: AppTextStyles.semiBold(16),
            //     ),
            //     isThreeLine: true,
            //     subtitle: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         ListView.builder(
            //             itemCount: (item.data()["orders"] as List).length,
            //             shrinkWrap: true,
            //             physics: const NeverScrollableScrollPhysics(),
            //             itemBuilder: (context, index) {
            //               var order = item.data()["orders"][index];
            //               List extras = order["extras"] ?? [];

            //               var extraDescription = "";

            //               for (var i = 0; i < extras.length; i++) {
            //                 var element = extras[i];
            //                 extraDescription += element["title"] +
            //                     '(${NumberFormat.currency(locale: "pt", symbol: r"R$").format(double.parse(element["value"].toString()))})';
            //               }

            //               var text = '${order["amount"]} ${order["name"]}';

            //               if (extraDescription.isNotEmpty) {
            //                 text += ' + $extraDescription';
            //               }

            //               return Text(
            //                 text,
            //                 style: AppTextStyles.light(14,
            //                     color: const Color(0xffB3B3B3)),
            //               );
            //             })
            //       ],
            //     ),
            //     trailing: Column(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       crossAxisAlignment: CrossAxisAlignment.end,
            //       children: [
            //         Text(
            //           NumberFormat.currency(locale: "pt", symbol: r"R$ ")
            //               .format(item.data()["total"]),
            //           style: AppTextStyles.semiBold(18,
            //               color: const Color(0xff00B907)),
            //         ),
            //         Text(
            //           item.data()["time"],
            //           style: AppTextStyles.light(14),
            //         ),
            //       ],
            //     ),
            //   ),
            // );
          },
        ),

        const Spacer(),

        CustomSubmitButton(
            onPressedAction: () => Navigator.pop(context),
            label: "Fechar",
            loading_label: "",
            loading: false)
      ],
    );
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
          child: Row(
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
                    style: AppTextStyles.regular(20, color: Colors.white70),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    NumberFormat.currency(locale: "pt", symbol: r"R$ ")
                        .format(value),
                    style: AppTextStyles.light(18, color: Colors.white70),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
