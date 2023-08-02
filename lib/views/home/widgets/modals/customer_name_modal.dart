import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/views/home/state/home_state/home_cubit.dart';

class CustomerNameModal extends StatelessWidget {
  CustomerNameModal({super.key});
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
            top: 25,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Como gostaria de ser chamado?',
              style: AppTextStyles.medium(18),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              style: AppTextStyles.medium(16, color: const Color(0xff8391A1)),
              controller: controller,
              maxLines: 1,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                fillColor: const Color(0xffF7F8F9),
                filled: true,
                hintStyle: AppTextStyles.medium(16,
                    color: const Color(0xff8391A1).withOpacity(0.5)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xffE8ECF4), width: 1)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xffE8ECF4), width: 1)),
                hintText: 'Ex.: João Ricardo',
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final nav = Navigator.of(context);

                if (controller.text.isNotEmpty) {
                  await context
                      .read<HomeCubit>()
                      .setCustomerName(controller.text);

                  nav.pop();
                }
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  backgroundColor: Colors.black,
                  fixedSize: const Size(double.maxFinite, 59)),
              child: Text(
                'Enviar pedido',
                style: AppTextStyles.regular(16, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    });
  }
}
