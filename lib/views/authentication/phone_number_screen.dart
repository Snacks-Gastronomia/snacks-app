import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:snacks_app/components/custom_submit_button.dart';
import 'package:snacks_app/core/app.routes.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/utils/enums.dart';
import 'package:snacks_app/utils/toast.dart';
import 'package:snacks_app/views/authentication/state/auth_cubit.dart';
import 'package:snacks_app/views/authentication/state/auth_state.dart';

class PhoneNumberScreen extends StatelessWidget {
  PhoneNumberScreen({Key? key}) : super(key: key);
  final toast = AppToast();
  GlobalKey _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Future<void> sendPhoneCodeOtp() async {
      final navigator = Navigator.of(context);
      context.read<AuthCubit>().changeStatus(AppStatus.loading);
      if (context.read<AuthCubit>().validateNumber) {
        // await sendPhoneCodeOtp();
        // final navigator = Navigator.of(context);
        // String res =
        //     await context.read<AuthCubit>().sendOTPValidation();
        // if (res.isNotEmpty)

        await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: "+55 ${context.read<AuthCubit>().state.phone}",
            verificationCompleted: (PhoneAuthCredential credential) async {
              // await FirebaseAuth.instance
              //     .signInWithCredential(credential)
              //     .then((value) async {
              //   if (value.user != null) {
              //     // Navigator.pushAndRemoveUntil(
              //     //     context,
              //     //     MaterialPageRoute(builder: (context) => Home()),
              //     //     (route) => false);
              //   }
              // });
            },
            verificationFailed: (FirebaseAuthException e) {
              print("Não foi possível enviar o código! Tente novamente.");

              // AppToast().showToast(
              //     context: context,
              //     type: ToastType.error,
              //     content: "Não foi possível enviar o código! Tente novamente.");
            },
            codeSent: (String verificationID, int? resendToken) async {
              print("code sent");
              if (verificationID.isNotEmpty) {
                context.read<AuthCubit>().changeVerificationId(verificationID);

                await navigator.pushNamed(AppRoutes.otp);
              }
            },
            codeAutoRetrievalTimeout: (String verificationID) async {
              if (verificationID.isNotEmpty) {
                print(verificationID);
                context.read<AuthCubit>().changeVerificationId(verificationID);
                await navigator.pushNamed(AppRoutes.otp);
              }
            },
            timeout: const Duration(seconds: 120));
      } else {
        toast.showToast(
            context: _scaffoldKey.currentContext,
            type: ToastType.error,
            content: "Número inválido");
        context.read<AuthCubit>().changeStatus(AppStatus.error);
      }
    }

    toast.init(context: context);

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
            return CustomSubmitButton(
                onPressedAction: () async => await sendPhoneCodeOtp(),
                label: "Enviar código",
                loading_label: "Enviando",
                loading: state.status == AppStatus.loading);
          }),
          // ElevatedButton(
          //   onPressed: () async {
          //     await sendPhoneCodeOtp();
          //   },
          //   style: ElevatedButton.styleFrom(
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(15)),
          //       primary: Colors.black,
          //       fixedSize: const Size(double.maxFinite, 59)),
          //   child: Text(
          //     'Continuar',
          //     style: AppTextStyles.regular(16, color: Colors.white),
          //   ),
          // ),
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                SvgPicture.asset(
                  "assets/icons/snacks_logo.svg",
                  height: 30,
                  color: Colors.black.withOpacity(0.1),
                )
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'Enter your phone number!',
                style: AppTextStyles.semiBold(30),
              ),
              const SizedBox(
                height: 20,
              ),
              //text 8391A1
              TextFormField(
                style: AppTextStyles.medium(16, color: const Color(0xff8391A1)),
                keyboardType: TextInputType.phone,
                onChanged: context.read<AuthCubit>().changePhone,
                inputFormatters: [
                  MaskTextInputFormatter(
                      mask: '(##) #####-####',
                      filter: {"#": RegExp(r'[0-9]')},
                      type: MaskAutoCompletionType.lazy)
                ],
                decoration: InputDecoration(
                  fillColor: const Color(0xffF7F8F9),
                  filled: true,
                  hintStyle: AppTextStyles.medium(16,
                      color: const Color(0xff8391A1).withOpacity(0.5)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Color(0xffE8ECF4), width: 1)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Color(0xffE8ECF4), width: 1)),
                  hintText: 'Ex: (xx) xxxxx-xxxx',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
