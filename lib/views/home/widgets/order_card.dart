import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:snacks_app/core/app.images.dart';

import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/models/order_reponse.dart';
import 'package:snacks_app/utils/enums.dart';
import 'package:snacks_app/utils/modal.dart';
import 'package:snacks_app/views/home/widgets/modals/order_details.dart';
import 'package:snacks_app/views/home/widgets/signal_ripple_animation.dart';

class OrderCardWidget extends StatelessWidget {
  const OrderCardWidget({
    Key? key,
    required this.orders,
  }) : super(key: key);
  final List<OrderResponse> orders;
  @override
  Widget build(BuildContext context) {
    var order = orders[0];
    String time = DateFormat("HH:mm").format(order.createdAt);
    bool isDelivered = orders
        .map((e) => e.status == OrderStatus.delivered.name)
        .toList()
        .reduce((value, element) => value && element);

    double sum =
        orders.map((e) => e.value).reduce((value, element) => value + element);
    var total = NumberFormat.currency(locale: "pt", symbol: r"R$ ").format(sum);

    OrderStatus orderStatus = isDelivered
        ? OrderStatus.delivered
        : order.status == OrderStatus.waiting_payment.name
            ? OrderStatus.waiting_payment
            : OrderStatus.order_in_progress;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: const Color(0xffd9d9d9).withOpacity(0.3),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: order.isDelivery
                            ? SvgPicture.asset(
                                AppImages.snacks_logo,
                                width: 50,
                                color: const Color(0xff263238).withOpacity(0.7),
                              )
                            : Text(
                                order.table ?? "",
                                style: AppTextStyles.bold(45,
                                    color: const Color(0xff263238)),
                              ),
                      )),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.customerName ?? "Não informado",
                        style: AppTextStyles.regular(16,
                            color: const Color(0xff263238)),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '#${order.partCode}',
                        style: AppTextStyles.semiBold(16,
                            color: const Color(0xff263238)),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                time,
                style:
                    AppTextStyles.regular(14, color: const Color(0xff979797)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              children: [
                if (order.isDelivery)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Entrega',
                                style: AppTextStyles.light(12,
                                    color: const Color(0xff979797))),
                            Text(
                                order.receiveOrder == "local"
                                    ? "Irá até o local buscar o pedido"
                                    : order.address ?? "",
                                style: AppTextStyles.semiBold(14,
                                    color: const Color(0xff979797))),
                          ],
                        ),
                      ),
                    ]),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text('Método',
                            style: AppTextStyles.light(12,
                                color: const Color(0xff979797))),
                        Text(order.paymentMethod,
                            style: AppTextStyles.semiBold(14,
                                color: const Color(0xff979797))),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Valor',
                            style: AppTextStyles.light(12,
                                color: const Color(0xff979797))),
                        Text(total,
                            style: AppTextStyles.semiBold(14,
                                color: const Color(0xff979797))),
                      ],
                    ),
                    if (order.needChange)
                      Column(
                        children: [
                          Text('Troco',
                              style: AppTextStyles.light(12,
                                  color: const Color(0xff979797))),
                          Text(order.moneyChange,
                              style: AppTextStyles.semiBold(14,
                                  color: const Color(0xff979797))),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  isDelivered
                      ? const Icon(
                          Icons.check_circle_rounded,
                          size: 20,
                          color: Colors.black,
                        )
                      : SizedBox(
                          height: 25,
                          width: 25,
                          child: SignalRippleWidget(
                            count: 2,
                            color: OrderStatus.values
                                .byName(order.status)
                                .getColor,
                          )),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(orderStatus.displayEnum,
                      style: AppTextStyles.regular(14,
                          color: const Color(0xff979797))),
                ],
              ),
              SizedBox(
                  height: 35,
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () => AppModal().showModalBottomSheet(
                        context: context,
                        // expand: true,
                        content: OrderDetailsContent(orders: orders)),
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      'Detalhes',
                      style: AppTextStyles.regular(12, color: Colors.white),
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
