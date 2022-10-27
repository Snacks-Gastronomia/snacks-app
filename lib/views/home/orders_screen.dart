import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import 'package:snacks_app/core/app.text.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Container(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Row(
              children: [
                Text(
                  'Meus pedidos',
                  style: AppTextStyles.medium(20),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Column(
            children: [
              TabarBar(
                page1: ListView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                  physics: const BouncingScrollPhysics(),
                  itemCount: 5,
                  shrinkWrap: true,
                  itemBuilder: (_, index) => const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: CardOrderWidget(
                        leading: 42,
                        additional: "",
                        status: "Aguardando pagamento",
                        total: 200,
                        method: "Cartão de crédito",
                        items: []),
                  ),
                ),
                page2: ListView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                  physics: const BouncingScrollPhysics(),
                  itemCount: 3,
                  shrinkWrap: true,
                  itemBuilder: (_, index) => const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: CardOrderWidget(
                        leading: 42,
                        additional: "",
                        status: "Aguardando pagamento",
                        total: 200,
                        method: "Cartão de crédito",
                        items: []),
                  ),
                ),
                onChange: (p0) {},
              )
            ],
          ),
        ));
  }
}

class CardOrderWidget extends StatelessWidget {
  final bool isTable;
  final int leading;
  final String additional;
  final String status;
  final int total;
  final String method;
  final List items;

  const CardOrderWidget({
    Key? key,
    this.isTable = false,
    required this.leading,
    required this.additional,
    required this.status,
    required this.total,
    required this.method,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        initialExpanded: true,
        child: Stack(children: [
          Card(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: const Color(0xffF6F6F6),
            // color: Color(0xffF6F6F6),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 15, right: 20),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '#$leading',
                        style: AppTextStyles.bold(52,
                            color: const Color(0xff263238)),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            method,
                            style: AppTextStyles.regular(16,
                                color: const Color(0xff979797)),
                          ),
                          Text(
                            'R\$ $total',
                            style: AppTextStyles.semiBold(16,
                                color: const Color(0xff979797)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                      tapBodyToExpand: false,
                      hasIcon: false,
                    ),
                    header: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey,
                              size: 16,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Ver detalhes",
                              style: AppTextStyles.regular(12,
                                  color: Colors.grey.shade600),
                            ),
                          ],
                        )
                      ],
                    ),
                    collapsed: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                      width: 18,
                                      height: 23,
                                      // padding: EdgeInsets.symmetric(
                                      //     horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.black),
                                      child: Center(
                                        child: Text(
                                          '1',
                                          style: AppTextStyles.regular(14,
                                              color: Colors.white),
                                        ),
                                      )),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Bugger chedar',
                                        style: AppTextStyles.regular(14),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          "loremIpsum",
                                          style: AppTextStyles.regular(12,
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Text(
                                'R\$ 20,00',
                                style: AppTextStyles.regular(14),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    expanded: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[],
                    ),
                    builder: (_, collapsed, expanded) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          theme: const ExpandableThemeData(
                              crossFadePoint: 0, hasIcon: false, iconSize: 0),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  color: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Center(
                    child: Text(
                      status,
                      style: AppTextStyles.regular(14, color: Colors.white54),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6), color: Colors.black),
              child: Text(
                items.length.toString(),
                style: AppTextStyles.regular(16, color: Colors.white),
              ))
        ]));
  }
}

class TabarBar extends StatelessWidget {
  TabarBar({
    Key? key,
    required this.page1,
    required this.page2,
    required this.onChange,
  }) : super(key: key);

  final Widget page1;
  final Widget page2;
  final Function(int) onChange;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
              ),
              child: TabBar(
                onTap: onChange,

                // give the indicator a decoration (color and border radius)
                indicator: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(
                    8.0,
                  ),
                ),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black,
                tabs: const [
                  Tab(
                    text: 'Local',
                  ),
                  Tab(
                    text: 'Entrega',
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // first tab bar view widget
                  page1,
                  page2
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
