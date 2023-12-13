import 'package:flutter/material.dart';

import '../shared/picker_type.dart';
import 'date_picker.dart';

/// Shows a dialog containing a Material Design date picker.
///
/// The returned [Future] resolves to the date selected by the user when the
/// user confirms the dialog. If the user cancels the dialog, null is returned.
///
/// When the date picker is first displayed, it will show the month of
/// [initialDate].
///
/// The [minDate] is the earliest allowable date. The [maxDate] is the latest
/// allowable date. [initialDate] must either fall between these dates,
/// or be equal to one of them. For each of these [DateTime] parameters, only
/// their dates are considered. Their time fields are ignored. They must all
/// be non-null.
///
/// The locale for the date picker defaults to the ambient locale
/// provided by [Localizations].
///
/// The [context], [useRootNavigator] and [routeSettings] arguments are passed to
/// [showDialog], the documentation for which discusses how it is used. [context]
/// and [useRootNavigator] must be non-null.
///
/// An optional [initialPickerType] argument can be used to have the
/// calendar date picker initially appear in the [initialPickerType.year],
/// [initialPickerType.month] or [initialPickerType.day] mode. It defaults
/// to [initialPickerType.day], and
/// must be non-null.
///
/// See also:
///
///  * [DatePicker], which provides the calendar grid used by the date picker dialog.
///
Future<DateTime?> showDatePickerDialog({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime maxDate,
  required DateTime minDate,
  DateTime? currentDate,
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
  double? slidersSize,
  Color? slidersColor,
  TextStyle? leadingDateTextStyle,
  Color? highlightColor,
  Color? splashColor,
  double? splashRadius,
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
            currentDate: currentDate,
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
            currentDateColor: currentDateColor,
            daysNameTextStyle: daysNameTextStyle,
            disbaledCellColor: disbaledCellColor,
            selectedCellColor: selectedCellColor,
            enabledCellColor: enabledCellColor,
            leadingDateTextStyle: leadingDateTextStyle,
            slidersColor: slidersColor,
            slidersSize: slidersSize,
            highlightColor: highlightColor,
            splashColor: splashColor,
            splashRadius: splashRadius,
          ),
        ),
      );
    },
  );
}
