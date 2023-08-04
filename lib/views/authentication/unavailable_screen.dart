import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:snacks_app/core/app.images.dart';
import 'package:snacks_app/core/app.text.dart';

class UnavailableScreen extends StatelessWidget {
  UnavailableScreen({super.key});
  final fire = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    Future<dynamic> getTomorrowTime() async {
      var time = DateTime.now();
      var ref =
          fire.collection("snacks_config").doc("work_time").collection("days");
      DocumentSnapshot<Object?> current_doc =
          await ref.doc(time.weekday.toString()).get();

      var doc = await ref
          .where("active", isEqualTo: true)
          .limit(1)
          .startAtDocument(current_doc)
          .get();

      return doc.docs[0];
    }

    String getDayString(int opens_at) {
      final dt_weekdays = DateFormat(null, "pt_BR").dateSymbols.WEEKDAYS;
      final today = DateTime.now().weekday;

      List<String> weekdays = List.from(dt_weekdays);
      weekdays.add(dt_weekdays[0]);

      var last_day = today == 7;

      bool isTomorrow = last_day ? opens_at == 1 : opens_at == today + 1;

      var day_string = opens_at == today
          ? "hoje"
          : isTomorrow
              ? "amanhã"
              : weekdays[opens_at];
      return day_string;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white,
                  size: 150,
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'Restaurante fechado',
                  style: AppTextStyles.semiBold(30, color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                    future: getTomorrowTime(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var day = int.parse(snapshot.data.id.toString());

                        var day_string = getDayString(day);

                        return Text(
                            'Abre $day_string às ${snapshot.data.data()["start"]}h.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.regular(16,
                                color: Colors.white70));
                      }
                      return const SizedBox();
                    }),
                const Spacer(),
                SvgPicture.asset(
                  AppImages.snacks,
                  width: 150,
                  color: Colors.white30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
