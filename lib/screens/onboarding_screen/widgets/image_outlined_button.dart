import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';

class OutlinedButtonWithImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final VoidCallback? callback;

  const OutlinedButtonWithImage(
      {super.key, required this.imageUrl, this.width, this.callback});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: 60,
        child: ElevatedButton(
            onPressed: callback,
            style: ButtonStyles.imageRounded,
            child: Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: ClipOval(
                  child:
                      Image(fit: BoxFit.contain, image: AssetImage(imageUrl)),
                ),
              ),
            )));
  }
}
