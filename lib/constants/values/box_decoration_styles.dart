part of 'values.dart';

class BoxDecorationStyles {
  static final BoxDecoration fadingGlory = BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          HexColor.fromHex("625B8B"),
          const Color.fromRGBO(98, 99, 102, 1),
          HexColor.fromHex("#181a1f"),
          HexColor.fromHex("#181a1f")
        ]),
    borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20), topRight: Radius.circular(20)),
    //border: Border.all(color: Colors.red, width: 5)
  );

  static final BoxDecoration fadingInnerDecor = BoxDecoration(
      color: HexColor.fromHex("181A1F"),
      borderRadius: BorderRadius.circular(20));
}
