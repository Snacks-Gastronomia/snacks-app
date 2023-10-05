import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:snacks_app/core/app.routes.dart';
import 'package:snacks_app/services/app_session.dart';
import 'package:snacks_app/services/firebase/remote_config.dart';
import 'package:snacks_app/utils/storage.dart';
import 'package:snacks_app/utils/toast.dart';
import 'package:snacks_app/views/authentication/add_address_screen.dart';
import 'package:snacks_app/views/authentication/add_name_screen.dart';
import 'package:snacks_app/views/authentication/state/auth_cubit.dart';
import 'package:snacks_app/views/authentication/unavailable_screen.dart';
import 'package:snacks_app/views/home/orders_screen.dart';
import 'package:snacks_app/views/home/state/card_state/card_cubit.dart';
import 'package:snacks_app/views/home/state/cart_state/cart_cubit.dart';
import 'package:snacks_app/views/home/state/coupon_state/coupon_cubit.dart';
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
import 'package:snacks_app/views/new_version_available/page.dart';
// import 'package:snacks_app/views/review/main.dart';
import 'package:snacks_app/views/review/review_screen.dart';
import 'package:snacks_app/views/review/state/cubit/review_cubit.dart';
import 'package:snacks_app/views/splash/splash_screen.dart';

class AppWidget extends StatelessWidget {
  AppWidget({Key? key}) : super(key: key);
  final auth = FirebaseAuth.instance;
  final storage = AppStorage();
  final toast = AppToast();
  final fire = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    Future<void> validateAccess() async {
      if (auth.currentUser != null) {
        toast.init(context: context);
        try {
          final session = AppSession();

          final token = await session.validate();
          if (!token) {
            auth.signOut();
            print("sign out......");
          }
        } catch (e) {
          toast.showToast(
              context: context, content: e.toString(), type: ToastType.error);
          print(e);
        }
      }
    }

    Future<bool> validateAppVersion() async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final firebaseRemoteConfigService = FirebaseRemoteConfigService(
        firebaseRemoteConfig: FirebaseRemoteConfig.instance,
      );
      await firebaseRemoteConfigService.init();

      String remoteVersion = firebaseRemoteConfigService.getAppVersionJson();

      return double.parse(packageInfo.version.replaceAll('.', '')) >=
          double.parse(remoteVersion.replaceAll('.', ''));
      // return true;
    }

    Future<bool> reviewInProgress() async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final firebaseRemoteConfigService = FirebaseRemoteConfigService(
        firebaseRemoteConfig: FirebaseRemoteConfig.instance,
      );
      await firebaseRemoteConfigService.init();

      bool inReview = firebaseRemoteConfigService.getReviewInProgress();

      return inReview;
    }

    //0 equal //-1 lesser // 1 greater
    int compareTo(TimeOfDay now, TimeOfDay other) {
      return now.hour * 60 + now.minute == other.hour * 60 + other.minute
          ? 0
          : now.hour * 60 + now.minute >= other.hour * 60 + other.minute
              ? 1
              : -1;
    }

    TimeOfDay transformTime(String date) {
      DateTime dt = DateFormat("HH:mm").parse(date);
      return TimeOfDay(hour: dt.hour, minute: dt.minute);
    }

    DateTime transformToDateTime(TimeOfDay time) {
      return DateTime.utc(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, time.hour, time.minute);
    }

    TimeOfDay subtractTime(TimeOfDay v1, TimeOfDay v2) =>
        TimeOfDay(hour: v1.hour - v2.hour, minute: v1.minute - v2.minute);

    TimeOfDay sumTime(TimeOfDay v1, TimeOfDay v2) {
      var time = transformToDateTime(v1);
      var time2 = transformToDateTime(v2);
      var result = time.add(Duration(hours: time2.hour, minutes: time2.minute));

      return TimeOfDay(hour: result.hour, minute: result.minute);
    }

    Future<Map<String, dynamic>> verifyRestaurantStatus() async {
      await initializeDateFormatting("pt_BR");
      await auth.signInAnonymously();

      var time = DateTime.now();
      var now = TimeOfDay.fromDateTime(time);

      var doc = await fire
          .collection("snacks_config")
          .doc("work_time")
          .collection("days")
          .doc((time.weekday).toString())
          .get();

      print("doc: ${doc.data()}");

      bool isDayActive = doc.data()?["active"];
      var startTime = transformTime(doc.data()?["start"]);
      var endTime = transformTime(doc.data()?["end"]);

      final hasMidnight = compareTo(startTime, endTime) >= 0;

      bool dayValid = compareTo(now, startTime) >= 0 &&
          (compareTo(now, endTime) <= 0 || hasMidnight);

      bool isMidnight =
          compareTo(now, const TimeOfDay(hour: 00, minute: 00)) >= 0 &&
              compareTo(now, startTime) < 0;

      if (isMidnight) {
        var pevious_schedule = await fire
            .collection("snacks_config")
            .doc("work_time")
            .collection("days")
            .doc((time.weekday == 1 ? 7 : time.weekday - 1).toString())
            .get();

        bool previousDayActive = pevious_schedule.data()?["active"];
        var previousStartTime =
            transformTime(pevious_schedule.data()?["start"]);
        var previousEndTime = transformTime(pevious_schedule.data()?["end"]);

        final goThroughMidnight =
            compareTo(previousEndTime, previousStartTime) <= 0;

        if (goThroughMidnight) {
          var fullTime = const TimeOfDay(hour: 23, minute: 59);

          var totalDayTime = subtractTime(fullTime, previousStartTime);

          var totalTime = sumTime(totalDayTime, previousEndTime);

          var shouldClose = sumTime(totalTime, previousStartTime);

          shouldClose =
              sumTime(shouldClose, const TimeOfDay(hour: 00, minute: 01));

          bool isOpen = compareTo(now, shouldClose) <= 0;

          dayValid = isOpen;
          isDayActive = previousDayActive;
        }
      }

      validateAccess();
      bool rightVersion = await validateAppVersion();
      bool review = await reviewInProgress();
      return {
        "restaurant_available": isDayActive && dayValid,
        "right_app_version": rightVersion,
        "in_review": review && rightVersion
      };
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
        BlocProvider<CouponCubit>(
          create: (context) => CouponCubit(),
        ),
      ],
      key: UniqueKey(),
      child: FutureBuilder<Map<String, dynamic>>(
          future: verifyRestaurantStatus(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data ?? {};
              bool current_version = data["right_app_version"];
              bool restaurant_available = data["restaurant_available"];
              bool in_review = data["in_review"];

              String startAppRoute =
                  // auth.currentUser != null ? AppRoutes.home :
                  AppRoutes.start;

              if (!in_review) {
                if (!current_version) {
                  startAppRoute = AppRoutes.newVersionAvailable;
                }
                if (!restaurant_available) {
                  startAppRoute = AppRoutes.closedRestaurant;
                  // startAppRoute = AppRoutes.start;
                }
              }

              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    // primaryColor: AppColors.main,
                    backgroundColor: Colors.white,
                    textTheme: GoogleFonts.poppinsTextTheme(
                        Theme.of(context).textTheme)),
                title: "Snacks App",
                // initialRoute: AppRoutes.orders,
                initialRoute: startAppRoute,
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
                  AppRoutes.closedRestaurant: (context) => UnavailableScreen(),
                  AppRoutes.newVersionAvailable: (context) =>
                      const NewVersionAvailableScreen()
                },
              );
            }
            return const SplashScreen();
          }),
    );
  }
}
