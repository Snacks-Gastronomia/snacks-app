import 'package:flutter/material.dart';

import 'package:snacks_app/core/app.text.dart';

class ConfirmAddressModal extends StatelessWidget {
  const ConfirmAddressModal({
    Key? key,
    required this.address,
    required this.onSubmit,
  }) : super(key: key);
  final String address;
  final VoidCallback onSubmit;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Icon(Icons.location_on_outlined, size: 100),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              address,
              textAlign: TextAlign.center,
              style: AppTextStyles.regular(16),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: Colors.black,
                fixedSize: const Size(double.maxFinite, 59)),
            child: Text(
              'Adicionar',
              style: AppTextStyles.regular(16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
