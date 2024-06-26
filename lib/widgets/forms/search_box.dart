import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/values/values.dart';

class SearchBox extends StatelessWidget {
  final String placeholder;

  final TextEditingController? controller;

  const SearchBox({
    super.key,
    required this.placeholder,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.lato(fontSize: 20, color: Colors.white),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 15,
        ),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Icon(FeatherIcons.search, color: Colors.white),
        ),
        suffixIcon: InkWell(
          onTap: () {
            controller!.text = "";
          },
          child: const Icon(FontAwesomeIcons.solidTimesCircle,
              color: Colors.white70, size: 20),
        ),
        hintText: placeholder,
        hintStyle: GoogleFonts.lato(
            //fontWeight: FontWeight.bold,
            fontSize: 18,
            color: HexColor.fromHex("3C3E49")),
        filled: true,
        fillColor: AppColors.primaryBackgroundColor,
        // enabledBorder: UnderlineInputBorder(
        //   borderRadius: BorderRadius.circular(10.0),
        //   borderSide: BorderSide(color: HexColor.fromHex("3C3E49")),
        // ),
        // focusedBorder: UnderlineInputBorder(
        //   borderRadius: BorderRadius.circular(10.0),
        //   borderSide: BorderSide(color: HexColor.fromHex("BEF0B2")),
        // ),
      ),
    );
  }
}
