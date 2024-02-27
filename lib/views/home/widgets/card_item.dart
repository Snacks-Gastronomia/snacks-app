import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:snacks_app/core/app.colors.dart';
import 'package:snacks_app/core/app.images.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/models/item_model.dart';
import 'package:snacks_app/models/order_model.dart';
import 'package:snacks_app/services/orders_service.dart';
import 'package:snacks_app/utils/modal.dart';
import 'package:snacks_app/utils/toast.dart';
import 'package:snacks_app/views/home/state/cart_state/cart_cubit.dart';
import 'package:snacks_app/views/home/state/item_screen/item_screen_cubit.dart';

class CardItemWidget extends StatelessWidget {
  CardItemWidget({Key? key, required this.item}) : super(key: key);
  final Item item;
  final auth = FirebaseAuth.instance;
  final modal = AppModal();
  final toast = AppToast();
  @override
  Widget build(BuildContext context) {
    var order = OrderModel(
        item: item,
        observations: "",
        option_selected: item.options.isNotEmpty ? item.options[0] : null);
    var sizeHeight = MediaQuery.of(context).size.height;
    var price = item.options.isNotEmpty ? item.options[0]["value"] : item.value;

    return Builder(builder: (context) {
      return Stack(
        children: [
          Container(
            // width: 155,
            // height: 155,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xffF6F6F6),
            ),

            // color: Colors.amber),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FutureBuilder<bool>(
                    future: OrdersApiServices().isValidImage(item.image_url),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var validImage = snapshot.data!;
                        return SizedBox(
                          height: sizeHeight * 0.11,
                          width: double.maxFinite,
                          child: Center(
                              child: item.image_url == null && validImage
                                  ? SvgPicture.asset(
                                      AppImages.snacks,
                                      color: Colors.grey.shade400,
                                      width: 80,
                                    )
                                  : FadeInImage(
                                      image: NetworkImage(item.image_url!),
                                      placeholder:
                                          AssetImage(AppImages.launcher),
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return SvgPicture.asset(
                                          AppImages.snacks,
                                          color: Colors.grey.shade400,
                                          width: 80,
                                        );
                                      },
                                      fit: BoxFit.fitWidth,
                                    )

                              )
                        );
                      }
                      return SizedBox(
                        height: sizeHeight * 0.11,
                      );
                    }),
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
                              .format(double.parse(price.toString())),
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
                builder: (context, state) {
                  return IconButton(
                    onPressed: () {
                      context.read<ItemScreenCubit>().insertItem(order, true);
                      context.read<CartCubit>().hasItem(order.item.id ?? "")
                          ? context.read<CartCubit>().removeToCart(order)
                          : context.read<CartCubit>().addToCart(order);
                    },
                    tooltip:
                        context.read<CartCubit>().hasItem(order.item.id ?? "")
                            ? "Remover pedido"
                            : "Adicionar ao pedido",
                    icon: Container(
                        // height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: context
                                .read<CartCubit>()
                                .hasItem(order.item.id ?? "")
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
    });
  }
}
