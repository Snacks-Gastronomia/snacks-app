import 'package:flutter/material.dart';

import 'package:snacks_app/core/app.text.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({
    Key? key,
    required this.loading,
    required this.text,
    required this.backgroundPage,
  }) : super(key: key);
  final bool loading;
  final String text;
  final Widget backgroundPage;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          backgroundPage,
          if (loading)
            Container(
              width: double.maxFinite,
              color: Colors.black.withOpacity(0.7),
              padding: const EdgeInsets.all(50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: AppTextStyles.semiBold(30, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      backgroundColor: Colors.white24,
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}
