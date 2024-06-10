part of '../constants/values.dart';

class Utils {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}

class SineCurve extends Curve {
  final double count;

  const SineCurve({this.count = 3});

  @override
  double transformInternal(double t) {
    var val = sin(count * 2 * pi * t) * 0.5 + 0.5;
    return val;
  }
}

Widget buildStackedImages(
    {TextDirection direction = TextDirection.rtl,
    String? numberOfMembers,
    bool? addMore}) {
  const double size = 50;
  const double xShift = 20;

  Container lastContainer = Container(
      width: 40,
      height: 40,
      decoration:
          const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Center(
        child: Text(numberOfMembers!,
            style: GoogleFonts.lato(
                color: HexColor.fromHex("226AFD"),
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ));

  Container iconContainer = Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          color: AppColors.primaryAccentColor, shape: BoxShape.circle),
      child: const Icon(Icons.add, color: Colors.white));

  final items = List.generate(
      4,
      (index) => ProfileDummy(
          color: AppData.groupBackgroundColors[index],
          dummyType: ProfileDummyType.Image,
          image: AppData.profileImages[index],
          scale: 1.0));

  return StackedWidgets(
    direction: direction,
    items: [
      ...items,
      lastContainer,
      (addMore != null) ? iconContainer : const SizedBox()
    ],
    size: size,
    xShift: xShift,
  );
}
