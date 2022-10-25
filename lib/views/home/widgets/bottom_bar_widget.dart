import 'package:snacks_app/core/app.text.dart';

import './bottom_bar_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BottomBar extends StatefulWidget {
  final Widget child;
  final int currentPage;
  final TabController tabController;
  final Color selectedColor;
  final Color unselectedColor;
  final Color barColor;
  final double barSize;
  final double end;
  final double start;
  final List items;
  const BottomBar({
    required this.child,
    required this.currentPage,
    required this.tabController,
    required this.selectedColor,
    required this.unselectedColor,
    required this.barColor,
    required this.barSize,
    required this.end,
    required this.start,
    required this.items,
    Key? key,
  }) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar>
    with SingleTickerProviderStateMixin {
  ScrollController scrollBottomBarController = ScrollController();
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  bool isScrollingDown = false;
  bool isOnTop = true;

  @override
  void initState() {
    myScroll();
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, widget.end),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ))
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    _controller.forward();
  }

  void showBottomBar() {
    if (mounted) {
      setState(() {
        _controller.forward();
      });
    }
  }

  void hideBottomBar() {
    if (mounted) {
      setState(() {
        _controller.reverse();
      });
    }
  }

  Future<void> myScroll() async {
    scrollBottomBarController.addListener(() {
      if (scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          isOnTop = false;
          hideBottomBar();
        }
      }
      if (scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          isOnTop = true;
          showBottomBar();
        }
      }
    });
  }

  @override
  void dispose() {
    scrollBottomBarController.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.bottomCenter,
      children: [
        InheritedDataProvider(
          scrollController: scrollBottomBarController,
          child: widget.child,
        ),
        Positioned(
          bottom: widget.start,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            width: isOnTop == true ? 0 : 40,
            height: isOnTop == true ? 0 : 40,
            decoration: BoxDecoration(
                color: widget.barColor,
                // shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15)),
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            child: Material(
              color: Colors.transparent,
              child: SizedBox(
                height: 40,
                width: 40,
                child: Center(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      scrollBottomBarController
                          .animateTo(
                        scrollBottomBarController.position.minScrollExtent,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      )
                          .then((value) {
                        if (mounted) {
                          setState(() {
                            isOnTop = true;
                            isScrollingDown = false;
                          });
                        }
                        showBottomBar();
                      });
                    },
                    icon: Icon(
                      Icons.arrow_upward_rounded,
                      color: widget.unselectedColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: widget.start + 5,
          child: SlideTransition(
            position: _offsetAnimation,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                  width: widget.barSize,
                  decoration: BoxDecoration(
                      // color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(500),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 0),
                          spreadRadius: -2,
                          blurRadius: 15,
                          color: Color.fromRGBO(157, 157, 157, 1),
                        )
                      ]),
                  child: Material(
                    color: widget.barColor,
                    child: TabBar(
                        indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                        controller: widget.tabController,
                        // labelColor: Colors.amber,
                        padding: const EdgeInsets.all(0),
                        labelPadding: const EdgeInsets.all(0),
                        // overlayColor: MaterialStateProperty.all(Colors.amber),

                        indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                                color: getList(widget.items.length)
                                        .contains(widget.currentPage)
                                    ? widget.selectedColor
                                    : widget.unselectedColor,
                                width: 2),
                            insets: const EdgeInsets.fromLTRB(50, 0, 50, 8)),
                        tabs: [
                          for (int i = 0; i < widget.items.length; i++)
                            SizedBox(
                              height: 55,
                              // width: widget.currentPage == 1 ? 100 : 40,
                              child: Center(
                                  child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    widget.items[i]["icon"],
                                    color: widget.currentPage == i
                                        ? widget.selectedColor
                                        : widget.unselectedColor,
                                  ),
                                  if (widget.currentPage == i)
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          widget.items[i]["title"],
                                          style: AppTextStyles.regular(16,
                                              color: widget.selectedColor),
                                        )
                                      ],
                                    )
                                ],
                              )),
                            )
                        ]

                        // [
                        //   SizedBox(
                        //     height: 55,
                        //     // width: widget.currentPage == 0 ? 100 : 40,
                        //     child: Center(
                        //         child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       children: [
                        //         Icon(
                        //           Icons.home,
                        //           color: widget.currentPage == 0
                        //               ? widget.selectedColor
                        //               : widget.unselectedColor,
                        //         ),
                        //         if (widget.currentPage == 0)
                        //           Row(
                        //             children: [
                        //               const SizedBox(
                        //                 width: 10,
                        //               ),
                        //               Text(
                        //                 'Home',
                        //                 style: AppTextStyles.regular(16,
                        //                     color: widget.selectedColor),
                        //               )
                        //             ],
                        //           )
                        //       ],
                        //     )),
                        //   ),

                        // ],
                        ),
                  )),
            ),
          ),
        ),
      ],
    );
  }

  List<int> getList(int length) {
    List<int> list = [];
    for (var i = 0; i < length; i++) {
      list.add(i);
    }
    return list;
  }
}
