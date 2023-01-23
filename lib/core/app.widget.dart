import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:snacks_app/core/app.routes.dart';
import 'package:snacks_app/views/authentication/add_address_screen.dart';
import 'package:snacks_app/views/authentication/add_name_screen.dart';
import 'package:snacks_app/views/authentication/state/auth_cubit.dart';
import 'package:snacks_app/views/authentication/unavailable_screen.dart';
import 'package:snacks_app/views/home/orders_screen.dart';
import 'package:snacks_app/views/home/state/card_state/card_cubit.dart';
import 'package:snacks_app/views/home/state/cart_state/cart_cubit.dart';
import 'package:snacks_app/views/home/state/home_state/home_cubit.dart';
import 'package:snacks_app/views/home/state/item_screen/item_screen_cubit.dart';
import 'package:snacks_app/views/home/cart_screen.dart';
import 'package:snacks_app/views/home/home_screen.dart';
import 'package:snacks_app/views/home/payment_screen.dart';
import 'package:snacks_app/views/home/scan_card_screen.dart';
import 'package:snacks_app/views/authentication/scan_qrcode_screen.dart';
import 'package:snacks_app/views/authentication/otp_screen.dart';
import 'package:snacks_app/views/authentication/phone_number_screen.dart';
import 'package:snacks_app/views/authentication/start_screen.dart';
// import 'package:snacks_app/views/review/main.dart';
import 'package:snacks_app/views/review/review_screen.dart';
import 'package:snacks_app/views/review/state/cubit/review_cubit.dart';
import 'package:snacks_app/views/splash/splash_screen.dart';

class AppWidget extends StatelessWidget {
  AppWidget({Key? key}) : super(key: key);
  final auth = FirebaseAuth.instance;
  final fire = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    int compareTo(TimeOfDay now, TimeOfDay other) {
      return now.hour * 60 + now.minute == other.hour * 60 + other.minute
          ? 0
          : now.hour * 60 + now.minute >= other.hour * 60 + other.minute
              ? 1
              : -1;
    }

    Future<bool> verifyRestaurantStatus() async {
      var time = DateTime.now();
      var now = TimeOfDay.now();
      await initializeDateFormatting("pt_BR");
      var doc = await fire
          .collection("snacks_config")
          .doc("work_time")
          .collection("days")
          .doc((time.weekday - 1).toString())
          .get();
      DateTime start = DateFormat("HH:mm").parse(doc.data()?["start"]);

      DateTime end = DateFormat("HH:mm").parse(doc.data()?["end"]);
      var startTime = TimeOfDay(hour: start.hour, minute: start.minute);
      var endTime = TimeOfDay(hour: end.hour, minute: end.minute);
      //0 equal //-1 lesser // 1 greater
      // return compareTo(now, startTime) >= 0 && compareTo(now, endTime) <= 0
      //     ? true
      //     : false;
      return true;
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(),
        ),
        BlocProvider<ItemScreenCubit>(
          create: (context) => ItemScreenCubit(),
        ),
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(),
        ),
        BlocProvider<ReviewCubit>(
          create: (context) => ReviewCubit(),
        ),
        BlocProvider<CardCubit>(
          create: (context) => CardCubit(),
        ),
      ],
      key: UniqueKey(),
      child: FutureBuilder<bool>(
          future: verifyRestaurantStatus(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    // primaryColor: AppColors.main,
                    backgroundColor: Colors.white,
                    textTheme: GoogleFonts.poppinsTextTheme(
                        Theme.of(context).textTheme)),
                title: "Snacks App",
                initialRoute: snapshot.data == true
                    ? auth.currentUser != null
                        ? AppRoutes.home
                        : AppRoutes.start
                    : AppRoutes.closedRestaurant,
                // initialRoute: AppRoutes.cart,
                routes: {
                  AppRoutes.start: (context) => StartScreen(),
                  AppRoutes.otp: (context) => const OtpScreen(),
                  AppRoutes.address: (context) => AddAddressScreen(),
                  AppRoutes.phoneAuth: (context) => PhoneNumberScreen(),
                  AppRoutes.addName: (context) => const AddNameScreen(),
                  AppRoutes.scanCard: (context) => const ScanCardScreen(),
                  AppRoutes.scanQrCode: (context) => const ScanQrCodeScreen(),
                  AppRoutes.payment: (context) => PaymentScreen(),
                  AppRoutes.cart: (context) => MyCartScreen(),
                  AppRoutes.orders: (context) => const OrdersScreen(),
                  AppRoutes.home: (context) => HomeScreen(),
                  AppRoutes.feedback: (context) => ReviewScreen(),
                  AppRoutes.closedRestaurant: (context) => UnavailableScreen()
                },
              );
            }
            return const SplashScreen();
          }),
    );
  }
}
