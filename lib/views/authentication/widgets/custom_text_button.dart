import 'package:flutter/material.dart';

import '../../../core/app.text.dart';

class CustomTextButton extends StatelessWidget {
  final String route;
  const CustomTextButton({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => Navigator.pushNamed(context, route),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ou entre para pedir delivery',
              style: AppTextStyles.semiBold(16,
                  color: Colors.white.withOpacity(0.5)),
            ),
            const SizedBox(
              width: 20,
            ),
            Icon(
              Icons.arrow_forward_sharp,
              color: Colors.white.withOpacity(0.5),
            )
          ],
        ));
  }
}
