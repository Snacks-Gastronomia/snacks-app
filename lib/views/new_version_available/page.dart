import 'dart:io';

import 'package:flutter/material.dart';
import 'package:snacks_app/components/custom_submit_button.dart';
import 'package:snacks_app/core/app.colors.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:url_launcher/url_launcher.dart';

class NewVersionAvailableScreen extends StatelessWidget {
  const NewVersionAvailableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Spacer(),
            Icon(
              Icons.cloud_download_rounded,
              size: 200,
              color: AppColors.highlight,
            ),
            Text(
              'Há uma nova versão dísponivel para download!',
              textAlign: TextAlign.center,
              style: AppTextStyles.semiBold(22),
            ),
            Text(
              'Mantenha seu app atualizado para ficar por dentro das novidades. ; )',
              textAlign: TextAlign.center,
              style: AppTextStyles.light(18),
            ),
            const Spacer(),
            CustomSubmitButton(
                onPressedAction: () {
                  if (Platform.isAndroid || Platform.isIOS) {
                    final appId = Platform.isAndroid
                        ? 'com.snacks.snacks_app'
                        : '1673779987';
                    final url = Uri.parse(
                      Platform.isAndroid
                          ? "market://details?id=$appId"
                          : "https://apps.apple.com/app/id$appId",
                    );
                    launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  }
                },
                label: "Atualizar agora",
                loading_label: "",
                loading: false)
          ],
        ),
      ),
    );
  }
}
