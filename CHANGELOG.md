# 7.0.0 [Breaking]

## Theming API

All per-widget styling parameters on `DatePicker`, `RangeDatePicker`, `DaysPicker`, `RangeDaysPicker`, `MonthPicker`, `YearsPicker`, `showDatePickerDialog`, and `showRangePickerDialog` were removed. Use a single `theme` argument of type `DatePickerPlusTheme` instead.

Removed parameters (names vary slightly between single-date and range pickers):

- `daysOfTheWeekTextStyle`
- `enabledCellsTextStyle` / `enabledCellsDecoration`
- `disabledCellsTextStyle` / `disabledCellsDecoration`
- `currentDateTextStyle` / `currentDateDecoration`
- `selectedCellTextStyle` / `selectedCellDecoration`
- On range pickers: `selectedCellsTextStyle` / `selectedCellsDecoration`, `singleSelectedCellTextStyle` / `singleSelectedCellDecoration`
- `leadingDateTextStyle`
- `slidersColor` / `slidersSize`
- `highlightColor` / `splashColor` / `splashRadius`
- `centerLeadingDate`

**How to fix:** Build a `DatePickerPlusTheme` and pass it as `theme:`. It merges with `DatePickerPlusTheme.defaults(context)` and any `Theme.of(context).extension<DatePickerPlusTheme>()`.

```dart
// Before (v6)
DatePicker(
  minDate: minDate,
  maxDate: maxDate,
  initialDate: DateTime.now(),
  slidersColor: Colors.blue,
  centerLeadingDate: true,
  selectedCellDecoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
);

// After (v7)
DatePicker(
  minDate: minDate,
  maxDate: maxDate,
  displayedDate: DateTime.now(),
  theme: const DatePickerPlusTheme(
    headerTheme: HeaderTheme(
      centerLeadingDate: true,
    ),
    daysPickerTheme: DaysPickerTheme(
      selectedCellDecoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
    ),
    // Notice how each picker has its own theme now.
    monthsPickerTheme: MonthsPickerTheme(
      selectedCellDecoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
    ),
    yearsPickerTheme: YearsPickerTheme(
      selectedCellDecoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
    ),
    rangePickerTheme: RangePickerTheme(
      selectedCellsDecoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
    ),
  ),
);
```

You can also register defaults app-wide via `ThemeData.extensions`:

```dart
MaterialApp(
  theme: ThemeData(
    extensions: const <ThemeExtension<dynamic>>[
      DatePickerPlusTheme(
        headerTheme: HeaderTheme(centerLeadingDate: true),
      ),
    ],
  ),
);
```

For defaults that depend on `ColorScheme` / `TextTheme`, build the extension where you have a `BuildContext` (e.g. inside `build`) or merge `DatePickerPlusTheme.defaults(context)` with your overrides on each picker’s `theme` argument.

## `initialDate` renamed to `displayedDate`

On all pickers and on `showDatePickerDialog` / `showRangePickerDialog`, rename `initialDate` to `displayedDate`. Behavior is unchanged: it controls which month/year grid is shown first.

```dart
// Before
showDatePickerDialog(context: context, minDate: minDate, maxDate: maxDate, initialDate: someDate);

// After
showDatePickerDialog(context: context, minDate: minDate, maxDate: maxDate, displayedDate: someDate);
```

## Removed `previousPageSemanticLabel` & `nextPageSemanticLabel`

All semantic labels are now managed internally using Material localizations.

## New in v7

- **`onDisplayedMonthChanged`:** Fires when the days grid’s visible month changes (including initial build and page swipes). Argument is the first day of that month. Available on `DatePicker`, `RangeDatePicker`, `DaysPicker`, `RangeDaysPicker`, and both dialog helpers.

- **`cellBuilder`:** Optional `CellBuilder` to customize cells. Uses `CellData` variants (`WeekDayCell`, `DayCell`, `MonthCell`, `YearCell`) and `CellState`.

- **`DatePickerPlusTheme.isEnabled`:** When `false`, the picker is view-only (no taps, header navigation, or page swipes).

- **`HeaderTheme.forwardButtonDecoration` / `backwardButtonDecoration` narrowed to `ShapeDecoration` [Breaking]:** The type was `Decoration?` and is now `ShapeDecoration?`. This eliminates an internal conversion heuristic that could not reliably derive an ink-clip shape from arbitrary `Decoration` subclasses. Migrate by replacing any `BoxDecoration` passed to these fields with an equivalent `ShapeDecoration`:

  ```dart
  // Before
  forwardButtonDecoration: BoxDecoration(
    borderRadius: BorderRadius.circular(6),
    color: Colors.red,
  ),

  // After
  forwardButtonDecoration: ShapeDecoration(
    color: Colors.red,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
  ),
  ```

- **Non-square grid cells and the range picker:** Grid cell width and height are now fully independent (width from `columnCount`, height from `rowCount`), enabling taller cells for content such as event dots below the day number. When cells are taller than they are wide, the default circle edge decoration will be smaller than the full-height range highlight rectangle painted by `RangeSelectionPainter`. Use `OvalBorder` or `StadiumBorder` for `RangePickerTheme.selectedEdgeCellDecoration` to match the highlight, or supply a custom painter via `RangePickerTheme.resolvePainter`:

  ```dart
  rangePickerTheme: RangePickerTheme(
    selectedEdgeCellDecoration: ShapeDecoration(
      color: colorScheme.primary,
      shape: const OvalBorder(),
    ),
  ),
  ```

# 6.0.0

- Revert removing `DeviceOrientationBuilder` in favor of rename it.
- Fix semantic. fixes [#39](https://github.com/hasanmhallak/date_picker/issues/39)
- Resolve conflicts with Flutter v3.41.0. fixes [#43](https://github.com/hasanmhallak/date_picker/issues/43)
- Add decoration to the pageview arrow buttons.

# 5.0.0

- Remove `DeviceOrientationBuilder` in favor of Flutter Native one interduce in Material Package.
- Add Flutter v27.0.0 and dart 3.6 constraints.

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
- Fixed forward & back arrow buttons in RTL.

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
