import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';
import 'package:snacks_app/components/custom_submit_button.dart';
import 'package:snacks_app/core/app.images.dart';
import 'package:snacks_app/core/app.routes.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/utils/storage.dart';
import 'package:snacks_app/views/home/state/cart_state/cart_cubit.dart';
import 'package:snacks_app/views/home/widgets/cart_item.dart';
import 'package:snacks_app/views/review/review_screen.dart';

class MyCartScreen extends StatelessWidget {
  MyCartScreen({Key? key}) : super(key: key);
  final auth = FirebaseAuth.instance;
  final storage = AppStorage();

  @override
  Widget build(BuildContext context) {
    context.read<CartCubit>().fetchDeliveryConfig();
    return SafeArea(
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: !(auth.currentUser?.isAnonymous ?? false) &&
                    state.cart.isNotEmpty
                ? Container(
                    height: 30,
                    width: 130,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        // border: Border.fromBorderSide(BorderSide()),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.hourglass_bottom,
                            color: Colors.black38),
                        Text(
                          "30~60 min",
                          style:
                              AppTextStyles.semiBold(14, color: Colors.black38),
                        )
                      ],
                    ),
                  )
                : null,
            bottomNavigationBar: state.cart.isNotEmpty
                ? Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, bottom: 30),
                    child: SizedBox(
                      height:
                          !(auth.currentUser?.isAnonymous ?? false) ? 265 : 150,
                      child: BlocBuilder<CartCubit, CartState>(
                          builder: (context, snapshot) {
                        var subTotal = snapshot.cart
                            .map((e) => e.getTotalValue)
                            .reduce((value, element) => value + element);
                        double delivery = (state.receive_order == "address"
                            ? state.delivery_value
                            : 0);
                        double total = subTotal + delivery;
                        bool isDelivery =
                            !(auth.currentUser?.isAnonymous ?? false);

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isDelivery)
                              Column(
                                children: [
                                  CustomRadioButtonSelect(
                                    text: "Ir até o local",
                                    selected: state.receive_order,
                                    value: "local",
                                    onChange: (value) => context
                                        .read<CartCubit>()
                                        .updateReceiveOrderMethod(value),
                                  ),
                                  FutureBuilder(
                                      future: storage.getDataStorage("address"),
                                      builder: (context, snapshot) {
                                        if (snapshot.data == "" ||
                                            snapshot.data == null) {
                                          context
                                              .read<CartCubit>()
                                              .updateReceiveOrderMethod(
                                                  "local");
                                          return TextButton(
                                            onPressed: () =>
                                                Navigator.pushNamed(
                                                    context, AppRoutes.address),
                                            child: Text(
                                              'Adicionar endereço',
                                              style: AppTextStyles.medium(12),
                                            ),
                                          );
                                        } else {
                                          return CustomRadioButtonSelect(
                                            text:
                                                'Entregar no endereço: ${snapshot.data}',
                                            selected: state.receive_order,
                                            value: "address",
                                            disable: state.delivery_disable,
                                            onChange: (value) => context
                                                .read<CartCubit>()
                                                .updateReceiveOrderMethod(
                                                    value),
                                          );
                                        }
                                      })
                                ],
                              ),
                            Container(
                              decoration: const BoxDecoration(
                                  color: Color(0xffF6F6F6),
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12),
                                      bottom: Radius.circular(30))),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
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
                                                  color:
                                                      const Color(0xff979797)),
                                            ),
                                            Text(
                                              NumberFormat.currency(
                                                      locale: "pt",
                                                      symbol: r"R$ ")
                                                  .format(subTotal),
                                              style: AppTextStyles.regular(17,
                                                  color:
                                                      const Color(0xff979797)),
                                            ),
                                          ],
                                        ),
                                        isDelivery
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Entrega',
                                                    style:
                                                        AppTextStyles.regular(
                                                            17,
                                                            color: const Color(
                                                                0xff979797)),
                                                  ),
                                                  Text(
                                                    NumberFormat.currency(
                                                            locale: "pt",
                                                            symbol: r"R$ ")
                                                        .format(delivery),
                                                    style:
                                                        AppTextStyles.regular(
                                                            17,
                                                            color: const Color(
                                                                0xff979797)),
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
                                                  color:
                                                      const Color(0xff979797)),
                                            ),
                                            Text(
                                              NumberFormat.currency(
                                                      locale: "pt",
                                                      symbol: r"R$ ")
                                                  .format(total),
                                              style: AppTextStyles.semiBold(17,
                                                  color:
                                                      const Color(0xff979797)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  CustomSubmitButton(
                                      onPressedAction: () => auth.currentUser !=
                                                  null &&
                                              !(auth.currentUser!.isAnonymous &&
                                                  snapshot.address.isNotEmpty)
                                          ? Navigator.pushNamed(
                                              context, AppRoutes.payment)
                                          : Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              AppRoutes.start,
                                              (route) => false),
                                      label: "Continuar",
                                      loading_label: "",
                                      loading: false)
                                ],
                              ),
                            ),
                          ],
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
                            primary: const Color(0xffF6F6F6),
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
                                tapBodyToExpand: true,
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
                                        itemBuilder: (context, index) => Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  order.extras[index]["title"],
                                                  style:
                                                      AppTextStyles.medium(12),
                                                ),
                                                Text(
                                                  '+${NumberFormat.currency(locale: "pt", symbol: r"R$ ").format(double.parse(order.extras[index]["value"].toString()))}',
                                                  style: AppTextStyles.semiBold(
                                                      12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(),
                                      Text(
                                        order.observations,
                                        style: AppTextStyles.light(12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              collapsed: order.extras.isNotEmpty ||
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

  Widget CustomRadioButtonSelect(
      {required String text,
      required String value,
      required String selected,
      required onChange,
      bool disable = false}) {
    bool isSelected = selected == value;
    return OutlinedButton(
      onPressed: () => disable ? null : onChange(value),
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(double.maxFinite, 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        side: BorderSide(color: isSelected ? Colors.green : Colors.black12),
      ),
      child: Text(
        text,
        style: AppTextStyles.semiBold(
          12,
          color: isSelected ? Colors.green : Colors.black12,
        ),
      ),
    );
  }
}
