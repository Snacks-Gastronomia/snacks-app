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

class AddAddressScreen extends StatelessWidget {
  AddAddressScreen({Key? key}) : super(key: key);
  final searchFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? {}) as Map;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
              return CustomSubmitButton(
                  onPressedAction: () async {
                    final navigator = Navigator.of(context);
                    if (state.address.address.isNotEmpty) {
                      if (arguments.isNotEmpty) {
                        context.read<AuthCubit>().updateAddressFromDatabase();
                        navigator.pop();
                      } else {
                        context.read<AuthCubit>().saveUser();
                        await navigator.pushNamedAndRemoveUntil(AppRoutes.home,
                            ModalRoute.withName(AppRoutes.start));
                      }
                    }
                  },
                  label: "Salvar",
                  loading_label: "Salvando dados",
                  loading: state.status == AppStatus.loading);
            })
            // ElevatedButton(
            //   onPressed: () =>
            //       context.read<AuthCubit>().state.address.address.isEmpty
            //           ? null
            //           : Navigator.pushNamed(context, AppRoutes.home),
            //   style: ElevatedButton.styleFrom(
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(15)),
            //       primary: Colors.black,
            //       fixedSize: const Size(double.maxFinite, 59)),
            //   child: Text(
            //     'Adicionar endereço',
            //     style: AppTextStyles.regular(16, color: Colors.white),
            //   ),
            // ),
            ),
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
                        primary: Colors.white,
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
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                arguments.isNotEmpty
                    ? 'Adicione seu novo endereço'
                    : 'Adicione seu endereço',
                style: AppTextStyles.semiBold(25),
              ),
              const SizedBox(
                height: 20,
              ),
              //text 8391A1
              BlocBuilder<AuthCubit, AuthState>(builder: (context, snapshot) {
                if (snapshot.status == AppStatus.editing) {
                  searchFocus.requestFocus();
                }
                return CustomAutoComplete(
                    hintText: 'Ex: Rua xxxx, numero, bairro, cidade',
                    focus: searchFocus,
                    itemBuilder: (BuildContext context, dynamic option) =>
                        ListTile(
                          // leading: Icon(Icons.location_on),
                          title: Text(
                            option.text,
                            style: AppTextStyles.bold(18),
                          ),
                          subtitle: Text(option.place_name,
                              style: AppTextStyles.light(16)),
                        ),
                    suggestionsCallback: (pattern) async {
                      return await context
                          .read<AuthCubit>()
                          .fecthAddress(pattern);
                      // return await getAddresses(pattern);
                    },
                    searchController: context
                        .read<AuthCubit>()
                        .state
                        .address_input_controller,
                    key: UniqueKey(),
                    onSelected: (value) {
                      String text = value.text + " ";
                      String place_name = value.place_name;
                      String address = place_name.substring(
                          value.place_name.toString().indexOf(",") + 2);

                      context.read<AuthCubit>().changeAddress(AddressType(
                          street: text,
                          address: address,
                          complete: place_name));
                    });
              }),
              const SizedBox(
                height: 30,
              ),
              BlocBuilder<AuthCubit, AuthState>(
                  buildWhen: (previous, current) =>
                      previous.address != current.address,
                  builder: (context, snap) {
                    if (snap.address.address.isNotEmpty) {
                      return AddressCard(
                          address: context.read<AuthCubit>().state.address,
                          onEditPressed: () =>
                              BlocProvider.of<AuthCubit>(context)
                                  .updateAddressFromScreen());
                    } else {
                      return const SizedBox();
                    }
                  }),
              const Spacer(),
              Center(
                child: TextButton.icon(
                    onPressed: () async {
                      AddressType address =
                          await BlocProvider.of<AuthCubit>(context)
                              .getCurrentAddress();

                      AppModal().showModalBottomSheet(
                          context: context,
                          content: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 100),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Text(
                                    address.complete,
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.regular(16),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<AuthCubit>()
                                        .changeAddress(address);
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      backgroundColor: Colors.black,
                                      fixedSize:
                                          const Size(double.maxFinite, 59)),
                                  child: Text(
                                    'Adicionar',
                                    style: AppTextStyles.regular(16,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                    icon: const Icon(Icons.gps_fixed_rounded,
                        color: Color(0xff35C2C1)),
                    label: Text(
                      "Usar minha localização atual",
                      style: AppTextStyles.semiBold(15,
                          color: const Color(0xff35C2C1)),
                    )),
              ),
            ],
          ),
        ),
      ),
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

// class AutoCompleteAddress extends StatelessWidget {
//   const AutoCompleteAddress({
//     Key? key,
//     required this.searchController,
//     required this.onSelected,
//     required this.focus,
//   }) : super(key: key);

//   final TextEditingController searchController;
//   final Function(dynamic) onSelected;
//   final FocusNode focus;
//   @override
//   Widget build(BuildContext context) {
//     return TypeAheadField(
//       hideOnEmpty: true,
//       onSuggestionSelected: onSelected,
//       autoFlipDirection: true,
//       itemBuilder: (BuildContext context, dynamic option) => ListTile(
//         // leading: Icon(Icons.location_on),
//         title: Text(
//           option.text,
//           style: AppTextStyles.bold(18),
//         ),
//         subtitle: Text(option.place_name, style: AppTextStyles.light(16)),
//       ),
//       suggestionsCallback: (pattern) async {
//         return await context.read<AuthCubit>().fecthAddress(pattern);
//         // return await getAddresses(pattern);
//       },
//       transitionBuilder: (context, suggestionsBox, animationController) =>
//           FadeTransition(
//         opacity: CurvedAnimation(
//             parent: animationController!.view, curve: Curves.fastOutSlowIn),
//         child: suggestionsBox,
//       ),
//       textFieldConfiguration: TextFieldConfiguration(
//         autofocus: false,
//         focusNode: focus,
//         controller: searchController,
//         style: AppTextStyles.medium(16, color: Color(0xff8391A1)),
//         decoration: InputDecoration(
//           fillColor: Color(0xffF7F8F9),
//           filled: true,
//           suffixIcon: Icon(Icons.search_rounded),
//           hintStyle: AppTextStyles.medium(16,
//               color: Color(0xff8391A1).withOpacity(0.5)),
//           enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xffE8ECF4), width: 1)),
//           border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xffE8ECF4), width: 1)),
//           hintText: 'Ex: Rua xxxx, numero, bairro, cidade',
//         ),
//       ),
//     );
//   }
// }
