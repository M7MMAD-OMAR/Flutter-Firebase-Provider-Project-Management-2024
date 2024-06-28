import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Constants {
  static Widget loadingAnimationWidget(BuildContext context) {
    return Center(
        child: LoadingAnimationWidget.dotsTriangle(
      color: Colors.deepPurple,
      size: 200,
    ));
  }
}
