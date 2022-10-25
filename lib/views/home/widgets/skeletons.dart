import "package:flutter/material.dart";
import 'package:skeletons/skeletons.dart';

class ListSkeletons extends StatelessWidget {
  const ListSkeletons({
    Key? key,
    required this.direction,
  }) : super(key: key);
  final Axis direction;
  @override
  Widget build(BuildContext context) {
    return direction == Axis.horizontal
        ? SizedBox(
            height: 170,
            child: ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) => const SizedBox(
                width: 5,
              ),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(height: 165, child: CardSkeleton())),
            ),
          )
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                mainAxisExtent: 160),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (BuildContext ctx, index) {
              return const CardSkeleton();
            });
  }
}

class CardSkeleton extends StatelessWidget {
  const CardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      height: 155,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xffF6F6F6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
              height: 100,
              child: SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  width: double.infinity,
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 12,
                    width: 80,
                  ),
                ),
                SizedBox(height: 10),
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 15,
                    width: 50,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
