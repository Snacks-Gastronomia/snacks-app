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
  late ScrollController controller;
  // final key = GlobalKey();
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    controller = ScrollController();
    // TODO: implement initState
    //  _navigator.pushAndRemoveUntil(..., (route) => ...);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    controller.addListener(
      () {
        var state = context.read<HomeCubit>().state;
        var cart = context.read<CartCubit>().state;

        if (controller.offset > 60 && cart.cart.isNotEmpty) {
          context.read<HomeCubit>().changeButtonDone(true);
        } else {
          context.read<HomeCubit>().changeButtonDone(false);
        }
        if (controller.position.maxScrollExtent == controller.offset &&
            state.status == AppStatus.loaded) {
          if (state.category != null) {
            context
                .read<HomeCubit>()
                .fetchItemsByRestaurants(state.category ?? "", false);
          } else {
            print("object 2");
            context.read<HomeCubit>().fetchItems();
          }
        }
      },
    );
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

              TextButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.fromLTRB(15, 0, 10, 0)),
                  onPressed: () => auth.signOut().then((value) =>
                      Navigator.pushReplacementNamed(context, AppRoutes.start)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder<String?>(
                          future:
                              context.read<HomeCubit>().readStorage("table"),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                'Mesa ${snapshot.data.toString()}',
                                style: AppTextStyles.regular(14,
                                    color: Colors.black54),
                              );
                            }
                            return SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                color: AppColors.highlight,
                              ),
                            );
                          }),
                      const SizedBox(width: 7),
                      Icon(Icons.cached_rounded,
                          size: 18, color: AppColors.highlight)
                    ],
                  ))
              // IconButton(
              //     onPressed: () =>
              //     icon: const Icon(Icons.power_off))
              // auth.currentUser!.isAnonymous
              //     ? const SizedBox(width: 20)
              //     : IconButton(
              //         onPressed: () => modal.showModalBottomSheet(
              //               withPadding: false,
              //               context: context,
              //               content: ProfileModal(),
              //             ),
              //         icon: const Icon(Icons.account_circle_rounded))
            ],
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return AnimatedOpacity(
            opacity: state.showButton ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 70, left: 20, right: 20),
              child: CustomSubmitButton(
                  onPressedAction: () =>
                      Navigator.pushNamed(context, AppRoutes.cart),
                  label: "Continuar",
                  loading_label: "",
                  loading: false),
            ),
          );
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
                          return BlocBuilder<HomeCubit, HomeState>(
                            builder: (context, state) {
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
                                  return GestureDetector(
                                    onTap: () => context
                                        .read<HomeCubit>()
                                        .fetchItemsByRestaurants(
                                            item?.id ?? "", true),
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        decoration: BoxDecoration(
                                            boxShadow: state.category ==
                                                    item?.id
                                                ? [
                                                    BoxShadow(
                                                        blurRadius: 15,
                                                        spreadRadius: 0.5,
                                                        // offset: O,
                                                        color: AppColors
                                                            .highlight
                                                            .withOpacity(0.4))
                                                  ]
                                                : null,
                                            color: state.category == item?.id
                                                ? AppColors.highlight
                                                : Colors.white,
                                            border: state.category == item?.id
                                                ? null
                                                : Border.fromBorderSide(
                                                    BorderSide(
                                                        color: Colors
                                                            .grey.shade300)),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Center(
                                          child: Text(
                                            item?.get("name"),
                                            style: AppTextStyles.medium(
                                              16,
                                              color: state.category == item?.id
                                                  ? Colors.white
                                                  : Colors.grey.shade500,
                                            ),
                                          ),
                                        )),
                                  );
                                },
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
        var data = state.menu;

        if (data.isNotEmpty) {
          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  mainAxisExtent: 160),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              // itemCount: data.length + (state.listIsLastPage ? 0 : 3),
              itemCount: data.length,
              itemBuilder: (BuildContext ctx, index) {
                if (data.length <= index && state.listIsLastPage) {
                  return Transform.scale(
                      scale: 0.9, child: const CardSkeleton());
                } else {
                  var item = Item.fromMap(data[index]);
                  var id = data[index]["id"];
                  item = item.copyWith(id: id);

                  return GestureDetector(
                      onTap: () => modal.showIOSModalBottomSheet(
                          context: context,
                          content: ItemScreen(
                              order: OrderModel(item: item, observations: ""))),
                      child: CardItemWidget(
                        // ns: ns,
                        item: item,
                      ));
                }
              });
        }
        return const Center(
          child: Text("Cardapio vazio"),
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
                            order: OrderModel(item: item, observations: ""))),
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
