[![Tests](https://github.com/hasanmhallak/date_picker/actions/workflows/tests.yml/badge.svg?branch=master)](https://github.com/hasanmhallak/date_picker/actions/workflows/tests.yml)

# Date Picker Plus

A Flutter library that provides a customizable Material Design date and range picker widgets.

<div>
  <img src="https://raw.githubusercontent.com/hasanmhallak/date_picker/master/1.png" alt="1" width="200" height="225"/>
  <img src="https://raw.githubusercontent.com/hasanmhallak/date_picker/master/2.png" alt="2" width="200" height="225"/>
  <img src="https://raw.githubusercontent.com/hasanmhallak/date_picker/master/3.png" alt="3" width="200" height="225"/>
  <img src="https://raw.githubusercontent.com/hasanmhallak/date_picker/master/4.png" alt="4" width="200" height="225"/>
  <img src="https://raw.githubusercontent.com/hasanmhallak/date_picker/master/5.png" alt="5" width="200" height="225"/>
  <img src="https://raw.githubusercontent.com/hasanmhallak/date_picker/master/6.png" alt="6" width="200" height="225"/>
</div>

## Features

- Beautiful UI.
- Support Material 3 out of the box.
- Highly Customizable UI.
- Supports multi-language.

## Usage

To use the Date Picker library, add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  date_picker_plus: ^3.0.2
```

Import the library in your Dart file:

```dart
import 'package:date_picker_plus/date_picker_plus.dart';
```

### Show Date Picker Dialog

Call the `showDatePickerDialog` function to show a date picker dialog:

```dart
final date = await showDatePickerDialog(
  context: context,
  minDate: DateTime(2021, 1, 1),
  maxDate: DateTime(2023, 12, 31),
);
```

### Show Range Picker Dialog

Call the `showRangePickerDialog` function to show a range picker dialog:

```dart
final date = await showRangePickerDialog(
  context: context,
  minDate: DateTime(2021, 1, 1),
  maxDate: DateTime(2023, 12, 31),
);
```

Customize the appearance of the picker by providing optional parameters to the `showDatePickerDialog` or
`showRangePickerDialog` function.

```dart
final date = await showDatePickerDialog(
      context: context,
      initialDate: DateTime(2022, 10, 10),
      minDate: DateTime(2020, 10, 10),
      maxDate: DateTime(2024, 10, 30),
      width: 300,
      height: 300,
      currentDate: DateTime(2022, 10, 15),
      selectedDate: DateTime(2022, 10, 16),
      currentDateDecoration: const BoxDecoration(),
      currentDateTextStyle: const TextStyle(),
      daysOfTheWeekTextStyle: const TextStyle(),
      disbaledCellsDecoration: const BoxDecoration(),
      disabledCellsTextStyle: const TextStyle(),
      enabledCellsDecoration: const BoxDecoration(),
      enabledCellsTextStyle: const TextStyle(),
      initialPickerType: PickerType.days,
      selectedCellDecoration: const BoxDecoration(),
      selectedCellTextStyle: const TextStyle(),
      leadingDateTextStyle: const TextStyle(),
      slidersColor: Colors.lightBlue,
      highlightColor: Colors.redAccent,
      slidersSize: 20,
      splashColor: Colors.lightBlueAccent,
      splashRadius: 40,
      centerLeadingDate: true,
);
```

```dart
final range = await showRangePickerDialog(
      context: context,
      initialDate: DateTime(2022, 10, 10),
      minDate: DateTime(2020, 10, 10),
      maxDate: DateTime(2024, 10, 30),
      width: 300,
      height: 300,
      currentDate: DateTime(2022, 10, 15),
      selectedRange: DateTimeRange(start: DateTime(2022), end: Dat(2023)),
      selectedCellsDecoration: const BoxDecoration(),
      selectedCellsTextStyle: const TextStyle(),
      singleSelectedCellDecoration: const BoxDecoration(),
      singleSelectedCellTextStyle: const TextStyle(),
      currentDateDecoration: const BoxDecoration(),
      currentDateTextStyle: const TextStyle(),
      daysOfTheWeekTextStyle: const TextStyle(),
      disbaledCellsDecoration: const BoxDecoration(),
      disabledCellsTextStyle: const TextStyle(),
      enabledCellsDecoration: const BoxDecoration(),
      enabledCellsTextStyle: const TextStyle(),
      initialPickerType: PickerType.days,
      leadingDateTextStyle: const TextStyle(),
      slidersColor: Colors.lightBlue,
      highlightColor: Colors.redAccent,
      slidersSize: 20,
      splashColor: Colors.lightBlueAccent,
      splashRadius: 40,
      centerLeadingDate: true,
);
```

## Other Widgets

Alternatively, you can use other widget directly:

### DatePicker Widget

Creates a full date picker.

```dart
SizedBox(
  width: 300,
  height: 400,
  child: DatePicker(
  minDate: DateTime(2021, 1, 1),
  maxDate: DateTime(2023, 12, 31),
  onDateSelected: (value) {
    // Handle selected date
  },
 ),
);
```

### RangeDatePicker Widget

Creates a full range picker.

```dart
SizedBox(
  width: 300,
  height: 400,
  child: RangeDatePicker(
    centerLeadingDate: true,
    minDate: DateTime(2020, 10, 10),
    maxDate: DateTime(2024, 10, 30),
    onRangeSelected: (value) {
    // Handle selected range
  },
 ),
);
```

### DaysPicker Widget

Creates a day picker only.

```dart
SizedBox(
  width: 300,
  height: 400,
  child: DaysPicker(
  minDate: DateTime(2021, 1, 1),
  maxDate: DateTime(2023, 12, 31),
  onDateSelected: (value) {
    // Handle selected date
  },
 ),
);
```

### MonthPicker Widget

Creates a month picker only. The day of selected month will always be `1`.

```dart
SizedBox(
  width: 300,
  height: 400,
  child: MonthPicker(
  minDate: DateTime(2021, 1),
  maxDate: DateTime(2023, 12),
  onDateSelected: (value) {
    // Handle selected date
  },
 ),
);
```

### YearsPicker Widget

Creates a year picker only. The month of selected year will always be `1`.

```dart
SizedBox(
  width: 300,
  height: 400,
  child: YearsPicker(
  minDate: DateTime(2021),
  maxDate: DateTime(2023),
  onDateSelected: (value) {
    // Handle selected date
  },
 ),
);
```

## Multi-language support

This package has multi-language supports. To enable it, add your `Locale` into the wrapping `MaterialApp`:

```dart
MaterialApp(
  localizationsDelegates: GlobalMaterialLocalizations.delegates,
  locale: const Locale('en', 'US'),
  supportedLocales: const [
    Locale('en', 'US'),
    Locale('en', 'GB'),
    Locale('ar'),
    Locale('zh'),
    Locale('ru'),
    Locale('es'),
    Locale('hi'),
  ],
  ...
);
```

For more details, see the [example](https://github.com/hasanmhallak/date_picker/blob/master/example/lib/main.dart) file.

## Contribution

Contributions to the Date Picker library are welcome! If you find any issues or have suggestions for improvement, please create a new issue or submit a pull request on the [GitHub repository](https://github.com/hasanmhallak/date_picker).

Before creating a PR:

- Please make sure to cover any new feature with proper tests.
- Please make sure that all tests passed.
- Please always create an issue/feature before raising a PR.
- Please always create a minimum reproducible example for an issue.
- Please use the official [Dart Extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code) as your formatter or use `flutter format .` if you are not using VS Code.
- Please keep your changes to its minimum needed scope (avoid introducing unrelated changes).

## License

The Date Picker library is licensed under the [MIT License](https://opensource.org/licenses/MIT). See the [LICENSE](https://github.com/hasanmhallak/date_picker/blob/master/LICENSE) file for more details.
