import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AppModal {
  showModalBottomSheet({
    required context,
    required Widget content,
    bool withPadding = true,
    bool drag = true,
    bool dimisible = true,
  }) =>
      showMaterialModalBottomSheet(
        // useRootNavigator: false,
        bounce: true,
        isDismissible: dimisible,
        context: context,
        enableDrag: drag,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        builder: (context) => SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: ModalWidget(
              content: content, paddingBottom: withPadding ? 20 : 0),
        ),
      );
  showIOSModalBottomSheet(
          {required context,
          required Widget content,
          bool expand = false,
          bool drag = true}) =>
      showCupertinoModalBottomSheet(
        context: context,
        // useRootNavigator: false,
        bounce: true,
        enableDrag: drag,
        expand: expand,
        builder: (context) => ModalWidget(content: content, paddingBottom: 0),
      );
}

class ModalWidget extends StatelessWidget {
  const ModalWidget({
    Key? key,
    required this.content,
    required this.paddingBottom,
  }) : super(key: key);
  final Widget content;
  final double paddingBottom;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: paddingBottom),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: content,
    );
  }
}
