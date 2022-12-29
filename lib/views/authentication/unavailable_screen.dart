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
      var doc = await ref
          .where("active", isEqualTo: true)
          .limit(1)
          .startAfterDocument(await ref.doc(time.weekday.toString()).get())
          .get();
      // DateTime start = DateFormat("HH:mm").parse(doc.data()?["start"]);
      // DateTime end = DateFormat("HH:mm").parse(doc.data()?["end"]);

      return doc.docs[0];
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
                        print(snapshot.data.id);
                        var day = int.parse(snapshot.data.id.toString());
                        var day_string = day == DateTime.now().weekday + 1
                            ? "hoje"
                            : day == DateTime.now().weekday + 2
                                ? "amanhã"
                                : DateFormat(null, "pt_BR")
                                    .dateSymbols
                                    .WEEKDAYS[(day)];
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
