import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:snacks_app/core/app.colors.dart';
import 'package:snacks_app/core/app.images.dart';
import 'package:snacks_app/core/app.routes.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/models/order_model.dart';
import 'package:snacks_app/utils/modal.dart';
import 'package:snacks_app/utils/toast.dart';
import 'package:snacks_app/views/home/state/cart_state/cart_cubit.dart';
import 'package:snacks_app/views/home/state/item_screen/item_screen_cubit.dart';
import 'package:snacks_app/views/home/widgets/modals/modal_content_obs.dart';

class ItemScreen extends StatefulWidget {
  ItemScreen({Key? key, required this.order}) : super(key: key);

  OrderModel order;

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  // late int amount;
  // bool updateItem = false;
  final auth = FirebaseAuth.instance;
  final toast = AppToast();
  @override
  void initState() {
    super.initState();

    var item =
        context.read<CartCubit>().getOrderByItemId(widget.order.item.id!);

    if (item != null) {
      context.read<ItemScreenCubit>().insertItem(item, false);
    } else {
      context.read<ItemScreenCubit>().insertItem(widget.order, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(left: 25, right: 25, bottom: 20, top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50,
              child: BlocBuilder<ItemScreenCubit, ItemScreenState>(
                builder: (context, state) {
                  return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var discount = widget.order.item.discount!;
                        var option = widget.order.item.options[index];
                        bool selected =
                            state.order?.option_selected["id"] == option["id"];

                        return GestureDetector(
                          onTap: () => context
                              .read<ItemScreenCubit>()
                              .selectOption(option),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: selected
                                    ? null
                                    : const Border.fromBorderSide(
                                        BorderSide(color: Colors.black)),
                                color: selected ? Colors.black : Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${option["title"]}',
                                  style: AppTextStyles.medium(14,
                                      color: selected
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                Text(
                                  NumberFormat.currency(
                                          locale: "pt", symbol: r"R$ ")
                                      .format(double.tryParse(
                                              option["value"].toString())! *
                                          (1 - discount / 100)),
                                  style: AppTextStyles.medium(10,
                                      color: selected
                                          ? Colors.white38
                                          : Colors.black26),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                            width: 10,
                          ),
                      itemCount: widget.order.item.options.length);
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<ItemScreenCubit, ItemScreenState>(
                  builder: (context, state) {
                    return Text(
                      NumberFormat.currency(locale: "pt", symbol: r"R$ ")
                          .format(context
                                  .read<ItemScreenCubit>()
                                  .state
                                  .order
                                  ?.getTotalValue ??
                              0),
                      style:
                          AppTextStyles.medium(18, color: AppColors.highlight),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    AppModal().showModalBottomSheet(
                      context: context,
                      content: ModalContentObservation(
                          action: () {
                            var order =
                                context.read<ItemScreenCubit>().state.order!;
                            BlocProvider.of<CartCubit>(context)
                                .addToCart(order);
                            Navigator.popUntil(
                                context, ModalRoute.withName(AppRoutes.home));

                            Navigator.pushNamed(context, AppRoutes.cart);
                          },
                          value: context
                              .read<ItemScreenCubit>()
                              .state
                              .order!
                              .observations,
                          onChanged: context
                              .read<ItemScreenCubit>()
                              .observationChanged),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: Colors.black,
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
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
                  child: widget.order.item.image_url == null ||
                          widget.order.item.image_url!.isEmpty
                      ? Container(
                          color: Colors.grey.shade200,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Center(
                            child: SvgPicture.asset(
                              AppImages.snacks,
                              color: Colors.grey.shade400,
                              // fit: BoxFit,
                              width: 150,
                            ),
                          ),
                        )
                      : Image.network(
                          widget.order.item.image_url!,
                          fit: BoxFit.cover,
                          width: double.maxFinite,
                          height: MediaQuery.of(context).size.height * 0.5,
                          errorBuilder: (context, error, stackTrace) {
                            return SizedBox.shrink();
                          },

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
                          color: const Color(0xffF6F6F6),
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
                                        backgroundColor:
                                            const Color(0xffF6F6F6),
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
                                            backgroundColor:
                                                const Color(0xffF6F6F6),
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
                              backgroundColor: const Color(0xffF6F6F6),
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(41, 41)),
                          child: const Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.black,
                            size: 19,
                          )),
                      const SizedBox(
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
                      Expanded(
                        child: Text(
                          widget.order.item.title,
                          style: AppTextStyles.medium(18),
                        ),
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
                    height: 5,
                  ),
                  Text(
                    'Este prato serve ${widget.order.item.num_served} pessoa${widget.order.item.num_served > 1 ? "s" : ""}',
                    style: AppTextStyles.light(12),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    widget.order.item.description!,
                    style: AppTextStyles.regular(15,
                        color: const Color(0xff979797)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (widget.order.item.extras.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Extras",
                          style: AppTextStyles.semiBold(18),
                        ),
                        if (widget.order.item.limit_extra_options != null)
                          Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Selecione até ${widget.order.item.limit_extra_options} opç${widget.order.item.num_served > 1 ? "ões" : "ão"}',
                                style: AppTextStyles.light(12),
                              ),
                            ],
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.separated(
                            itemCount: widget.order.item.extras.length,
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 10,
                                ),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var list = List.from(widget.order.item.extras);
                              var item = list[index];
                              double value =
                                  double.parse(item['value'].toString());

                              return BlocBuilder<ItemScreenCubit,
                                      ItemScreenState>(
                                  // stream: null,
                                  builder: (context, state) {
                                bool selected = context
                                    .read<ItemScreenCubit>()
                                    .hasItemId(item["id"]);

                                return GestureDetector(
                                  onTap: () => context
                                      .read<ItemScreenCubit>()
                                      .selectExtras(item),
                                  child: Container(
                                    // height: 50,
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        color: selected
                                            ? Colors.black
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: const Border.fromBorderSide(
                                            BorderSide(width: 2))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.plus_one_rounded,
                                              color: selected
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            SizedBox(
                                              width: 150,
                                              child: Text(
                                                item["title"],
                                                style: AppTextStyles.medium(
                                                  16,
                                                  color: selected
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "+${NumberFormat.currency(locale: "pt", symbol: r"R$ ").format(value)}",
                                          style: AppTextStyles.medium(16,
                                              color: AppColors.highlight),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                            })
                      ],
                    ),

                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
