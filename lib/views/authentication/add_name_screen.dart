import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snacks_app/core/app.routes.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/views/authentication/state/auth_cubit.dart';

class AddNameScreen extends StatelessWidget {
  const AddNameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.address),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                primary: Colors.black,
                fixedSize: const Size(double.maxFinite, 59)),
            child: Text(
              'Adicionar nome',
              style: AppTextStyles.regular(16, color: Colors.white),
            ),
          ),
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
        body: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Digite seu nome',
                  style: AppTextStyles.semiBold(25),
                ),
                const SizedBox(
                  height: 20,
                ),
                //text 8391A1
                TextFormField(
                  style:
                      AppTextStyles.medium(16, color: const Color(0xff8391A1)),
                  onChanged: BlocProvider.of<AuthCubit>(context).changeName,
                  decoration: InputDecoration(
                    fillColor: const Color(0xffF7F8F9),
                    filled: true,
                    hintStyle: AppTextStyles.medium(16,
                        color: const Color(0xff8391A1).withOpacity(0.5)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Color(0xffE8ECF4), width: 1)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Color(0xffE8ECF4), width: 1)),
                    hintText: 'Ex.: Lucas Olbauri',
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
