import 'dart:math';

import "package:flutter/material.dart";
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:snacks_app/core/app.colors.dart';
import 'package:snacks_app/core/app.images.dart';
import 'package:snacks_app/core/app.routes.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/models/order_model.dart';
import 'package:snacks_app/utils/enums.dart';
import 'package:snacks_app/utils/format.dart';
import 'package:snacks_app/utils/modal.dart';
import 'package:snacks_app/views/authentication/state/auth_state.dart';
import 'package:snacks_app/views/home/widgets/bottom_bar_widget.dart';
import 'package:snacks_app/views/home/item_screen.dart';
import 'package:snacks_app/views/home/orders_screen.dart';
import 'package:snacks_app/views/home/state/cart_state/cart_cubit.dart';
import 'package:snacks_app/views/home/state/home_state/home_cubit.dart';
import 'package:snacks_app/views/home/widgets/card_item.dart';
import 'package:snacks_app/views/home/widgets/modals/content_payment_ok.dart';
import 'package:snacks_app/views/home/widgets/modals/modal_content_obs.dart';
import 'package:snacks_app/views/home/widgets/profile_modal.dart';
import 'package:snacks_app/views/home/widgets/skeletons.dart';
// import 'package:snacks_app/views/home/state/cart_state/cart_state.dart';
// import 'package:snacks_app/views/restaurant_menu/new_item_screen.dart';

import '../../models/item_model.dart';
import 'widgets/bottom_bar_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late int currentPage;
  late TabController tabController;

  List<Widget> screens = [
    HomeScreenWidget(),
    // NewItemScreen(),
    const OrdersScreen()
  ];
  @override
  void initState() {
    currentPage = 0;
    tabController = TabController(length: screens.length, vsync: this);
    tabController.animation!.addListener(
      () {
        final value = tabController.animation!.value.round();
        if (value != currentPage && mounted) {
          changePage(value);
        }
      },
    );

    super.initState();
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    print("scroll dispose");
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BottomBar(
        key: UniqueKey(),
        currentPage: currentPage,
        tabController: tabController,
        selectedColor: Colors.black,
        unselectedColor: Colors.black26,
        barColor: Colors.white.withOpacity(0.9),
        barSize: MediaQuery.of(context).size.width * 0.8,
        items: const [
          {"title": "Home", "icon": Icons.home_rounded},
          // {"title": "Menu", "icon": Icons.add_rounded},
          {"title": "Pedidos", "icon": Icons.receipt_rounded}
        ],
        start: 5,
        end: 2,
        child: TabBarView(
            controller: tabController,
            dragStartBehavior: DragStartBehavior.down,
            physics: const NeverScrollableScrollPhysics(),
            children: screens),
      ),
    );
  }
}

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  late ScrollController controller;
  final key = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    controller = InheritedDataProvider.of(context).scrollController;
    controller.addListener(
      () {
        if (controller.position.maxScrollExtent == controller.offset &&
            !context.read<HomeCubit>().state.listIsLastPage) {
          context.read<HomeCubit>().fetchMoreItems();
          // Get.find<ItemController>()
          //     .addItem(Get.find<ItemController>().itemList.length);
        }
      },
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // controller.dispose();
    print("dispose item");
    // TODO: implement dispose
    super.dispose();
  }

  final modal = AppModal();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: Container(
          padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
          // color: Colors.black.withOpacity(.8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 20,
              ),
              SvgPicture.asset(
                AppImages.snacks,
                width: 140,
              ),
              IconButton(
                  onPressed: () => modal.showModalBottomSheet(
                        withPadding: false,
                        context: context,
                        content: const ProfileModal(),
                      ),
                  icon: const Icon(Icons.account_circle_rounded))
            ],
          ),
        ),
      ),
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
              Text(
                'Itens populares',
                style: AppTextStyles.medium(18),
              ),
              const SizedBox(
                height: 15,
              ),
              const PopularItemsWidget(),
              const SizedBox(
                height: 25,
              ),
              Text(
                'Cardápio',
                style: AppTextStyles.medium(18),
              ),
              const SizedBox(
                height: 10,
              ),
              AllItemsWidget(),
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
  AllItemsWidget({Key? key}) : super(key: key);

  final modal = AppModal();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, snapshot) {
      if (snapshot.status == AppStatus.loading) {
        return const ListSkeletons(direction: Axis.vertical);
      }
      return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              mainAxisExtent: 160),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.items.length + (snapshot.listIsLastPage ? 0 : 3),
          itemBuilder: (BuildContext ctx, index) {
            if (snapshot.items.length <= index && !snapshot.listIsLastPage) {
              return Transform.scale(scale: 0.9, child: const CardSkeleton());
            } else {
              var item = snapshot.items[index];
              return GestureDetector(
                  onTap: () => modal.showIOSModalBottomSheet(
                      context: context,
                      content: ItemScreen(
                          order: Order(item: item, observations: ""))),
                  child: CardItemWidget(
                    item: item,
                  ));
            }
          });
    });
  }
}

class PopularItemsWidget extends StatelessWidget {
  const PopularItemsWidget({Key? key}) : super(key: key);

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
                            order: Order(item: item, observations: ""))),
                    child: CardItemWidget(
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
