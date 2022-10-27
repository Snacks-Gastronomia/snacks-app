import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snacks_app/core/app.routes.dart';
import 'package:snacks_app/views/authentication/add_address_screen.dart';
import 'package:snacks_app/views/authentication/add_name_screen.dart';
import 'package:snacks_app/views/authentication/restaurant_auth_screen.dart';
import 'package:snacks_app/views/authentication/state/auth_cubit.dart';
import 'package:snacks_app/views/home/orders_screen.dart';
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

class AppWidget extends StatelessWidget {
  AppWidget({Key? key}) : super(key: key);
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
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
      ],
      key: UniqueKey(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            // primaryColor: AppColors.main,
            backgroundColor: Colors.white,
            textTheme:
                GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)),
        title: "Snacks App",
        initialRoute:
            auth.currentUser != null ? AppRoutes.home : AppRoutes.start,
        routes: {
          AppRoutes.start: (context) => StartScreen(),
          AppRoutes.otp: (context) => const OtpScreen(),
          AppRoutes.address: (context) => AddAddressScreen(),
          AppRoutes.phoneAuth: (context) => PhoneNumberScreen(),
          AppRoutes.addName: (context) => const AddNameScreen(),
          AppRoutes.scanCard: (context) => const ScanCardScreen(),
          AppRoutes.scanQrCode: (context) => const ScanQrCodeScreen(),
          AppRoutes.payment: (context) => const PaymentScreen(),
          AppRoutes.cart: (context) => const MyCartScreen(),
          AppRoutes.orders: (context) => const OrdersScreen(),
          AppRoutes.home: (context) => HomeScreen(),
          // AppRoutes.restaurantAuth: (context) =>
          //     const RestaurantAuthenticationScreen(),
        },
      ),
    );
  }
}
