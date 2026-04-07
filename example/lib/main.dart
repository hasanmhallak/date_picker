import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('en', 'US'),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('en', 'GB'),
        Locale('en', 'US'),
        Locale('ar'),
        Locale('zh'),
      ],
      home: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 238, 239, 250),
            appBar: AppBar(
              title: const Text('Date Picker Plus'),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            border: Border.all(
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: DatePicker(
                              minDate: DateTime(2020),
                              maxDate: DateTime(2050),
                              padding: EdgeInsets.zero,
                              initialPickerType: PickerType.years,
                              displayedDate: DateTime.now(),
                              currentDate: DateTime.now(),
                              selectedDate: DateTime.now(),
                              theme: DatePickerPlusTheme(
                                headerTheme: HeaderTheme(
                                  decoration: BoxDecoration(color: Colors.red[400]),
                                  headerPadding: const EdgeInsets.all(4),
                                  centerLeadingDate: true,
                                  enableArrowKeys: false,
                                  leadingDateTextStyle: const TextStyle(fontSize: 8, color: Colors.white),
                                ),
                                yearsPickerTheme: const YearsPickerTheme(
                                  cellsPadding: EdgeInsets.all(2),
                                  currentDateTextStyle: TextStyle(fontSize: 8),
                                  disabledCellsTextStyle: TextStyle(fontSize: 8),
                                  enabledCellsTextStyle: TextStyle(fontSize: 8),
                                  selectedCellTextStyle: TextStyle(fontSize: 8),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            border: Border.all(
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: DatePicker(
                              minDate: DateTime(2020),
                              maxDate: DateTime(2050),
                              padding: EdgeInsets.zero,
                              initialPickerType: PickerType.days,
                              displayedDate: DateTime(2025, 11, 30),
                              currentDate: DateTime.now(),
                              selectedDate: DateTime.now(),
                              theme: DatePickerPlusTheme(
                                headerTheme: HeaderTheme(
                                  decoration: BoxDecoration(color: Colors.red[400]),
                                  headerPadding: const EdgeInsets.all(4),
                                  centerLeadingDate: true,
                                  enableArrowKeys: false,
                                  leadingDateTextStyle: const TextStyle(fontSize: 8, color: Colors.white),
                                ),
                                daysPickerTheme: const DaysPickerTheme(
                                  cellsPadding: EdgeInsets.zero,
                                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                  daysOfTheWeekTheme: DaysOfTheWeekTheme(
                                      textStyle: TextStyle(fontSize: 8), weekdayLength: WeekdayLength.narrow),
                                  currentDateTextStyle: TextStyle(fontSize: 8),
                                  disabledCellsTextStyle: TextStyle(fontSize: 8),
                                  enabledCellsTextStyle: TextStyle(fontSize: 8),
                                  selectedCellTextStyle: TextStyle(fontSize: 8),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            border: Border.all(
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: DatePicker(
                              minDate: DateTime(2020),
                              maxDate: DateTime(2050),
                              padding: EdgeInsets.zero,
                              initialPickerType: PickerType.months,
                              displayedDate: DateTime.now(),
                              currentDate: DateTime.now(),
                              selectedDate: DateTime.now(),
                              theme: DatePickerPlusTheme(
                                headerTheme: HeaderTheme(
                                  decoration: BoxDecoration(color: Colors.red[400]),
                                  headerPadding: const EdgeInsets.all(4),
                                  centerLeadingDate: true,
                                  enableArrowKeys: false,
                                  leadingDateTextStyle: const TextStyle(fontSize: 8, color: Colors.white),
                                ),
                                monthsPickerTheme: const MonthsPickerTheme(
                                  cellsPadding: EdgeInsets.all(2),
                                  currentDateTextStyle: TextStyle(fontSize: 8),
                                  disabledCellsTextStyle: TextStyle(fontSize: 8),
                                  enabledCellsTextStyle: TextStyle(fontSize: 8),
                                  selectedCellTextStyle: TextStyle(fontSize: 8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: MediaQuery.of(context).size.width - 80,
                      height: MediaQuery.of(context).size.width - 60,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 238, 239, 250),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.8),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: const Offset(-2, -2),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.18),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(4, 4),
                            ),
                          ]),
                      child: DatePicker(
                        minDate: DateTime(2020),
                        maxDate: DateTime(2050),
                        padding: EdgeInsets.zero,
                        displayedDate: DateTime(2026, 5, 26),
                        currentDate: DateTime.now(),
                        selectedDate: DateTime(2026, 5, 26),
                        cellBuilder: (context, data) {
                          if (data case DayCell cell when cell.day.day == 14) {
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                cell.child,
                                Positioned(
                                  right: 4,
                                  top: -2,
                                  child: Badge.count(
                                    count: 6,
                                    backgroundColor: const Color.fromARGB(255, 253, 28, 33),
                                  ),
                                ),
                              ],
                            );
                          }
                          if (data case DayCell cell when cell.day.day == 11) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 6),
                                const Text(
                                  '11',
                                  style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w300),
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 2,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.rectangle,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Flexible(
                                      child: Text(
                                        'Event',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 8, color: Colors.black, fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                          return data.child;
                        },
                        theme: DatePickerPlusTheme(
                          daysPickerTheme: DaysPickerTheme(
                            daysOfTheWeekTheme: const DaysOfTheWeekTheme(
                                textStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
                            cellsPadding: const EdgeInsets.all(6),
                            enabledCellsTextStyle:
                                const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w300),
                            selectedCellTextStyle:
                                const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w300),
                            selectedCellDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              gradient: const LinearGradient(
                                end: Alignment.centerLeft,
                                begin: Alignment.centerRight,
                                colors: [
                                  Color.fromARGB(255, 251, 79, 80),
                                  Color.fromARGB(255, 253, 28, 33),
                                ],
                              ),
                            ),
                          ),
                          headerTheme: HeaderTheme(
                            headerPadding: const EdgeInsets.all(14),
                            centerLeadingDate: false,
                            leadingDateTextStyle: const TextStyle(fontSize: 20, color: Colors.black),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey[300]!, width: 2),
                              ),
                            ),
                            forwardButtonDecoration: ShapeDecoration(
                              gradient: const LinearGradient(
                                end: Alignment.centerLeft,
                                begin: Alignment.centerRight,
                                colors: [
                                  Color.fromARGB(255, 251, 79, 80),
                                  Color.fromARGB(255, 253, 28, 33),
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            forwardButtonHeight: 30,
                            forwardButtonWidth: 38,
                            forwardArrowWidget:
                                const Icon(Icons.arrow_forward_ios_rounded, size: 20, color: Colors.white),
                            backwardButtonDecoration: ShapeDecoration(
                              gradient: const LinearGradient(
                                end: Alignment.centerLeft,
                                begin: Alignment.centerRight,
                                colors: [
                                  Color.fromARGB(255, 251, 79, 80),
                                  Color.fromARGB(255, 253, 28, 33),
                                ],
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            backwardButtonHeight: 30,
                            backwardButtonWidth: 38,
                            backwardArrowWidget:
                                const Icon(Icons.arrow_back_ios_rounded, size: 20, color: Colors.white),
                            arrowButtonsSpace: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
