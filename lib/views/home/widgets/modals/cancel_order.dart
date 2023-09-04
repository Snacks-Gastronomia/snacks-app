// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../components/custom_submit_button.dart';

class CancelOrder extends StatelessWidget {
  String partCode;
  CancelOrder({
    Key? key,
    required this.partCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    alignment: Alignment.centerRight,
                    onPressed: () => Navigator.pop(context, false),
                    icon: const Icon(CupertinoIcons.clear_circled)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  const Text(
                    'Tem certeza que deseja cancelar o pedido',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '#$partCode ?',
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4587FF)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            CustomSubmitButton(
              loading_label: '',
              onPressedAction: () {
                Navigator.pop(context, true);
              },
              label: 'Cancelar Pedido',
              loading: false,
            ),
            const SizedBox(
              height: 35,
            )
          ],
        ));
  }
}
