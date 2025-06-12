# 4.2.0

- Adding pass-thru callbacks for onLeadingDateTap, onStartDateChanged, and onEndDateChanged for the RangeDatePicker widget. thanks to @coogle [here.](https://github.com/hasanmhallak/date_picker/pull/33)

# 4.1.0

- Add `disabledDayPredicate` to provide a way to disable days with custom logic.

```dart
SizedBox(
  height: 400,
  child: DatePicker(
    centerLeadingDate: true,
    minDate: DateTime(2020, 10, 10),
    maxDate: DateTime(2024, 10, 30),
    disabledDayPredicate: (date) {
      // This will disable every Sunday and Monday.
      return date.weekday == DateTime.sunday || date.weekday == DateTime.monday;
    },
  ),
),
```

# 4.0.0 [Breaking]

This update introduces significant changes to the layout behavior of the picker. It now adapts to small sizes up to 150x150px, providing more flexibility in integrating the widget tree to match your design aesthetics.

The picker will only be assigned a preset size when it's unconstrained, e.g., when used inside Flex Widgets or a scrollable widget. This allows for customizable sizing of the picker according to your needs.

You should always specify the desired size for the picker as shown below:

```dart
SizedBox(
  width: 300,
  height: 400,
  child: RangeDatePicker(
    centerLeadingDate: true,
    minDate: DateTime(2020, 10, 10),
    maxDate: DateTime(2024, 10, 30),
  ),
),
```

For the DatePicker dialog, it now has a preset size that adapts to both landscape and portrait orientations. The size can be adjusted using the method parameters:

```dart
final date = await showDatePickerDialog(
  context: context,
  minDate: DateTime(2020, 10, 10),
  maxDate: DateTime(2024, 10, 30),
  width: 300,
  height: 300,
);
```

- Fixed an overflow issue when displaying the picker dialog with the keyboard open.
- Fixed an overflow issue when the device orientation is set to portrait mode.
- Fixed forward & back sliders button in RTL.

# 3.0.2

- Add semantic labels for next/previous button see [#21](https://github.com/hasanmhallak/date_picker/issues/21)

# 3.0.1

- Fix Assertions issue see [#18](https://github.com/hasanmhallak/date_picker/issues/18)

# 3.0.0 [Breaking]

- Fix Assertions issue see [#14](https://github.com/hasanmhallak/date_picker/issues/14)
- Fix Types see [#13](https://github.com/hasanmhallak/date_picker/issues/13)

# 2.1.0

- Ignore time in all DateTime classes. fixes [#11](https://github.com/hasanmhallak/date_picker/issues/11)
- User now can pick the same date as a range fixes [#10](https://github.com/hasanmhallak/date_picker/issues/10)
- User now can choose to center the leading date or not fixes [#10](https://github.com/hasanmhallak/date_picker/issues/10)

# 2.0.3

- Add `cupertino_icons` to dependencies. Closes [#9](https://github.com/hasanmhallak/date_picker/issues/9)

# 2.0.2

- Fix Images url in README.md
- Fix Broken golden tests.

# 2.0.0 [Breaking]

- Add `RangeDatePicker`.
- Remove color properties in favor of providing a textStyle.
- Rename properties to avoid confusion.
- Expose `DaysPicker`, `MonthPicker`, `YearsPicker` widgets to use
  instead of using a full picker.
- Update docs and README and Example.

# 1.1.3

- Add ability to modify splash & highlight colors.

# 1.1.2

- fix docs

# 1.1.1

- Add the ability to customize header.

# 1.1.0

- Update to flutter 3.10
- Fix ReadMe.
- Add library screenshots.

## 1.0.2

- Change library name.

## 1.0.1

- Fix example url in Readme.

## 1.0.0

- initial release.
