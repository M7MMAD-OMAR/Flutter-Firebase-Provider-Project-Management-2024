import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';

class OutlinedButtonWithImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  const OutlinedButtonWithImage({Key? key, required this.imageUrl, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: 60,
        child: ElevatedButton(
            onPressed: () {},
            style: ButtonStyles.imageRounded,
            child: Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: ClipOval(
                  child: Image(
                      fit: BoxFit.contain, image: AssetImage(imageUrl)),
                ),
              ),
            )));
  }
}