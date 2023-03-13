import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snacks_app/components/custom_submit_button.dart';
import 'package:snacks_app/core/app.routes.dart';

import 'package:snacks_app/core/app.text.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    Key? key,
    required this.title,
    this.description,
    this.feedback = false,
    required this.backButton,
  }) : super(key: key);

  final String title;
  final String? description;
  final bool feedback;
  final bool backButton;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: backButton
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(60.0),
                  child: Container(
                    padding:
                        const EdgeInsets.only(top: 15, left: 20, right: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.home);
                            },
                            icon: const Icon(
                              Icons.cancel_rounded,
                              color: Colors.black,
                              size: 30,
                            ))
                        // ElevatedButton(
                        //     onPressed: () {
                        //       Navigator.pop(context);
                        //       Navigator.pushReplacementNamed(
                        //           context, AppRoutes.home);
                        //     },
                        //     style: ElevatedButton.styleFrom(
                        //         shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(12)),
                        //         primary: const Color(0xffF6F6F6),
                        //         padding: EdgeInsets.zero,
                        //         minimumSize: const Size(41, 41)),
                        //     child: const Icon(
                        //       Icons.cancel_rounded,
                        //       color: Colors.black,
                        //       size: 19,
                        //     )),
                      ],
                    ),
                  ),
                )
              : null,
          bottomNavigationBar: feedback
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    height: 130,
                    child: Column(
                      children: [
                        Text(
                          "Enquanto isso que tal nos falar o que tá\n achando do snacks?",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.light(15,
                              color: const Color(0xff8391A1)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomSubmitButton(
                            onPressedAction: () {
                              // Navigator.pop(context);
                              Navigator.pushNamed(context, AppRoutes.feedback);
                            },
                            label: "Avaliar snacks",
                            loading_label: "",
                            loading: false)
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(
                    "assets/icons/snacks.svg",
                    color: Colors.black.withOpacity(0.15),
                    width: 150,
                  ),
                ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/icons/success_mark.png"),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.semiBold(26,
                        color: const Color(0xff1E232C)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (description != null)
                    Text(
                      description!,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.medium(15,
                          color: const Color(0xff8391A1)),
                    ),
                ],
              ),
            ),
          )),
    );
  }
}
