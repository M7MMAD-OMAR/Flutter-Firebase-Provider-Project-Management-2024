part of values;

class ButtonStyles {
  static final ButtonStyle blueRounded = ButtonStyle(

      backgroundColor:
          WidgetStateProperty.all<Color>(HexColor.fromHex("246CFE")),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
              side: BorderSide(color: HexColor.fromHex("246CFE")))));

  static final ButtonStyle imageRounded = ButtonStyle(
      backgroundColor: WidgetStateProperty.all(HexColor.fromHex("181A1F")),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
              side: BorderSide(color: HexColor.fromHex("666A7A"), width: 1))));
}
