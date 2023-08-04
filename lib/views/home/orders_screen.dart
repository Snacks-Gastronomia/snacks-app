import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:snacks_app/core/app.images.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/models/order_model.dart';
import 'package:snacks_app/models/order_reponse.dart';
import 'package:snacks_app/utils/enums.dart';
import 'package:snacks_app/views/home/state/cart_state/cart_cubit.dart';
import 'package:snacks_app/views/home/widgets/order_card.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Container(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Row(
                children: [
                  Text(
                    'Meus pedidos',
                    style: AppTextStyles.medium(20),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: context.read<CartCubit>().fetchOrders(),
                builder: (context, snapshot) {
                  if (snapshot.hasData ||
                      snapshot.connectionState == ConnectionState.done) {
                    List<OrderResponse> orders = (snapshot.data?.docs ?? [])
                        .map((e) => OrderResponse.fromFirebase(e))
                        .toList();

                    var groupedOrders = OrderResponse.groupOrdersByCode(orders);

                    return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: groupedOrders.length,
                        shrinkWrap: true,
                        itemBuilder: (_, index) {
                          var order = groupedOrders[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: OrderCardWidget(orders: order["orders"]),
                          );
                        });
                  }
                  return const Center(
                    child: SizedBox(
                        height: 60,
                        width: 60,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          backgroundColor: Colors.black12,
                        )),
                  );
                }),
          )),
    );
  }
}

class CardOrderWidget1 extends StatelessWidget {
  final bool isDelivery;
  final String? leading;
  final String status;
  final String address;
  final double total;
  final String method;
  final String order_code;
  final String customer_name;
  final String change;
  final String time;
  final List items;

  const CardOrderWidget1({
    Key? key,
    this.isDelivery = false,
    required this.leading,
    required this.address,
    required this.status,
    required this.total,
    required this.method,
    required this.time,
    required this.items,
    required this.customer_name,
    required this.change,
    required this.order_code,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        initialExpanded: true,
        child: Column(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              const Icon(
                Icons.person_2_outlined,
                color: Color(0xff278EFF),
                size: 14,
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                customer_name,
                style:
                    AppTextStyles.regular(12, color: const Color(0xff278EFF)),
              ),
            ],
          ),
          Card(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: const Color(0xffF6F6F6),
            // color: Color(0xffF6F6F6),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 15, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Row(children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 60,
                            child: leading == null
                                ? SvgPicture.asset(
                                    AppImages.snacks_logo,
                                    width: 50,
                                    color: const Color(0xff263238)
                                        .withOpacity(0.7),
                                  )
                                : Text(
                                    '$leading',
                                    style: AppTextStyles.bold(55,
                                        color: const Color(0xff263238)),
                                  ),
                          ),
                          Text(
                            "#$order_code",
                            style: AppTextStyles.semiBold(14,
                                color:
                                    const Color(0xff263238).withOpacity(0.5)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            method,
                            style: AppTextStyles.regular(16,
                                color: const Color(0xff979797)),
                          ),
                          Text(
                            NumberFormat.currency(locale: "pt", symbol: r"R$ ")
                                .format(total),
                            style: AppTextStyles.semiBold(16,
                                color: const Color(0xff979797)),
                          ),
                          if (change.isNotEmpty)
                            Text(
                              'Troco: $change',
                              style: AppTextStyles.semiBold(16,
                                  color: const Color(0xff979797)),
                            ),
                        ],
                      )
                      // ]),
                      // Text(
                      //   time,
                      //   style: AppTextStyles.light(14,
                      //       color: const Color(0xff979797)),
                      // ),
                    ],
                  ),
                ),
                if (isDelivery)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Container(
                      height: 70,
                      padding: const EdgeInsets.all(15),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade200),
                      child: Text(address),
                    ),
                  ),
                ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                      tapBodyToExpand: false,
                      hasIcon: false,
                    ),
                    header: Column(
                      children: [
                        const SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey,
                              size: 16,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Ver detalhes",
                              style: AppTextStyles.regular(12,
                                  color: Colors.grey.shade600),
                            ),
                          ],
                        )
                      ],
                    ),
                    collapsed: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 5),
                            itemCount: items.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var item = OrderModel.fromMap(items[index]);

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          width: 18,
                                          height: 23,
                                          // padding: EdgeInsets.symmetric(
                                          //     horizontal: 7, vertical: 2),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.black),
                                          child: Center(
                                            child: Text(
                                              item.amount.toString(),
                                              style: AppTextStyles.regular(14,
                                                  color: Colors.white),
                                            ),
                                          )),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${item.item.title} - ${item.option_selected["title"]}',
                                              style: AppTextStyles.regular(14),
                                            ),
                                            if (item.observations.isNotEmpty)
                                              SizedBox(
                                                width: 200,
                                                child: Text(
                                                  item.observations,
                                                  style: AppTextStyles.regular(
                                                      12,
                                                      color: Colors.grey),
                                                ),
                                              ),
                                            if (item.extras.isNotEmpty)
                                              for (int i = 0;
                                                  i < item.extras.length;
                                                  i++)
                                                SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    '+${item.extras[i]["title"]}  (${NumberFormat.currency(locale: "pt", symbol: r"R$").format(double.parse(item.extras[i]["value"].toString()))})',
                                                    style:
                                                        AppTextStyles.regular(
                                                            12,
                                                            color: Colors.grey),
                                                  ),
                                                ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    NumberFormat.currency(
                                            locale: "pt", symbol: r"R$ ")
                                        .format(double.parse(item
                                            .option_selected["value"]
                                            .toString())),
                                    style: AppTextStyles.regular(14,
                                        color: Colors.grey),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    expanded: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[],
                    ),
                    builder: (_, collapsed, expanded) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          theme: const ExpandableThemeData(
                              crossFadePoint: 0, hasIcon: false, iconSize: 0),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  color: OrderStatus.values.byName(status).getColor,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Center(
                    child: Text(
                      OrderStatus.values.byName(status).displayEnum,
                      style: AppTextStyles.regular(14, color: Colors.white54),
                    ),
                  ),
                )
              ],
            ),
          ),
          // Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(6), color: Colors.black),
          //     child: Text(
          //       items.length.toString(),
          //       style: AppTextStyles.regular(16, color: Colors.white),
          //     ))
        ]));
  }
}
