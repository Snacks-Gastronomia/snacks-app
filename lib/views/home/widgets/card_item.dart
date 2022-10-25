import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:snacks_app/core/app.colors.dart';
import 'package:snacks_app/core/app.images.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/models/item_model.dart';
import 'package:snacks_app/models/order_model.dart';
import 'package:snacks_app/utils/modal.dart';
import 'package:snacks_app/views/home/state/cart_state/cart_cubit.dart';
import 'package:snacks_app/views/home/state/item_screen/item_screen_cubit.dart';

import 'modals/modal_content_obs.dart';

class CardItemWidget extends StatelessWidget {
  const CardItemWidget({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context) {
    var order = Order(item: item, observations: "");
    return Stack(
      children: [
        Container(
          width: 155,
          height: 155,
          // margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          clipBehavior: Clip.hardEdge,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xffF6F6F6),
            // color: Colors.grey.shade200,
            // color: Colors.white,
            // border: Border.fromBorderSide(
            //     BorderSide(width: 1, color: Colors.grey.shade400)),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.2), //color of shadow
            //     spreadRadius: 2, //spread radius
            //     blurRadius: 5, // blur radius
            //     offset: Offset(0, 2), // changes position of shadow
            //   ),
          ),

          // color: Colors.amber),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                child: item.image_url == null
                    ? Center(
                        child: SvgPicture.asset(
                          AppImages.snacks,
                          color: Colors.grey.shade400,
                          // fit: BoxFit.,
                          width: 70,
                        ),
                      )
                    : Image.network(item.image_url!, fit: BoxFit.cover),
              ),
              Container(
                height: 2,
                color: Colors.grey,
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.title,
                          // maxLines: 2,
                          style: AppTextStyles.medium(14,
                              color: AppColors.highlight),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true),
                      Text(
                        NumberFormat.currency(locale: "pt", symbol: r"R$ ")
                            .format(item.value),
                        style: AppTextStyles.regular(15,
                            color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: -10,
          right: 0,
          child: SizedBox(
            // height: 50,
            child: BlocBuilder<CartCubit, CartState>(
              key: UniqueKey(),
              builder: (context, state) {
                // bool itemAdded = state.cart.contains(order);
                return IconButton(
                  onPressed: () {
                    context.read<ItemScreenCubit>().insertItem(order, true);
                    context.read<CartCubit>().hasItem(order.item.id!)
                        ? context.read<CartCubit>().removeToCart(order)
                        : AppModal().showModalBottomSheet(
                            context: context,
                            // isScrollControlled: true,
                            content: ModalContentObservation(
                                action: () {
                                  context.read<CartCubit>().addToCart(context
                                      .read<ItemScreenCubit>()
                                      .state
                                      .order!);
                                  Navigator.pop(context);
                                },
                                onChanged: context
                                    .read<ItemScreenCubit>()
                                    .observationChanged),
                          );
                  },
                  tooltip: context.read<CartCubit>().hasItem(order.item.id!)
                      ? "Remover pedido"
                      : "Adicionar ao pedido",
                  icon: Container(
                      // height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: context.read<CartCubit>().hasItem(order.item.id!)
                          ? Icon(
                              Icons.remove_rounded,
                              color: Colors.red.shade700,
                            )
                          : const Icon(Icons.add)),
                  color: Colors.black87,
                  iconSize: 30,
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
