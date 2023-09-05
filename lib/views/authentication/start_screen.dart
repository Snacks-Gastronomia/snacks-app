import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snacks_app/core/app.images.dart';
import 'package:snacks_app/core/app.routes.dart';

import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/services/firebase/custom_token_auth.dart';
import 'package:snacks_app/utils/enums.dart';
import 'package:snacks_app/utils/modal.dart';
import 'package:snacks_app/utils/toast.dart';
import 'package:snacks_app/views/authentication/state/auth_cubit.dart';
import 'package:snacks_app/views/authentication/state/auth_state.dart';
import 'package:snacks_app/views/splash/loading_screen.dart';

import '../home/widgets/modals/content_payment_failed.dart';

class StartScreen extends StatelessWidget {
  StartScreen({Key? key}) : super(key: key);
  final auth = FirebaseCustomTokenAuth();
  final toast = AppToast();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
        toast.init(context: context);
        return LoadingPage(
          loading: state.status == AppStatus.loading,
          text: "Bem vindo ao snacks",
          backgroundPage: Material(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 40, top: 10),
              child: Column(
                children: [
                  const Spacer(),
                  SizedBox(
                    width: double.maxFinite,
                    height: 200,
                    child: SvgPicture.asset("assets/icons/snacks_shadowns.svg"),
                  ),
                  const Spacer(),
                  CustomButton(
                      icon: AppImages.utensils,
                      action: () async {
                        var navigator = Navigator.of(context);
                        navigator.pushNamed(AppRoutes.home);
                      },
                      dark: true,
                      title: "Está no snacks?",
                      description: "Continue para ver o cardápio"),
                  const SizedBox(
                    height: 15,
                  ),
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: context.read<AuthCubit>().getFeatureDelivery(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data?.data();
                          bool value = data?["active"] ?? false;

                          if (value) {
                            return CustomButton(
                                icon: Icons.login_rounded,
                                action: () => Navigator.pushNamed(
                                    context, AppRoutes.phoneAuth),
                                title: "Delivery",
                                description: "Entre na plataforma");
                          }
                        }
                        return const SizedBox();
                      }),
                  TextButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.home),
                    label: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Color(0xff35C2C1),
                      size: 12,
                    ),
                    icon: Text(
                      "Ou veja o cardápio",
                      style: AppTextStyles.light(12,
                          color: const Color(0xff35C2C1)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.action,
    this.dark = false,
  }) : super(key: key);

  final String title;
  final String description;
  final dynamic icon;
  final VoidCallback action;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Ink(
        width: double.maxFinite,
        height: 109,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
            border: dark
                ? null
                : const Border.fromBorderSide(BorderSide(color: Colors.grey)),
            color: dark ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            if (icon is IconData)
              Icon(
                icon,
                size: 65,
                color: dark ? Colors.white : Colors.black,
              )
            else
              SvgPicture.asset(icon),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTextStyles.semiBold(24,
                      color: dark ? Colors.white : Colors.black),
                ),
                Text(description,
                    style: AppTextStyles.regular(14,
                        color: dark ? Colors.white : Colors.black)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
