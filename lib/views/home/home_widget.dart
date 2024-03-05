import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snacks_app/components/custom_submit_button.dart';
import 'package:snacks_app/core/app.colors.dart';
import 'package:snacks_app/core/app.images.dart';
import 'package:snacks_app/core/app.routes.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/models/item_model.dart';
import 'package:snacks_app/models/order_model.dart';
import 'package:snacks_app/utils/enums.dart';
import 'package:snacks_app/utils/modal.dart';
import 'package:snacks_app/views/home/item_screen.dart';
import 'package:snacks_app/views/home/state/cart_state/cart_cubit.dart';
import 'package:snacks_app/views/home/state/home_state/home_cubit.dart';
import 'package:snacks_app/views/home/widgets/card_item.dart';
import 'package:snacks_app/views/home/widgets/skeletons.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  int customLimit = 80;
  late ScrollController controller;
  // final key = GlobalKey();
  final auth = FirebaseAuth.instance;
  TextEditingController textEditingController = TextEditingController();
  String category = "";
  @override
  void initState() {
    controller = ScrollController();
    context.read<HomeCubit>().fetchItems(limit: customLimit);
    print(auth.currentUser);
    controller.addListener(
      () {
        _onAllItemsScroll();
        var cart = context.read<CartCubit>().emptyCart();

        if (controller.offset > 60 && !cart) {
          context.read<HomeCubit>().changeButtonDone(true);
        } else {
          context.read<HomeCubit>().changeButtonDone(false);
        }
      },
    );
    super.initState();
  }

  void _onAllItemsScroll() {
    if (controller.position.pixels == controller.position.maxScrollExtent &&
        textEditingController.text.isEmpty &&
        category.isEmpty) {
      customLimit += 50;
      context.read<HomeCubit>().fetchItems(limit: customLimit);
    }
  }

  @override
  void didChangeDependencies() {
    _navigator = Navigator.of(context);

    super.didChangeDependencies();
  }

  late NavigatorState _navigator;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final modal = AppModal();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: key,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: Container(
          padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                AppImages.snacks,
                width: 140,
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return AnimatedOpacity(
              opacity: state.showButton ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: state.showButton
                  ? Padding(
                      padding: const EdgeInsets.only(
                          bottom: 70, left: 20, right: 20),
                      child: CustomSubmitButton(
                          onPressedAction: () =>
                              Navigator.pushNamed(context, AppRoutes.cart),
                          label: "Continuar",
                          loading_label: "",
                          loading: false),
                    )
                  : const SizedBox());
          // }
          // return const SizedBox();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: Padding(
        padding: const EdgeInsets.only(left: 25, top: 25, right: 25),
        child: SingleChildScrollView(
          controller: controller,
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              const TopWidget(),
              const SizedBox(
                height: 45,
              ),
              TextFormField(
                controller: textEditingController,
                style: AppTextStyles.light(16, color: const Color(0xff8391A1)),
                autofocus: false,
                onChanged: context.read<HomeCubit>().fetchQuery,
                decoration: InputDecoration(
                  fillColor: Colors.black.withOpacity(0.033),
                  filled: true,
                  hintStyle: AppTextStyles.light(16,
                      color: Colors.black.withOpacity(0.5)),
                  contentPadding:
                      const EdgeInsets.only(left: 17, top: 15, bottom: 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  suffixIcon: const Icon(Icons.search),
                  hintText: 'Pesquise um item',
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              // Text(
              //   'Itens populares',
              //   style: AppTextStyles.medium(18),
              // ),
              SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: FutureBuilder(
                      future: context.read<HomeCubit>().fetchRestaurants(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              width: 10,
                            ),
                            itemCount: snapshot.data?.docs.length ?? 0,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              var item = snapshot.data?.docs[index];
                              bool isSelected = category == item?.id;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      category = "";
                                    } else {
                                      category = item?.id ?? "";
                                    }
                                  });
                                  context
                                      .read<HomeCubit>()
                                      .fetchItemsByRestaurants(category, true);
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                    blurRadius: 15,
                                                    spreadRadius: 0.5,
                                                    // offset: O,
                                                    color: AppColors.highlight
                                                        .withOpacity(0.4))
                                              ]
                                            : null,
                                        color: isSelected
                                            ? AppColors.highlight
                                            : Colors.white,
                                        border: isSelected
                                            ? null
                                            : Border.fromBorderSide(BorderSide(
                                                color: Colors.grey.shade300)),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        item?.get("name"),
                                        style: AppTextStyles.medium(
                                          16,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey.shade500,
                                        ),
                                      ),
                                    )),
                              );
                            },
                          );
                        }
                        return const SizedBox();
                      }),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // PopularItemsWidget(ns: _navigator),
              // const SizedBox(
              //   height: 25,
              // ),
              Text(
                'Cardápio',
                style: AppTextStyles.medium(18),
              ),
              const SizedBox(
                height: 10,
              ),
              AllItemsWidget(ns: _navigator),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AllItemsWidget extends StatelessWidget {
  AllItemsWidget({
    Key? key,
    required this.ns,
  }) : super(key: key);

  final NavigatorState ns;
  final modal = AppModal();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.status == AppStatus.loading) {
          return const ListSkeletons(direction: Axis.vertical);
        }

        bool isTablet = MediaQuery.of(context).size.width > 600;
        return FutureBuilder<QuerySnapshot>(
          future: state.menu,
          builder: (context, snapshot) {
            if (snapshot.hasData ||
                snapshot.connectionState == ConnectionState.done) {
              var data = snapshot.data?.docs ?? [];
              if ((data).isEmpty) {
                return const Center(
                  child: Text("Cardapio vazio"),
                );
              }

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isTablet ? 3 : 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  mainAxisExtent: isTablet ? 230 : 160,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length + 2,
                itemBuilder: (BuildContext ctx, index) {
                  if (data.length <= index && state.listIsLastPage) {
                    return Transform.scale(
                      scale: 0.9,
                      child: const CardSkeleton(),
                    );
                  } else if (index >= data.length) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    );
                  } else {
                    var item = Item.fromJson(jsonEncode(data[index].data()));
                    var id = data[index].id;
                    item = item.copyWith(id: id);

                    return GestureDetector(
                      onTap: () => modal.showIOSModalBottomSheet(
                        context: context,
                        content: ItemScreen(
                          order: OrderModel(
                              item: item,
                              observations: "",
                              option_selected: item.options[0]),
                        ),
                      ),
                      child: CardItemWidget(
                        // ns: ns,
                        item: item,
                      ),
                    );
                  }
                },
              );
            }

            return const ListSkeletons(direction: Axis.vertical);
          },
        );
      },
    );
  }
}

