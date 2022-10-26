import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:snacks_app/core/app.colors.dart';
import 'package:snacks_app/core/app.images.dart';
import 'package:snacks_app/core/app.routes.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/models/order_model.dart';
import 'package:snacks_app/utils/enums.dart';
import 'package:snacks_app/utils/modal.dart';
import 'package:snacks_app/views/home/home_widget.dart';
import 'package:snacks_app/views/home/item_screen.dart';
import 'package:snacks_app/views/home/orders_screen.dart';
import 'package:snacks_app/views/home/state/cart_state/cart_cubit.dart';
import 'package:snacks_app/views/home/state/home_state/home_cubit.dart';
import 'package:snacks_app/views/home/widgets/bottom_bar_widget.dart';
import 'package:snacks_app/views/home/widgets/card_item.dart';
import 'package:snacks_app/views/home/widgets/profile_modal.dart';
import 'package:snacks_app/views/home/widgets/skeletons.dart';

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
    const HomeScreenWidget(),
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
