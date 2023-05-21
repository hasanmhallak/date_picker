import 'package:datePicker/date_picker.dart';
import 'package:flutter/material.dart';

Future<DateTime?> showDatePickerDialog({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime maxDate,
  required DateTime minDate,
  EdgeInsets contentPadding = const EdgeInsets.all(16),
  EdgeInsets padding = const EdgeInsets.all(36),
  PickerType initialPickerType = PickerType.days,
  Color? daysNameColor,
  Color? disbaledCellsColor,
  Color? enabledCellsColor,
  Color? selectedCellColor,
  Color? selectedCellFillColor,
  Color? todayColor,
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
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
            padding: contentPadding,
            daysNameColor: daysNameColor,
            disbaledCellsColor: disbaledCellsColor,
            enabledCellsColor: enabledCellsColor,
            selectedCellColor: selectedCellColor,
            selectedCellFillColor: selectedCellFillColor,
            todayColor: todayColor,
            initialPickerType: initialPickerType,
          ),
        ),
      );
    },
  );
}
