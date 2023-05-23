# Date Picker

A Flutter library that provides a customizable Material Design date picker widget.

## Features

- Select a specific day, month, or year from a grid-based interface.
- Customize the appearance of enabled, disabled, and selected cells.
- Specify the minimum and maximum selectable dates.
- Supports localization and internationalization.

## Usage

To use the Date Picker library, add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  date_picker: ^1.0.0
```

Import the library in your Dart file:

```dart
import 'package:date_picker/date_picker.dart';
```

Call the `showDatePickerDialog` to show a date picker dialog.

```dart

final date = await showDatePickerDialog(
                     context: context,
                     initialDate: DateTime.now(),
                     minDate: DateTime(2021, 1, 1),
                     maxDate: DateTime(2023, 12, 31),
                   );
```

Customize the appearance of the date picker by providing optional parameters to the `showDatePickerDialog` function.

```dart
showDatePickerDialog(
  context: context,
  initialDate: DateTime.now(),
  minDate: DateTime(2021, 1, 1),
  maxDate: DateTime(2023, 12, 31),
  todayTextStyle: const TextStyle(),
  daysNameTextStyle: const TextStyle(),
  enabledDaysTextStyle: const TextStyle(),
  selectedDayTextStyle: const TextStyle(),
  disbaledDaysTextStyle: const TextStyle(),
  todayDecoration: const BoxDecoration(),
  enabledDaysDecoration: const BoxDecoration(),
  selectedDayDecoration: const BoxDecoration(),
  disbaledDaysDecoration: const BoxDecoration(),
);
```

For more details, see the [example](https://github.com/hasanmhallak/date_picker/example) folder.

## Contribution

Contributions to the Date Picker library are welcome! If you find any issues or have suggestions for improvement, please create a new issue or submit a pull request on the [GitHub repository](https://github.com/hasanmhallak/date_picker).

## License

The Date Picker library is licensed under the [MIT License](https://opensource.org/licenses/MIT). See the [LICENSE](https://github.com/hasanmhallak/date_picker/blob/master/LICENSE) file for more details.
