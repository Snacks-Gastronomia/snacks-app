import 'package:flutter/material.dart';

import 'package:snacks_app/core/app.text.dart';

class CustomSubmitButton extends StatelessWidget {
  const CustomSubmitButton({
    Key? key,
    required this.onPressedAction,
    required this.label,
    required this.loading_label,
    required this.loading,
    this.dark_theme = true,
  }) : super(key: key);

  final VoidCallback onPressedAction;
  final String label;
  final String loading_label;
  final bool loading;
  final bool dark_theme;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressedAction,
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: dark_theme ? Colors.black : Colors.white,
          fixedSize: const Size(double.maxFinite, 59)),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (loading)
            const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                  backgroundColor: Colors.white30,
                )),
          // const SizedBox(
          //   width: 5,
          // ),
          Spacer(),
          Text(
            loading ? loading_label : label,
            style: AppTextStyles.regular(16,
                color: dark_theme ? Colors.white : Colors.black),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
