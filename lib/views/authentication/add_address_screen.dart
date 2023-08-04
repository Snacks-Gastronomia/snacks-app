import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:snacks_app/components/custom_submit_button.dart';
import 'package:snacks_app/core/app.routes.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/utils/autcomplete.dart';
import 'package:snacks_app/utils/enums.dart';
import 'package:snacks_app/utils/modal.dart';
import 'package:snacks_app/views/authentication/state/auth_cubit.dart';
import 'package:snacks_app/views/authentication/state/auth_state.dart';
import 'package:snacks_app/views/authentication/widgets/add_number_modal.dart';
import 'package:snacks_app/views/authentication/widgets/confirm_address_modal.dart';

class AddAddressScreen extends StatelessWidget {
  AddAddressScreen({Key? key}) : super(key: key);
  final searchFocus = FocusNode();
  final modal = AppModal();
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? {}) as Map;
    final state = context.read<AuthCubit>().state;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
              return CustomSubmitButton(
                  onPressedAction: () async {
                    final navigator = Navigator.of(context);

                    if (state.district_address.isNotEmpty &&
                        state.street_address.isNotEmpty &&
                        state.number_address.isNotEmpty) {
                      if (state.status == AppStatus.editing) {
                        context
                            .read<AuthCubit>()
                            .updateAddressFromDatabase()
                            .then((value) => navigator.pop());
                      } else {
                        context.read<AuthCubit>().saveUser();
                        if (arguments.isNotEmpty && arguments["backToScreen"]) {
                          navigator.pop();
                        } else {
                          await navigator.pushNamedAndRemoveUntil(
                              AppRoutes.home,
                              ModalRoute.withName(AppRoutes.start));
                        }
                      }
                    }
                  },
                  label: "Salvar",
                  loading_label: "Salvando dados",
                  loading: state.status == AppStatus.loading);
            })),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(41, 41)),
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.black,
                      size: 19,
                    )),
                SvgPicture.asset(
                  "assets/icons/snacks_logo.svg",
                  height: 30,
                  color: Colors.black.withOpacity(0.1),
                )
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Adicione o endereço para entrega',
                  style: AppTextStyles.semiBold(25),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomInput(
                    label: 'Rua*',
                    hint: 'Ex.: Rua xxxx',
                    status: state.status,
                    value: state.street_address,
                    onChanged:
                        BlocProvider.of<AuthCubit>(context).changeStreet),
                const SizedBox(
                  height: 20,
                ),
                CustomInput(
                    label: 'Bairro*',
                    hint: 'Ex.: Centro',
                    status: state.status,
                    value: state.district_address,
                    onChanged:
                        BlocProvider.of<AuthCubit>(context).changeDistrict),
                const SizedBox(
                  height: 20,
                ),
                CustomInput(
                    label: 'Número*',
                    hint: 'Ex.: 77',
                    status: state.status,
                    value: state.number_address,
                    onChanged:
                        BlocProvider.of<AuthCubit>(context).changeNumber),
                const SizedBox(
                  height: 20,
                ),
                CustomInput(
                    label: 'Observações (opcional)',
                    hint: 'Ex.: Apartamento, bloco, referência...',
                    status: state.status,
                    value: state.obs_address,
                    onChanged:
                        BlocProvider.of<AuthCubit>(context).changeObservations),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomInput extends StatelessWidget {
  const CustomInput({
    Key? key,
    required this.label,
    required this.hint,
    required this.status,
    required this.onChanged,
    this.value,
    this.controller,
  }) : super(key: key);
  final String label;
  final String hint;
  final AppStatus? status;
  final String? value;
  final Function(String)? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.semiBold(14),
        ),
        const SizedBox(
          height: 10,
        ),
        //text 8391A1
        TextFormField(
          style: AppTextStyles.medium(16, color: const Color(0xff8391A1)),
          onChanged: onChanged,
          textInputAction: TextInputAction.next,
          controller: status == AppStatus.editing
              ? TextEditingController(text: value)
              : null,
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
            hintText: hint,
          ),
        )
      ],
    );
  }
}

class AddressCard extends StatelessWidget {
  const AddressCard({
    Key? key,
    required this.onEditPressed,
    required this.address,
  }) : super(key: key);

  final VoidCallback onEditPressed;
  final AddressType address;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.shade200,
          border: const Border.fromBorderSide(
              BorderSide(color: Color(0xff28B1EC), width: 2))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.55,
            child: RichText(
              text: TextSpan(
                  text: "${address.street}\n",
                  style: AppTextStyles.semiBold(16),
                  // locale: Locale.fromSubtags(),
                  children: [
                    TextSpan(
                      text: address.address,
                      style: AppTextStyles.light(16),
                    ),
                  ]),
            ),
          ),
          IconButton(
              onPressed: onEditPressed,
              icon: const Icon(
                Icons.edit,
                color: Color(0xff28B1EC),
                size: 30,
              ))
        ],
      ),
    );
  }
}
