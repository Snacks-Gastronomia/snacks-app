import 'package:flutter/material.dart';
import 'package:snacks_app/components/custom_submit_button.dart';

import 'package:snacks_app/core/app.text.dart';

import './arc_chooser.dart';
import './smile_painter.dart';

class ReviewWidget extends StatefulWidget {
  const ReviewWidget({
    Key? key,
    required this.title,
    required this.onSubmit,
    required this.values,
  }) : super(key: key);

  final String title;
  final Function(int) onSubmit;
  final List<String> values;

  @override
  _ReviewWidgetState createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget>
    with TickerProviderStateMixin {
  final PageController pageControl = PageController(
    initialPage: 3,
    keepPage: false,
    viewportFraction: 0.5,
  );

  int slideValue = 300;
  int lastAnimPosition = 3;

  late AnimationController animation;

  List<ArcItem> arcItems = [];

  late ArcItem badArcItem;
  late ArcItem ughArcItem;
  late ArcItem okArcItem;
  late ArcItem goodArcItem;

  late Color startColor;
  late Color endColor;

  @override
  void initState() {
    super.initState();

    badArcItem = ArcItem(widget.values[0],
        [const Color(0xFFfe0944), const Color(0xFFfeae96)], 0.0);
    ughArcItem = ArcItem(widget.values[1],
        [const Color(0xFFF9D976), const Color(0xfff39f86)], 0.0);
    okArcItem = ArcItem(widget.values[2],
        [const Color(0xFF21e1fa), const Color(0xff3bb8fd)], 0.0);
    goodArcItem = ArcItem(widget.values[3],
        [const Color(0xFF3ee98a), const Color(0xFF41f7c7)], 0.0);

    arcItems.add(badArcItem);
    arcItems.add(ughArcItem);
    arcItems.add(okArcItem);
    arcItems.add(goodArcItem);

    startColor = const Color(0xFF21e1fa);
    endColor = const Color(0xff3bb8fd);

    animation = AnimationController(
      value: 0.0,
      lowerBound: 0.0,
      upperBound: 400.0,
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..addListener(() {
        setState(() {
          slideValue = animation.value.toInt();

          double ratio;

          if (slideValue <= 100) {
            ratio = animation.value / 100;
            startColor =
                Color.lerp(badArcItem.colors[0], ughArcItem.colors[0], ratio) ??
                    Colors.black;
            endColor =
                Color.lerp(badArcItem.colors[1], ughArcItem.colors[1], ratio) ??
                    Colors.black;
          } else if (slideValue <= 200) {
            ratio = (animation.value - 100) / 100;
            startColor =
                Color.lerp(ughArcItem.colors[0], okArcItem.colors[0], ratio) ??
                    Colors.black;
            endColor =
                Color.lerp(ughArcItem.colors[1], okArcItem.colors[1], ratio) ??
                    Colors.black;
          } else if (slideValue <= 300) {
            ratio = (animation.value - 200) / 100;
            startColor =
                Color.lerp(okArcItem.colors[0], goodArcItem.colors[0], ratio) ??
                    Colors.black;
            endColor =
                Color.lerp(okArcItem.colors[1], goodArcItem.colors[1], ratio) ??
                    Colors.black;
          } else if (slideValue <= 400) {
            ratio = (animation.value - 300) / 100;
            startColor = Color.lerp(
                    goodArcItem.colors[0], badArcItem.colors[0], ratio) ??
                Colors.black;
            endColor = Color.lerp(
                    goodArcItem.colors[1], badArcItem.colors[1], ratio) ??
                Colors.black;
          }
        });
      });
    animation.animateTo(slideValue.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: MediaQuery.of(context).padding,
      child: Column(
        children: [
          Center(
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: AppTextStyles.semiBold(24),
              // style: Theme.of(context).textTheme.headline,
            ),
          ),
          const Spacer(),
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.width / 2) + 60),
            painter:
                SmilePainter(slideValue: slideValue, reviews: ["", "", "", ""]),
          ),
          const Spacer(),

          SizedBox(
            height: 100.0,
            child: PageView.builder(
              pageSnapping: true,
              onPageChanged: (int value) {
                animation.animateTo(value * 100.0);
              },
              controller: pageControl,
              itemCount: arcItems.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                    alignment: Alignment.center,
                    child: Text(
                      arcItems[index].text,
                      textAlign: TextAlign.center,
                      style: index == slideValue / 100
                          ? AppTextStyles.semiBold(40,
                              color: arcItems[index].colors[0])
                          : AppTextStyles.semiBold(40,
                              color: Colors.grey.shade300),
                    ));
              },
            ),
          ),
          const Spacer(),

          CustomSubmitButton(
              onPressedAction: () => widget.onSubmit(slideValue ~/ 100),
              label: "Enviar",
              loading_label: "",
              loading: false)
          //slider
          // Slider(
          //   min: 0.0,
          //   max: 300.0,
          //   divisions: 3,
          //   value: slideValue.toDouble(),
          //   label: '${slideValue.round()}',
          //   onChanged: (double newValue) {
          //     setState(() {
          //       slideValue = newValue.round();
          //     });
          //     animation.animateTo(newValue);
          //   },
          // ),
//radio slider
//           Stack(
//               alignment: AlignmentDirectional.bottomCenter,
//               children: <Widget>[
//                 ArcChooser()
//                   ..arcSelectedCallback = (int pos, ArcItem item) {
//                     int animPosition = pos - 2;
//                     if (animPosition > 3) {
//                       animPosition = animPosition - 4;
//                     }

//                     if (animPosition < 0) {
//                       animPosition = 4 + animPosition;
//                     }

//                     if (lastAnimPosition == 3 && animPosition == 0) {
//                       animation.animateTo(4 * 100.0);
//                     } else if (lastAnimPosition == 0 && animPosition == 3) {
//                       animation.forward(from: 4 * 100.0);
//                       animation.animateTo(animPosition * 100.0);
//                     } else if (lastAnimPosition == 0 && animPosition == 1) {
//                       animation.forward(from: 0.0);
//                       animation.animateTo(animPosition * 100.0);
//                     } else {
//                       animation.animateTo(animPosition * 100.0);
//                     }

//                     lastAnimPosition = animPosition;
//                   },
//                 Padding(
//                   padding: const EdgeInsets.all(28.0),
//                   child: Material(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(25.0)),
//                     elevation: 8.0,
//                     child: Container(
//                         width: 150.0,
//                         height: 50.0,
//                         decoration: BoxDecoration(
//                           gradient:
//                               LinearGradient(colors: [startColor, endColor]),
//                         ),
//                         alignment: Alignment.center,
//                         child: Text(
//                           'SUBMIT',
//                           style: textStyle,
//                         )),
//                   ),
// //              child: RaisedButton(
// //                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
// //                child: Text('SUBMIT'),
// //                onPressed: () {
// //                  print('cool');
// //                },
// //              ),
//                 )
//               ]),
        ],
      ),
    );
  }
}
