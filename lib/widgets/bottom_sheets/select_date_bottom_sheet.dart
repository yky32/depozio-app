import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:depozio/core/extensions/localizations.dart';

/// Custom input formatter for hours (00-23)
class _HoursInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Allow empty input
    if (text.isEmpty) {
      return newValue;
    }

    // Only allow digits
    if (!RegExp(r'^\d+$').hasMatch(text)) {
      return oldValue;
    }

    // Limit to 2 digits
    if (text.length > 2) {
      return oldValue;
    }

    // Validate hours (00-23)
    final hours = int.tryParse(text);
    if (hours != null && hours > 23) {
      return oldValue;
    }

    return newValue;
  }
}

/// Custom input formatter for minutes (00-59)
class _MinutesInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Allow empty input
    if (text.isEmpty) {
      return newValue;
    }

    // Only allow digits
    if (!RegExp(r'^\d+$').hasMatch(text)) {
      return oldValue;
    }

    // Limit to 2 digits
    if (text.length > 2) {
      return oldValue;
    }

    // Validate minutes (00-59)
    final minutes = int.tryParse(text);
    if (minutes != null && minutes > 59) {
      return oldValue;
    }

    return newValue;
  }
}

/// Bottom sheet for selecting a date with a calendar picker
/// Matches the app's design language
class SelectDateBottomSheet extends StatefulWidget {
  const SelectDateBottomSheet({super.key, required this.initialDate});

  final DateTime initialDate;

  @override
  State<SelectDateBottomSheet> createState() => _SelectDateBottomSheetState();
}

