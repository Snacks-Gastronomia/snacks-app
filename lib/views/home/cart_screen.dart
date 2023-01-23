import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:snacks_app/core/app.colors.dart';
import 'package:snacks_app/core/app.images.dart';
import 'package:snacks_app/core/app.routes.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/models/order_model.dart';
import 'package:snacks_app/utils/format.dart';
import 'package:snacks_app/views/authentication/state/auth_cubit.dart';
import 'package:snacks_app/views/home/state/cart_state/cart_cubit.dart';
import 'package:snacks_app/views/home/widgets/custom_switch.dart';
import 'package:snacks_app/views/home/widgets/cart_item.dart';

class MyCartScreen extends StatelessWidget {
  MyCartScreen({Key? key}) : super(key: key);
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: state.cart.isNotEmpty
                ? Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, bottom: 30),
                    child: SizedBox(
                      height:
                          !(auth.currentUser?.isAnonymous ?? false) ? 180 : 150,
                      child: BlocBuilder<CartCubit, CartState>(
                          builder: (context, snapshot) {
                        return Container(
                          decoration: const BoxDecoration(
                              color: Color(0xffF6F6F6),
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12),
                                  bottom: Radius.circular(30))),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 17),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Subtotal',
                                            style: AppTextStyles.regular(17,
                                                color: Color(0xff979797)),
                                          ),
                                          Text(
                                            NumberFormat.currency(
                                                    locale: "pt",
                                                    symbol: r"R$ ")
                                                .format(snapshot.total),
                                            style: AppTextStyles.regular(17,
                                                color: Color(0xff979797)),
                                          ),
                                        ],
                                      ),
                                      !(auth.currentUser?.isAnonymous ?? false)
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Entrega',
                                                  style: AppTextStyles.regular(
                                                      17,
                                                      color: Color(0xff979797)),
                                                ),
                                                Text(
                                                  '5.00',
                                                  style: AppTextStyles.regular(
                                                      17,
                                                      color: Color(0xff979797)),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total',
                                            style: AppTextStyles.semiBold(17,
                                                color: Color(0xff979797)),
                                          ),
                                          Text(
                                            NumberFormat.currency(
                                                    locale: "pt",
                                                    symbol: r"R$ ")
                                                .format(snapshot.total),
                                            style: AppTextStyles.semiBold(17,
                                                color: Color(0xff979797)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pushNamed(
                                    context, AppRoutes.payment),
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    primary: Colors.black,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    fixedSize:
                                        const Size(double.maxFinite, 59)),
                                child: Text(
                                  'Continuar',
                                  style: AppTextStyles.regular(16,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  )
                : null,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: Container(
                padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
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
                    const SizedBox(
                      width: 15,
                      // height: 41,
                    ),
                    Text(
                      'Minha sacola',
                      style: AppTextStyles.medium(20),
                    ),
                  ],
                ),
              ),
            ),
            body: state.cart.isEmpty
                ? Column(
                    children: [
                      const Spacer(),
                      Center(
                        child: Column(
                          children: [
                            SvgPicture.asset(AppImages.shopping_bag,
                                height: 100, color: Colors.grey.shade400),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Sua sacola está vazia!',
                              style: AppTextStyles.medium(15,
                                  color: Colors.grey.shade400),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: BlocBuilder<CartCubit, CartState>(
                        builder: (context, snapshot) {
                      return ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                            // height: 0.3,

                            ),
                        itemCount: context.read<CartCubit>().state.cart.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          var order =
                              context.read<CartCubit>().state.cart[index];
                          return ExpandableNotifier(
                            initialExpanded: false,
                            child: ExpandablePanel(
                              theme: ExpandableThemeData(
                                tapHeaderToExpand: order.extras.isNotEmpty &&
                                    order.observations.isNotEmpty,
                                headerAlignment:
                                    ExpandablePanelHeaderAlignment.center,
                                tapBodyToCollapse: true,
                                tapBodyToExpand: false,
                                hasIcon: false,
                              ),
                              expanded: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        itemCount: order.extras.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) => Text(
                                          order.extras[index],
                                          style: AppTextStyles.semiBold(12),
                                        ),
                                      ),
                                      const Divider(),
                                      Text(
                                        '\"${order.observations}\"',
                                        style: AppTextStyles.light(12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              collapsed: order.extras.isNotEmpty &&
                                      order.observations.isNotEmpty
                                  ? Center(
                                      child: Text(
                                          'Clique no item para ver detalhes',
                                          style: AppTextStyles.medium(12,
                                              color: Colors.grey)),
                                    )
                                  : const SizedBox(),
                              header: CartItemWidget(
                                order: order,
                                onDecrement: () => context
                                    .read<CartCubit>()
                                    .decrementItem(order.item.id!),
                                onIncrement: () => context
                                    .read<CartCubit>()
                                    .incrementItem(order.item.id!),
                                onDelete: () => context
                                    .read<CartCubit>()
                                    .removeToCart(order),
                              ),
                            ),
                          );
                        },
                      );
                    })),
          );
        },
      ),
    );
  }
}
