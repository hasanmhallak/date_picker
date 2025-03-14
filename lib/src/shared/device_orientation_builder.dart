import 'package:flutter/material.dart';

/// Builds a widget tree that can depend on the device orientation.
class DeviceOrientationBuilder extends StatelessWidget {
  /// Builds a widget tree that can depend on the device orientation.
  final Widget Function(BuildContext context, Orientation orientation) builder;

  /// Builds a widget tree that can depend on the device orientation.
  const DeviceOrientationBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    return builder(context, orientation);
  }
}
