import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:obsi/src/core/date_time_dialog.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

List<TextSpan> buildHighlightedTextSpans(String text, String highlight,
    TextStyle defaultStyle, TextStyle highlightedStyle) {
  final spans = <TextSpan>[];

  if (highlight.isEmpty || text.isEmpty) {
    return [TextSpan(text: text, style: defaultStyle)];
  }

  final lowerText = text.toLowerCase();
  final lowerHighlight = highlight.toLowerCase();
  final parts = lowerText.split(lowerHighlight);
  int currentIndex = 0;

  for (var i = 0; i < parts.length; i++) {
    if (parts[i].isNotEmpty) {
      spans.add(TextSpan(
          text: text.substring(currentIndex, currentIndex + parts[i].length),
          style: defaultStyle));
      currentIndex += parts[i].length;
    }

    if (i < parts.length - 1) {
      spans.add(TextSpan(
        text: text.substring(currentIndex, currentIndex + highlight.length),
        style: highlightedStyle,
      ));
      currentIndex += highlight.length;
    }
  }
  return spans;
}

Widget addDateTimePicker(Text showDateTime, DateTime? selectorDateTime,
    BuildContext context, Function(DateTime) dateTimeSelected,
    {bool timePicker = false, bool dateTimePicker = false}) {
  return TextButton(
      onPressed: () {
        if (timePicker) {
          DatePicker.showTimePicker(context,
              showTitleActions: true,
              showSecondsColumn: false,
              onConfirm: dateTimeSelected,
              currentTime: selectorDateTime,
              locale: LocaleType.en);
        } else {
          showCalendarDatePicker2Dialog(
            context: context,
            config: CalendarDatePicker2WithActionButtonsConfig(
              firstDate: DateTime(1990),
              lastDate: DateTime(2100),
              currentDate: DateTime.now(),
              calendarType: CalendarDatePicker2Type.single,
            ),
            dialogSize: const Size(325, 400),
            value: [selectorDateTime],
            borderRadius: BorderRadius.circular(15),
          ).then((List<DateTime?>? dates) {
            if (dates != null && dates.isNotEmpty && dates[0] != null) {
              dateTimeSelected(dates[0]!);
            }
          });
        }
      },
      child: showDateTime);
}