class PopularItemsWidget extends StatelessWidget {
  const PopularItemsWidget({
    Key? key,
    required this.ns,
  }) : super(key: key);
  final NavigatorState ns;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
        // stream: null,
        builder: (context, snapshot) {
      if (snapshot.status == AppStatus.loading) {
        return const ListSkeletons(direction: Axis.horizontal);
      }
      return SizedBox(
        height: 155,
        child: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) => const SizedBox(
            width: 10,
          ),
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.popular.length, //alterado sem teste
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            var item = snapshot.popular[index];
            return SizedBox(
                width: 165,
                child: GestureDetector(
                    onTap: () => AppModal().showIOSModalBottomSheet(
                        context: context,
                        expand: true,
                        content: ItemScreen(
                            order: OrderModel(
                                item: item,
                                observations: "",
                                option_selected: {}))),
                    child: CardItemWidget(
                      // ns: ns,
                      item: item,
                    )));
          },
        ),
      );
    });
  }
}

class TopWidget extends StatelessWidget {
  const TopWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 200,
          child: Text(
            'Fast and Delicious Food',
            style: AppTextStyles.medium(25),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.cart),
          child: Stack(
            children: [
              SvgPicture.asset(
                AppImages.shopping_bag,
                // width: 30,
                height: 35,
                color: AppColors.highlight,
              ),
              BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  return Positioned(
                    top: 3,
                    right: 0,
                    child: Container(
                      // padding: const EdgeInsets.all(5),
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          color: AppColors.highlight,
                          border: const Border.fromBorderSide(
                              BorderSide(color: Colors.white, width: 1)),
                          shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          context
                              .read<CartCubit>()
                              .state
                              .cart
                              .length
                              .toString(),
                          style: AppTextStyles.medium(12, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
