import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snacks_app/core/app.images.dart';
import 'package:snacks_app/core/app.routes.dart';
import 'package:snacks_app/core/app.text.dart';

class ProfileModal extends StatelessWidget {
  ProfileModal({Key? key}) : super(key: key);
  final auth = FirebaseAuth.instance;
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Column(
                //   children: [

                //   ],
                // ),
                SizedBox(
                  width: 200,
                  child: Text(
                    'Rua xxx xxx xxxx, 80, Centro, São Paulo',
                    style: AppTextStyles.light(17, color: Colors.white),
                  ),
                ),
                Center(
                  child: IconButton(
                      onPressed: () async => await auth.signOut(),
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 30,
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(
            color: Colors.white12,
          ),
          Center(
            child: TextButton.icon(
              onPressed: () async {
                await auth.signOut().then((value) =>
                    Navigator.pushReplacementNamed(context, AppRoutes.start));
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
        ],
      ),
    );
  }
}
