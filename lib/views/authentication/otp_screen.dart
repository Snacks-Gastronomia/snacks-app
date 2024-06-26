import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snacks_app/core/app.routes.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/utils/toast.dart';
import 'package:snacks_app/views/authentication/state/auth_cubit.dart';
import 'package:snacks_app/views/authentication/widgets/pin_input.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late final toast;

  final _scaffoldKey = GlobalKey();

  final focusNode = FocusNode();
  final textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    toast = AppToast();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    focusNode.dispose();
    textController.dispose();
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<AuthCubit>(context),
      child: Builder(builder: (context) {
        return SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () => Navigator.pop(
                            _scaffoldKey.currentContext ?? context),
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
                    'Verificação OTP',
                    style: AppTextStyles.semiBold(25,
                        color: const Color(0xff1E232C)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Preencha com o código de verificação que enviamos para o número ${context.read<AuthCubit>().state.phone!}',
                    style: AppTextStyles.regular(16,
                        color: const Color(0xff838BA1)),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                      child: FilledRoundedPinPut(
                    controller: textController,
                    focusNode: focusNode,
                    onCompleted: (pin) async {
                      final navigator =
                          Navigator.of(_scaffoldKey.currentContext ?? context);
                      var result = await BlocProvider.of<AuthCubit>(
                              _scaffoldKey.currentContext ?? context)
                          .otpVerification(pin);

                      if (result != null) {
                        bool hasUser =
                            // ignore: use_build_context_synchronously
                            await context.read<AuthCubit>().checkUser();
                        if (hasUser) {
                          navigator.pushNamedAndRemoveUntil(
                              AppRoutes.home, (route) => false);
                        } else {
                          navigator.pushNamedAndRemoveUntil(
                              AppRoutes.addName, (route) => false);
                        }
                      }
                    },
                  )),
                  const Spacer(),
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        var res =
                            await context.read<AuthCubit>().sendOTPValidation();

                        if (res) {
                          // ignore: use_build_context_synchronously
                          toast.showToast(
                              context: _scaffoldKey.currentContext ?? context,
                              content: "Código enviado!",
                              type: ToastType.info);
                        }
                      },
                      child: RichText(
                        text: TextSpan(
                            text: 'Não recebeu o código? ',
                            style: AppTextStyles.medium(15),
                            children: [
                              TextSpan(
                                text: 'Reenvie',
                                style: AppTextStyles.semiBold(15,
                                    color: const Color(0xff35C2C1)),
                              ),
                            ]),
                      ),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () =>
                          Navigator.pop(_scaffoldKey.currentContext ?? context),
                      child: Text(
                        'Enviar para outro número',
                        style: AppTextStyles.semiBold(15,
                            color: const Color(0xff35C2C1)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
