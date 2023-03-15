import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snacks_app/core/app.text.dart';

enum ToastType { error, info, success, custom }

class AppToast {
  FToast fToast = FToast();

  init({context}) => fToast.init(context);

  showToast(
          {required context,
          required String content,
          color,
          background,
          icon,
          required ToastType type}) =>
      fToast.showToast(
        child: customToast(
            content: content,
            background: background,
            color: color,
            icon: icon,
            type: type),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 2),
      );

  Widget customToast(
      {required color,
      required background,
      required icon,
      required content,
      required type}) {
    if (type == ToastType.info) {
      background = Colors.blue.shade100;
      color = Colors.blue.shade800;
      icon = Icon(
        Icons.info,
        color: color,
      );
    } else if (type == ToastType.success) {
      background = Colors.greenAccent;
      color = Colors.green.shade800;
      icon = Icon(
        Icons.check,
        color: color,
      );
    } else if (type == ToastType.error) {
      background = Colors.red.shade100;
      color = Colors.red.shade700;
      icon = Icon(
        Icons.error,
        color: color,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: background,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              content,
              style: AppTextStyles.regular(16, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
