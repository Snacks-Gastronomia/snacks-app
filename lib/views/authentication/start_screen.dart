import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snacks_app/core/app.routes.dart';

import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/services/firebase/custom_token_auth.dart';
import 'package:snacks_app/utils/enums.dart';
import 'package:snacks_app/views/authentication/state/auth_cubit.dart';
import 'package:snacks_app/views/authentication/state/auth_state.dart';
import 'package:snacks_app/views/splash/loading_screen.dart';

class StartScreen extends StatelessWidget {
  StartScreen({Key? key}) : super(key: key);
  final auth = FirebaseCustomTokenAuth();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
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
                      icon: Icons.qr_code_scanner_rounded,
                      action: () async {
                        var navigator = Navigator.of(context);
                        var cubit = context.read<AuthCubit>();
                        var permission = await Permission.camera.request();
                        if (permission.isGranted) {
                          final code =
                              await navigator.pushNamed(AppRoutes.scanQrCode);
                          cubit.changeStatus(AppStatus.loading);
                          try {
                            int? table = int.tryParse(code.toString());
                            if (table != null && (table >= 1 && table <= 100)) {
                              var user =
                                  await auth.signIn(table: code.toString());

                              if (user != null) {
                                cubit.changeStatus(AppStatus.loaded);
                                navigator.pushNamedAndRemoveUntil(
                                    AppRoutes.home,
                                    ModalRoute.withName(AppRoutes.start));
                              }
                            } else {
                              cubit.changeStatus(AppStatus.loaded);
                            }
                          } catch (e) {
                            print(e);
                          }
                        }
                      },
                      dark: true,
                      title: "Está no snacks?",
                      description: "Escaneie o QrCode"),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomButton(
                      icon: Icons.login_rounded,
                      action: () =>
                          Navigator.pushNamed(context, AppRoutes.phoneAuth),
                      title: "Delivery",
                      description: "Entre na plataforma")
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
  final IconData icon;
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
            Icon(
              icon,
              size: 65,
              color: dark ? Colors.white : Colors.black,
            ),
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
