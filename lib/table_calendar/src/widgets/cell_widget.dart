//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0

part of table_calendar;

class _CellWidget extends StatelessWidget {
  final String text;
  final bool isUnavailable;
  final bool isSelected;
  final bool isToday;
  final bool isDone;
  final IconData iconCW;
  final bool isDV;
  final bool isWeekend;
  final bool isOutsideMonth;
  final bool isHoliday;
  final bool isEventDay;
  final CalendarStyle calendarStyle;

  const _CellWidget({
    Key key,
    @required this.text,
    this.isUnavailable = false,
    this.isSelected = false,
    this.isToday = false,
    this.isDone = false,
    this.isDV = false,
    this.iconCW,
    this.isWeekend = false,
    this.isOutsideMonth = false,
    this.isHoliday = false,
    this.isEventDay = false,
    @required this.calendarStyle,
  })  : assert(text != null),
        assert(calendarStyle != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: _buildCellDecoration(),
      margin: calendarStyle.cellMargin,
      alignment: Alignment.center,
      child: isDone&&isDV?Icon(iconCW,color:Colors.white):Text(
        text,
        style: _buildCellTextStyle(),
      ),
    );
  }

  Decoration _buildCellDecoration() {
    if (isSelected &&
        calendarStyle.renderSelectedFirst &&
        calendarStyle.highlightSelected&&!isDV) {
      return BoxDecoration(
          shape: BoxShape.circle, color: calendarStyle.selectedColor);
    } else if (isToday && calendarStyle.highlightToday&&!isDV) {
      return BoxDecoration(
          shape: BoxShape.circle, color: calendarStyle.todayColor);
    } else if (isSelected && calendarStyle.highlightSelected&&!isDV) {
      return BoxDecoration(
          shape: BoxShape.circle, color: calendarStyle.selectedColor);
    } 
    else if (isToday&&isDV) {
      return BoxDecoration(
          shape: BoxShape.circle, color: isDone?calendarStyle.selectedColor:calendarStyle.todayColor
          // border: BoxBorder()
          );
    }
    else if (isDone&&isDV) {
      return BoxDecoration(
          shape: BoxShape.circle, color: calendarStyle.selectedColor);
    }
    else {
      return BoxDecoration(shape: BoxShape.circle);
    }
  }

  TextStyle _buildCellTextStyle() {
    if (isUnavailable) {
      return calendarStyle.unavailableStyle;
    } else if (isSelected &&
        calendarStyle.renderSelectedFirst &&
        calendarStyle.highlightSelected&&!isDV) {
      return calendarStyle.selectedStyle;
    } else if (isToday && calendarStyle.highlightToday&&!isDV) {
      return calendarStyle.todayStyle;
    } else if (isSelected && calendarStyle.highlightSelected&&!isDV) {
      return calendarStyle.selectedStyle;
    }else if (isToday&&isDV) {
      return isDone?calendarStyle.selectedStyle:calendarStyle.todayStyle;
    }else if (isDone&&isDV) {
      return calendarStyle.selectedStyle;
    } else if (isOutsideMonth && isHoliday) {
      return calendarStyle.outsideHolidayStyle;
    } else if (isHoliday) {
      return calendarStyle.holidayStyle;
    } else if (isOutsideMonth && isWeekend) {
      return calendarStyle.outsideWeekendStyle;
    } else if (isOutsideMonth) {
      return calendarStyle.outsideStyle;
    } else if (isWeekend) {
      return calendarStyle.weekendStyle;
    } else if (isEventDay) {
      return calendarStyle.eventDayStyle;
    } else {
      return calendarStyle.weekdayStyle;
    }
  }
}
