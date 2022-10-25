import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snacks_app/core/app.text.dart';

class RestaurantAuthenticationScreen extends StatelessWidget {
  const RestaurantAuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        primary: Colors.white,
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
        // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisSize: MainAxisSize.max,
              children: [
                // const SizedBox(
                //   height: 50,
                // ),
                // const Spacer(),
                SizedBox(
                  width: double.maxFinite,
                  height: 200,
                  child:
                      SvgPicture.asset("assets/icons/snacks_shadown_dark.svg"),
                ),

                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 300,
                  // width: 300,
                  child: PageView(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Restaurante?',
                              style: AppTextStyles.semiBold(24,
                                  color: Colors.white)),
                          const SizedBox(
                            height: 10,
                          ),
                          Text('Digite o codigo de acesso',
                              style: AppTextStyles.regular(14,
                                  color: Colors.white70)),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            style: AppTextStyles.medium(16,
                                color: Color(0xff8391A1)),
                            decoration: InputDecoration(
                              fillColor: Colors.white30,
                              filled: true,
                              hintStyle: AppTextStyles.medium(16,
                                  color: Color(0xff8391A1).withOpacity(0.5)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Colors.white30, width: 1)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 1)),
                              hintText: 'xxxxxxx',
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                primary: Colors.white,
                                fixedSize: const Size(double.maxFinite, 59)),
                            child: Text(
                              'Continuar',
                              style: AppTextStyles.regular(16,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Digite a senha de segurança',
                              style: AppTextStyles.semiBold(24,
                                  color: Colors.white)),
                          const SizedBox(
                            height: 10,
                          ),
                          // Text('Digite o codigo de acesso',
                          //     style: AppTextStyles.regular(14,
                          //         color: Colors.white70)),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            style: AppTextStyles.medium(16,
                                color: Color(0xff8391A1)),
                            decoration: InputDecoration(
                              fillColor: Colors.white30,
                              filled: true,
                              hintStyle: AppTextStyles.medium(16,
                                  color: Color(0xff8391A1).withOpacity(0.5)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Colors.white30, width: 1)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 1)),
                              hintText: 'xxxxxxx',
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                primary: Colors.white,
                                fixedSize: const Size(double.maxFinite, 59)),
                            child: Text(
                              'Entrar',
                              style: AppTextStyles.regular(16,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
                // PageView(controller: PageController(initialPage: 0), children: [
              ],
            ),
          ),
        ),
      ),
    );
  }
}
