import 'package:flutter/material.dart';
import 'package:snacks_app/core/app.text.dart';

// class CustomSnackbar extends StatelessWidget {
//   const CustomSnackbar({
//     Key? key,
//     required this.color,
//     required this.background,
//     required this.icon,
//     required this.content,
//   }) : super(key: key);
//   final Color color;
//   final Color background;
//   final Widget icon;
//   final String content;
//   @override
//   SnackBar build(BuildContext context) {
//     return SnackBar(
//       shape: const StadiumBorder(),
//       margin: const EdgeInsets.all(10),
//       behavior: SnackBarBehavior.floating,
//       // action: SnackBarAction(
//       //   label: "fechar",
//       //   textColor: Colors.blue,
//       //   onPressed: () {
//       //     print("SnackBar was closed!");
//       //   },
//       // ),
//       content: Row(
//         children: [
//           const Icon(
//             Icons.warning_rounded,
//             color: Colors.white,
//           ),
//           const SizedBox(
//             width: 15,
//           ),
//           Text(content),
//         ],
//       ),
//     );
//   }
// }

class AppSnackbar {
  showSnackbar({required context, content, color, background, icon}) =>
      ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
          content: content, background: background, color: color, icon: icon));

  SnackBar customSnackBar(
      {required color, required background, required icon, required content}) {
    return SnackBar(
      shape: const StadiumBorder(),
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      behavior: SnackBarBehavior.floating,
      // action: SnackBarAction(
      //   label: "fechar",
      //   textColor: Colors.blue,
      //   onPressed: () {
      //     print("SnackBar was closed!");
      //   },
      // ),
      duration: const Duration(milliseconds: 800),
      backgroundColor: background,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon ?? const SizedBox(),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: Text(
            content,
            style: AppTextStyles.regular(16, color: color),
          )),
        ],
      ),
    );
  }
}
 // SnackBar(
    //   backgroundColor: Colors.black,
    //   content: Text(
    //     content,
    //     style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
    //   ),
    // );