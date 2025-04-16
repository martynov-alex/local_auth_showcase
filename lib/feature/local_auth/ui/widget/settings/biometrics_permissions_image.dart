import 'package:flutter/material.dart';

class BiometricsPermissionsImageWidget extends StatelessWidget {
  const BiometricsPermissionsImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform != TargetPlatform.iOS) {
      return const SizedBox.shrink();
    }

    return Text("BiometricsPermissionsImageWidget");
  }
}
