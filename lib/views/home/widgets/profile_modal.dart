import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';
import 'package:snacks_app/core/app.images.dart';
import 'package:snacks_app/core/app.routes.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/services/auth_service.dart';
import 'package:snacks_app/utils/snackbar.dart';
import 'package:snacks_app/utils/toast.dart';
import 'package:snacks_app/views/home/state/home_state/home_cubit.dart';

class ProfileModal extends StatelessWidget {
  ProfileModal({Key? key}) : super(key: key);
  final auth = FirebaseAuth.instance;
  final addressService = AuthApiServices();
  final toast = AppToast();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [Colors.black, Colors.black54])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                AppImages.snacks_logo,
                height: 30,
                width: 30,
                color: Colors.white30,
              ),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.cancel_rounded,
                    color: Colors.white,
                    size: 30,
                  )),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            auth.currentUser!.displayName ?? "",
            style: AppTextStyles.bold(32, color: Colors.white),
          ),
          Text(
            auth.currentUser!.phoneNumber ?? "",
            style: AppTextStyles.regular(16, color: Colors.white),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white24, borderRadius: BorderRadius.circular(15)),
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<String?>(
                future: BlocProvider.of<HomeCubit>(context).getAddress(),
                builder: (context, snapshot) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          snapshot.data ?? "",
                          style: AppTextStyles.light(17, color: Colors.white),
                        ),
                      ),
                      Center(
                        child: IconButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await Navigator.pushNamed(
                                  context, AppRoutes.address,
                                  arguments: {
                                    // "address": snapshot.data,
                                    "uid": auth.currentUser?.uid
                                  });
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 30,
                            )),
                      ),
                    ],
                  );
                }),
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(
            color: Colors.white12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: TextButton.icon(
                  onPressed: () async {
                    await auth.signOut().then((value) =>
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.start));
                  },
                  icon: const Icon(
                    Icons.power_settings_new_rounded,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Sair",
                    style: AppTextStyles.light(18, color: Colors.white),
                  ),
                ),
              ),
              Center(
                child: TextButton.icon(
                  onPressed: () async {
                    var user = auth.currentUser;
                    if (user != null) {
                      await addressService.deleteAddress(user.uid);
                    }

                    await auth.currentUser?.delete().catchError((onError) {
                      toast.init(context: context);
                      toast.showToast(
                          context: context,
                          content:
                              "É necessário entra novamente para realizar essa ação",
                          type: ToastType.info);
                      auth.signOut().then((value) =>
                          Navigator.pushReplacementNamed(
                              context, AppRoutes.start));
                    });

                    await auth.signOut().then((value) =>
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.start));
                  },
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                  label: Text(
                    "Excluir conta",
                    style: AppTextStyles.light(18, color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
