import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:snacks_app/core/app.images.dart';
import 'package:snacks_app/core/app.routes.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/services/beerpass_service.dart';
import 'package:snacks_app/services/firebase/database.dart';
import 'package:snacks_app/utils/enums.dart';
import 'package:snacks_app/utils/modal.dart';
import 'package:snacks_app/views/home/state/cart_state/cart_cubit.dart';
import 'package:snacks_app/views/home/widgets/modals/content_payment_failed.dart';
import 'package:snacks_app/views/home/widgets/modals/content_payment_ok.dart';
import 'package:snacks_app/views/home/widgets/modals/money_change_option.dart';
import 'package:snacks_app/views/splash/loading_screen.dart';
import 'package:snacks_app/views/success/success_screen.dart';

class PaymentScreen extends StatefulWidget {
  PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final beerpassService = BeerPassService();

  final auth = FirebaseAuth.instance;

  final modal = AppModal();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void action(context, method) async {
    String description = "";
    bool change = false;

    if (method == "Dinheiro") {
      var res = await modal.showModalBottomSheet(
          context: context,
          drag: false,
          content: const MoneyChangeOptionModal());
      change = res;
    }
    if (auth.currentUser?.isAnonymous != null &&
        auth.currentUser!.isAnonymous) {
      if (method == "Cartão snacks") {
        description =
            "Seu está sendo preparado e logo será entregue em sua mesa. :-)";
      } else {
        description =
            'Em breve o garçom será direcionado até sua mesa para finalizar o pagamento. :-)';
      }
    } else {
      description =
          'Seu está sendo preparado e logo sairá para entrega ao seu endereço.\n'
          ' O entregador levará a maquininha para que você possa realizar o pagamento. ;-)';
    }

    BlocProvider.of<CartCubit>(context).makeOrder(method, change: change);
    await modal.showIOSModalBottomSheet(
        context: context,
        drag: false,
        content: SuccessScreen(
            feedback: true,
            title: "Pedido realizado!",
            backButton: true,
            description: description));
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.home, ModalRoute.withName(AppRoutes.start));
  }

  @override
  Widget build(BuildContext context) {
    getModal(String name, double v1, double v2) {}
    return SafeArea(
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          return LoadingPage(
              loading: state.status == AppStatus.loading,
              text: "Realizando o pagamento",
              backgroundPage: Scaffold(
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(60.0),
                  child: Container(
                    padding:
                        const EdgeInsets.only(top: 15, left: 20, right: 20),
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
                      ],
                    ),
                  ),
                ),
                body: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pagamento',
                          style: AppTextStyles.medium(20),
                        ),
                        const SizedBox(
                          height: 10,
                          // height: 41,
                        ),
                        Text(
                          'Escolha o melhor metodo de pagamento para voce. ;-)',
                          style: AppTextStyles.medium(16,
                              color: const Color(0xff8391A1)),
                        ),
                        const SizedBox(
                          height: 40,
                          // height: 41,
                        ),
                        GestureDetector(
                          onTap: () =>
                              action(context, "Cartão de crédito/débito"),
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xffF7F8F9),
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.credit_card_rounded),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Cartão de crédito/débito'),
                                  ],
                                ),
                                const Icon(Icons.arrow_forward)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () => action(context, "Dinheiro"),
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xffF7F8F9),
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.attach_money_rounded),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Dinheiro'),
                                  ],
                                ),
                                const Icon(Icons.arrow_forward)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () => action(context, "Pix"),
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xffF7F8F9),
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.pix_rounded),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Pix'),
                                  ],
                                ),
                                const Icon(Icons.arrow_forward)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        if (auth.currentUser?.isAnonymous != null &&
                            auth.currentUser!.isAnonymous)
                          GestureDetector(
                            onTap: () async {
                              var cubit = context.read<CartCubit>();
                              // var navigator
                              double orderValue = cubit.state.total;
                              dynamic dataStorage = cubit.getStorage;
                              final card_code = await Navigator.pushNamed(
                                  context, AppRoutes.scanCard);

                              cubit.changeStatus(AppStatus.loading);
                              var card = await beerpassService
                                  .getCard(card_code.toString());
                              if (card != null) {
                                double cardBudget =
                                    double.parse(card["saldo"].toString());

                                if (orderValue <= cardBudget - 5) {
                                  double result = cardBudget - orderValue;
                                  try {
                                    await beerpassService.payWithSnacksCard(
                                        card_code.toString(), orderValue);

                                    // action(context, "Cartão snacks");
                                    cubit.changeStatus(AppStatus.loaded);
                                    modal.showModalBottomSheet(
                                        context: context,
                                        content: Builder(builder: (context) {
                                          return PaymentSuccessContent(
                                              customer: card["nome"],
                                              order_value:
                                                  NumberFormat.currency(
                                                          locale: "pt",
                                                          symbol: r"R$ ")
                                                      .format(orderValue),
                                              rest_value: NumberFormat.currency(
                                                      locale: "pt",
                                                      symbol: r"R$ ")
                                                  .format(result),
                                              action: () => action(
                                                  context, "Cartão Snacks"));
                                        }));
                                  } catch (e) {
                                    print(e);
                                  }
                                } else {
                                  // cubit.changeStatus(AppStatus.loaded);
                                  modal.showModalBottomSheet(
                                      context: context,
                                      content: PaymentFailedContent(
                                        value: NumberFormat.currency(
                                                locale: "pt", symbol: r"R$ ")
                                            .format(cardBudget),
                                      ));
                                }
                              } else {
                                modal.showModalBottomSheet(
                                    context: context,
                                    content: const PaymentFailedContent(
                                      readError: true,
                                      value: "",
                                    ));
                              }
                              cubit.changeStatus(AppStatus.loaded);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppImages.snacks_logo,
                                        color: Colors.white,
                                        width: 30,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Cartão snacks',
                                        style: AppTextStyles.medium(14,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                      ],
                    )),
              ));
        },
      ),
    );
  }
}
