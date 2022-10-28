import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:snacks_app/core/app.text.dart';

class CustomAutoComplete extends StatelessWidget {
  const CustomAutoComplete({
    Key? key,
    required this.searchController,
    required this.onSelected,
    required this.focus,
    required this.suggestionsCallback,
    required this.itemBuilder,
    required this.hintText,
  }) : super(key: key);

  final TextEditingController searchController;
  final Function(dynamic) onSelected;
  final FocusNode focus;
  final Future<Iterable<dynamic>> Function(String) suggestionsCallback;
  final Widget Function(BuildContext, dynamic) itemBuilder;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      hideOnEmpty: true,
      onSuggestionSelected: onSelected,
      autoFlipDirection: true,
      itemBuilder: itemBuilder,
      suggestionsCallback: suggestionsCallback,
      transitionBuilder: (context, suggestionsBox, animationController) =>
          FadeTransition(
        opacity: CurvedAnimation(
            parent: animationController!.view, curve: Curves.fastOutSlowIn),
        child: suggestionsBox,
      ),
      textFieldConfiguration: TextFieldConfiguration(
        autofocus: false,
        focusNode: focus,
        controller: searchController,
        style: AppTextStyles.medium(16, color: const Color(0xff8391A1)),
        textInputAction: TextInputAction.go,
        decoration: InputDecoration(
          fillColor: const Color(0xffF7F8F9),
          filled: true,
          suffixIcon: const Icon(Icons.search_rounded),
          hintStyle: AppTextStyles.medium(16,
              color: const Color(0xff8391A1).withOpacity(0.5)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xffE8ECF4), width: 1)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xffE8ECF4), width: 1)),
          hintText: hintText,
        ),
      ),
    );
  }
}
