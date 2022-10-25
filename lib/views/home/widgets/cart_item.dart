import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:snacks_app/core/app.images.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/models/order_model.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    Key? key,
    required this.order,
  }) : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          // height: 85,
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(vertical: 15),
          // margin: EdgeInsets.symmetric(horizontal: 10),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 7,
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8)),
                    child: order.item.image_url == null
                        ? Center(
                            child: SvgPicture.asset(
                              AppImages.snacks,
                              color: Colors.grey.shade400,
                              // fit: BoxFit.,
                              width: 70,
                            ),
                          )
                        : Image.network(order.item.image_url!,
                            fit: BoxFit.cover),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.item.title,
                        style: AppTextStyles.regular(18),
                      ),
                      Text(
                        order.observations,
                        style:
                            AppTextStyles.regular(14, color: Color(0xff979797)),
                      ),
                    ],
                  )
                ],
              ),
              Text(
                NumberFormat.currency(locale: "pt", symbol: r"R$ ")
                    .format(order.item.value * order.amount),
                style: AppTextStyles.regular(16, color: Color(0xff09B44D)),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          top: 3,
          child: Container(
            height: 25,
            width: 25,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: Center(
                child: Text(
              order.amount.toString(),
              style: AppTextStyles.regular(14),
            )),
          ),
        ),
      ],
    );
  }
}
