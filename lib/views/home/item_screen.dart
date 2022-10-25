import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:snacks_app/core/app.colors.dart';
import 'package:snacks_app/core/app.routes.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/models/order_model.dart';
import 'package:snacks_app/utils/modal.dart';
import 'package:snacks_app/views/home/state/cart_state/cart_cubit.dart';
import 'package:snacks_app/views/home/state/item_screen/item_screen_cubit.dart';
import 'package:snacks_app/views/home/widgets/modals/modal_content_obs.dart';

class ItemScreen extends StatefulWidget {
  ItemScreen({Key? key, required this.order}) : super(key: key);

  Order order;

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  // late int amount;
  // bool updateItem = false;
  @override
  void initState() {
    super.initState();

    var item =
        context.read<CartCubit>().getOrderByItemId(widget.order.item.id!);
    print(item);
    if (item != null) {
      context.read<ItemScreenCubit>().insertItem(item, false);
    } else {
      context.read<ItemScreenCubit>().insertItem(widget.order, true);
    }
    // if (item != null) {
    //   setState(() {
    //     updateItem = true;
    //     widget.order = item;
    //   });
    // }
    // amount = widget.order.amount;
  }

  // void increment() {
  //   setState(() {
  //     amount++;
  //     widget.order.amount = amount;
  //   });
  // }

  // void decrement() {
  //   setState(() {
  //     if (amount > 1) {
  //       amount--;
  //       widget.order.amount = amount;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<ItemScreenCubit, ItemScreenState>(
              builder: (context, state) {
                return Text(
                  NumberFormat.currency(locale: "pt", symbol: r"R$ ")
                      .format(context.read<ItemScreenCubit>().getNewValue()),
                  style: AppTextStyles.medium(18, color: AppColors.highlight),
                );
              },
            ),
            ElevatedButton(
              onPressed: () => AppModal().showModalBottomSheet(
                context: context,
                content: ModalContentObservation(
                    action: () {
                      var order = context.read<ItemScreenCubit>().state.order!;
                      if (context.read<ItemScreenCubit>().state.isNew) {
                        BlocProvider.of<CartCubit>(context).addToCart(order);
                      } else {
                        BlocProvider.of<CartCubit>(context)
                            .updateItemFromCart(order);
                      }
                      Navigator.popUntil(
                          context, ModalRoute.withName(AppRoutes.home));

                      Navigator.pushNamed(context, AppRoutes.cart);
                    },
                    value: context
                        .read<ItemScreenCubit>()
                        .state
                        .order!
                        .observations,
                    onChanged:
                        context.read<ItemScreenCubit>().observationChanged),
              ),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  primary: Colors.black,
                  fixedSize: const Size(200, 52)),
              child: Text(
                context.read<ItemScreenCubit>().state.isNew
                    ? 'Adicionar'
                    : "Ok",
                style: AppTextStyles.regular(16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(55),
                      bottomRight: Radius.circular(55)),
                  child: Image.network(
                    "https://www.dicasdemulher.com.br/wp-content/uploads/2021/04/drinks-de-morango-00.png",
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.5,

                    // height: 200,
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.465,
                  left: 0,
                  right: 0,
                  child: Stack(children: [
                    Center(
                      child: Container(
                        width: 130,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          // color: Colors.black,
                          color: Color(0xffF6F6F6),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey.shade300,
                          //     blurRadius: 8.0,
                          //     spreadRadius: 1.0,
                          //   ),
                          // ]
                        ),
                      ),
                    ),
                    Center(
                      child: BlocBuilder<ItemScreenCubit, ItemScreenState>(
                        builder: (context, state) {
                          return SizedBox(
                            width: 160,
                            height: 45,
                            child:
                                BlocBuilder<ItemScreenCubit, ItemScreenState>(
                              builder: (context, state) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => context
                                          .read<ItemScreenCubit>()
                                          .decrementAmount(),
                                      style: ElevatedButton.styleFrom(
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        shape: const CircleBorder(
                                            side: BorderSide(
                                                color: Colors.white, width: 2)),
                                        primary: Color(0xffF6F6F6),
                                        shadowColor: Colors.grey.shade200,
                                        fixedSize: const Size(45, 45),
                                        // elevation: 0
                                      ),
                                      child: const Icon(
                                        Icons.remove_rounded,
                                        color: Color(0xff626262),
                                      ),
                                    ),
                                    Text(
                                      context
                                          .read<ItemScreenCubit>()
                                          .state
                                          .order!
                                          .amount
                                          .toString(),
                                      style: AppTextStyles.medium(20),
                                    ),
                                    ElevatedButton(
                                        onPressed: () => context
                                            .read<ItemScreenCubit>()
                                            .incrementAmount(),
                                        style: ElevatedButton.styleFrom(
                                            shape: const CircleBorder(
                                                side: BorderSide(
                                                    color: Colors.white,
                                                    width: 2)),
                                            primary: Color(0xffF6F6F6),
                                            // elevation: 0,
                                            shadowColor: Colors.grey.shade200,
                                            fixedSize: const Size(45, 45)),
                                        child: Icon(
                                          Icons.add_rounded,
                                          color: AppColors.highlight,
                                        )),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              primary: Color(0xffF6F6F6),
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(41, 41)),
                          child: const Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.black,
                            size: 19,
                          )),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Detalhes',
                        style: AppTextStyles.textShadow(
                            AppTextStyles.medium(20, color: Colors.white),
                            shadows: [
                              const BoxShadow(
                                offset: Offset(0, 2),
                                blurRadius: 20,
                                spreadRadius: 10,
                                color: Colors.black,
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   children: const [
                  //     Icon(Icons.star_rounded),
                  //     Text('4.9'),
                  //   ],
                  // ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.order.item.title,
                        style: AppTextStyles.medium(18),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${widget.order.item.time} min',
                            style: AppTextStyles.medium(16),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    widget.order.item.description!,
                    style: AppTextStyles.regular(15, color: Color(0xff979797)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