class _SelectDateBottomSheetState extends State<SelectDateBottomSheet> {
  late DateTime _selectedDate;
  late TextEditingController _hoursController;
  late TextEditingController _minutesController;
  late FocusNode _hoursFocusNode;
  late FocusNode _minutesFocusNode;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _hoursController = TextEditingController(
      text: DateFormat('HH').format(widget.initialDate),
    );
    _minutesController = TextEditingController(
      text: DateFormat('mm').format(widget.initialDate),
    );
    _hoursFocusNode = FocusNode();
    _minutesFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _hoursFocusNode.dispose();
    _minutesFocusNode.dispose();
    super.dispose();
  }

  void _updateSelectedTime() {
    final hoursText = _hoursController.text;
    final minutesText = _minutesController.text;

    // Only update if both fields have valid values
    if (hoursText.isEmpty || minutesText.isEmpty) {
      return;
    }

    final hours = int.tryParse(hoursText);
    final minutes = int.tryParse(minutesText);

    if (hours == null || minutes == null) {
      return;
    }

    // Validate hours and minutes
    if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59) {
      return;
    }

    // Update selected date with new time
    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        hours,
        minutes,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final keyboardHeight = mediaQuery.viewInsets.bottom;

    // Calculate dynamic height - use 60-70% of screen height
    final minHeight = screenHeight * 0.6; // 60% minimum
    final maxHeight = screenHeight * 0.7; // 70% maximum
    final availableHeight = screenHeight - keyboardHeight;

    // Use 65% as default, but ensure it fits within 60-70% range
    final targetHeight = screenHeight * 0.65;
    final dynamicHeight = targetHeight.clamp(
      minHeight.clamp(0.0, availableHeight),
      maxHeight.clamp(0.0, availableHeight),
    );

    return Container(
      height: dynamicHeight,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              alignment: Alignment.center,
              child: Container(
                width: 80,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Text(
              context.l10n.select_datetime_title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Selected date and time display
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 0,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: colorScheme.primary,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  DateFormat(
                                    'MMM d, yyyy',
                                  ).format(_selectedDate),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Time input fields (HH : mm)
                        Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Hours input
                              Container(
                                width: 50,
                                height: 48,
                                alignment: Alignment.center,
                                child: TextField(
                                  controller: _hoursController,
                                  focusNode: _hoursFocusNode,
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    _HoursInputFormatter(),
                                  ],
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.primary,
                                    letterSpacing: 0.5,
                                    height: 1.0,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                  ),
                                  onChanged: (value) {
                                    _updateSelectedTime();
                                    // Auto-focus minutes when hours is complete
                                    if (value.length == 2) {
                                      _minutesFocusNode.requestFocus();
                                    }
                                  },
                                  onTapOutside:
                                      (event) => _hoursFocusNode.unfocus(),
                                ),
                              ),
                              // Colon separator
                              Container(
                                height: 48,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: Text(
                                  ':',
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: colorScheme.primary,
                                        height: 1.0,
                                      ),
                                ),
                              ),
                              // Minutes input
                              Container(
                                width: 50,
                                height: 48,
                                alignment: Alignment.center,
                                child: TextField(
                                  controller: _minutesController,
                                  focusNode: _minutesFocusNode,
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    _MinutesInputFormatter(),
                                  ],
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.primary,
                                    letterSpacing: 0.5,
                                    height: 1.0,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                  ),
                                  onChanged: (value) {
                                    _updateSelectedTime();
                                  },
                                  onTapOutside:
                                      (event) => _minutesFocusNode.unfocus(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Custom calendar with Sundays in red
                    _CustomCalendarDatePicker(
                      selectedDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      currentDate: DateTime.now(),
                      theme: theme,
                      colorScheme: colorScheme,
                      onDateChanged: (date) {
                        setState(() {
                          // Preserve time when date changes
                          _selectedDate = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            _selectedDate.hour,
                            _selectedDate.minute,
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Combine selected date with time from input fields
                      final hoursText = _hoursController.text;
                      final minutesText = _minutesController.text;

                      int hours = _selectedDate.hour;
                      int minutes = _selectedDate.minute;

                      // Parse hours
                      if (hoursText.isNotEmpty) {
                        final parsedHours = int.tryParse(hoursText);
                        if (parsedHours != null &&
                            parsedHours >= 0 &&
                            parsedHours <= 23) {
                          hours = parsedHours;
                        }
                      }

                      // Parse minutes
                      if (minutesText.isNotEmpty) {
                        final parsedMinutes = int.tryParse(minutesText);
                        if (parsedMinutes != null &&
                            parsedMinutes >= 0 &&
                            parsedMinutes <= 59) {
                          minutes = parsedMinutes;
                        }
                      }

                      final finalDateTime = DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                        hours,
                        minutes,
                      );
                      Navigator.of(context).pop(finalDateTime);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom calendar date picker that makes Sundays red
class _CustomCalendarDatePicker extends StatefulWidget {
  const _CustomCalendarDatePicker({
    required this.selectedDate,
    required this.firstDate,
    required this.lastDate,
    required this.currentDate,
    required this.theme,
    required this.colorScheme,
    required this.onDateChanged,
  });

  final DateTime selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime currentDate;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final ValueChanged<DateTime> onDateChanged;

  @override
  State<_CustomCalendarDatePicker> createState() =>
      _CustomCalendarDatePickerState();
}

class _CustomCalendarDatePickerState extends State<_CustomCalendarDatePicker> {
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      1,
    );
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
        1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final colorScheme = widget.colorScheme;
    final monthName = DateFormat('MMMM yyyy').format(_displayedMonth);
    final firstDayOfMonth = _displayedMonth;
    final lastDayOfMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      0,
    );
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday; // 1 = Monday, 7 = Sunday

    // Calculate days to show (including previous month's trailing days)
    final days = <DateTime>[];
    // Add previous month's trailing days
    // firstWeekday: 1=Mon, 2=Tue, ..., 7=Sun
    // We want: 1=Mon -> 1 day before, 2=Tue -> 2 days before, ..., 7=Sun -> 0 days before
    final daysBefore = firstWeekday % 7; // 7 % 7 = 0, 1 % 7 = 1, etc.
    if (daysBefore > 0) {
      final prevMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
        0,
      );
      for (int i = prevMonth.day - daysBefore + 1; i <= prevMonth.day; i++) {
        days.add(DateTime(prevMonth.year, prevMonth.month, i));
      }
    }
    // Add current month's days
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(DateTime(_displayedMonth.year, _displayedMonth.month, i));
    }
    // Add next month's leading days to fill the grid
    final remainingDays = 42 - days.length; // 6 weeks * 7 days
    for (int i = 1; i <= remainingDays; i++) {
      days.add(DateTime(_displayedMonth.year, _displayedMonth.month + 1, i));
    }

    return Column(
      children: [
        // Month header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                iconSize: 28,
                onPressed: _previousMonth,
                color: colorScheme.onSurface,
              ),
              Text(
                monthName,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                iconSize: 28,
                onPressed: _nextMonth,
                color: colorScheme.onSurface,
              ),
            ],
          ),
        ),
        // Weekday headers
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children:
                ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                    .map(
                      (day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
        const SizedBox(height: 12),
        // Calendar grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              for (int week = 0; week < 6; week++)
                Row(
                  children: [
                    for (int day = 0; day < 7; day++)
                      Expanded(
                        child: _CalendarDay(
                          date: days[week * 7 + day],
                          isCurrentMonth:
                              days[week * 7 + day].month ==
                              _displayedMonth.month,
                          isSelected:
                              days[week * 7 + day].year ==
                                  widget.selectedDate.year &&
                              days[week * 7 + day].month ==
                                  widget.selectedDate.month &&
                              days[week * 7 + day].day ==
                                  widget.selectedDate.day,
                          isToday:
                              days[week * 7 + day].year ==
                                  widget.currentDate.year &&
                              days[week * 7 + day].month ==
                                  widget.currentDate.month &&
                              days[week * 7 + day].day ==
                                  widget.currentDate.day,
                          isSunday: days[week * 7 + day].weekday == 7,
                          isEnabled:
                              days[week * 7 + day].isAfter(
                                widget.firstDate.subtract(
                                  const Duration(days: 1),
                                ),
                              ) &&
                              days[week * 7 + day].isBefore(
                                widget.lastDate.add(const Duration(days: 1)),
                              ),
                          theme: theme,
                          colorScheme: colorScheme,
                          onTap: () {
                            if (days[week * 7 + day].isAfter(
                                  widget.firstDate.subtract(
                                    const Duration(days: 1),
                                  ),
                                ) &&
                                days[week * 7 + day].isBefore(
                                  widget.lastDate.add(const Duration(days: 1)),
                                )) {
                              widget.onDateChanged(days[week * 7 + day]);
                            }
                          },
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Individual calendar day widget
class _CalendarDay extends StatelessWidget {
  const _CalendarDay({
    required this.date,
    required this.isCurrentMonth,
    required this.isSelected,
    required this.isToday,
    required this.isSunday,
    required this.isEnabled,
    required this.theme,
    required this.colorScheme,
    required this.onTap,
  });

  final DateTime date;
  final bool isCurrentMonth;
  final bool isSelected;
  final bool isToday;
  final bool isSunday;
  final bool isEnabled;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Determine text color
    Color textColor;
    if (isSelected) {
      // Selected days use onPrimary color (white)
      textColor = colorScheme.onPrimary;
    } else if (isSunday && isCurrentMonth && isEnabled) {
      // Sundays in current month are red
      textColor = Colors.red;
    } else if (isCurrentMonth) {
      // Regular days in current month
      textColor = colorScheme.onSurface;
    } else {
      // Days from other months
      textColor = colorScheme.onSurface.withValues(alpha: 0.3);
    }

    if (!isEnabled && !isSelected) {
      textColor = textColor.withValues(alpha: 0.3);
    }

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? colorScheme.primary
                  : isToday
                  ? colorScheme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: textColor,
              fontWeight:
                  isSelected || isToday ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
