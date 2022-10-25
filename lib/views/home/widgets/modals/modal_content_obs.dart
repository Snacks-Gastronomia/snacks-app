import 'package:flutter/material.dart';
import 'package:snacks_app/core/app.text.dart';

class ModalContentObservation extends StatelessWidget {
  const ModalContentObservation(
      {Key? key, required this.action, required this.onChanged, this.value})
      : super(key: key);

  final VoidCallback action;
  final Function(String) onChanged;
  final String? value;

  @override
  Widget build(BuildContext context) {
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
            'Deseja adicionar alguma observação?',
            style: AppTextStyles.medium(18),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            style: AppTextStyles.medium(16, color: const Color(0xff8391A1)),
            onChanged: onChanged,
            maxLines: 3,
            initialValue: value,
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
              hintText: 'Ex.: Tirar maionse',
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: action,
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                primary: Colors.black,
                fixedSize: const Size(double.maxFinite, 59)),
            child: Text(
              'Adicionar pedido',
              style: AppTextStyles.regular(16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
