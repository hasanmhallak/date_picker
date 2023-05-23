import 'package:flutter/material.dart';

import 'date_picker.dart';

Future<DateTime?> showDatePickerDialog({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime maxDate,
  required DateTime minDate,
  EdgeInsets contentPadding = const EdgeInsets.all(16),
  EdgeInsets padding = const EdgeInsets.all(36),
  PickerType initialPickerType = PickerType.days,
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  TextStyle? daysNameTextStyle,
  Color? enabledCellColor,
  TextStyle? enabledCellTextStyle,
  BoxDecoration enabledCellDecoration = const BoxDecoration(),
  Color? disbaledCellColor,
  TextStyle? disbaledCellTextStyle,
  BoxDecoration disbaledCellDecoration = const BoxDecoration(),
  Color? currentDateColor,
  TextStyle? currentDateTextStyle,
  BoxDecoration? currentDateDecoration,
  Color? selectedCellColor,
  TextStyle? selectedCellTextStyle,
  BoxDecoration? selectedCellDecoration,
}) async {
  return showDialog<DateTime>(
    context: context,
    barrierColor: barrierColor,
    anchorPoint: anchorPoint,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    routeSettings: routeSettings,
    useRootNavigator: useRootNavigator,
    useSafeArea: useSafeArea,
    builder: (context) {
      return Padding(
        padding: padding,
        child: Dialog(
          insetPadding: EdgeInsets.zero,
          child: DatePicker(
            initialDate: initialDate,
            maxDate: maxDate,
            minDate: minDate,
            onDateChanged: (value) => Navigator.pop(context, value),
            initialPickerType: initialPickerType,
            padding: contentPadding,
            currentDateDecoration: currentDateDecoration,
            currentDateTextStyle: currentDateTextStyle,
            disbaledCellDecoration: disbaledCellDecoration,
            disbaledCellTextStyle: disbaledCellTextStyle,
            enabledCellDecoration: enabledCellDecoration,
            enabledCellTextStyle: enabledCellTextStyle,
            selectedCellDecoration: selectedCellDecoration,
            selectedCellTextStyle: selectedCellTextStyle,
          ),
        ),
      );
    },
  );
}
