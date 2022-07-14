import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:left_scroll_actions/cupertinoLeftScroll.dart';
import 'package:timemachine/pages/actions/editEvent.dart';
import '../../table_calendar/table_calendar.dart';
import 'package:timemachine/bean.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with TickerProviderStateMixin {
  Map<DateTime, List> _events; //<LCObject>

  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  ValueNotifier<DateTime> _selectedDay; 

  Future<List<LCObject>> retrieveData() async {
    LCQuery<LCObject> query = LCQuery('Event');
    LCUser _user = await LCUser.getCurrent();
    query.whereEqualTo('user', _user); //查询
    List<LCObject> results = await query.find();
    return (results);
  }

  _alertDialog({String name, DateTime date, DateTime time}) async {
    var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('日程：' + name),
            content: Text('时间：' +
                '${date.year}-${date.month}-${date.day} ' +
                (time != null
                    ? TimeOfDay(hour: time.hour, minute: time.minute)
                        .format(context)
                    : '全天')),
          );
        });
    print(result);
  }

  @override
  void initState() {
    print('init');
    _selectedDay = ValueNotifier<DateTime>(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    ///////////holiday
    print('CALLBACK: _onDaySelected');
    _selectedDay.value = DateTime(day.year, day.month, day.day);
  }

  // void _onVisibleDaysChanged(
  //     DateTime first, DateTime last, CalendarFormat format) {
  //   print('CALLBACK: _onVisibleDaysChanged');
  // }
  // void _onCalendarCreated(
  //     DateTime first, DateTime last, CalendarFormat format) {
  //   print('CALLBACK: _onCalendarCreated');
  // }

  @override
  Widget build(BuildContext context) {
    print('build');
    return FutureBuilder<List<LCObject>>(
      future: retrieveData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            _events = {};
            for (LCObject event in snapshot.data) {
              if (!_events.containsKey(event['date'])) {
                _events[event['date']] = [event];
              } else {
                _events[event['date']].add(event);
              }
            }
            // _selectedEvents = _events[_selected] ?? [];
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  height: 17,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 8, color: Colors.brown),
                          bottom:
                              BorderSide(width: 2, color: Colors.brown[300]))),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 15),
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1.6, color: Colors.grey
                              // Colors.brown[300]
                              // Color(0xffe5e5e5)
                              ))),
                  child: //Container()
                      // Switch out 2 lines below to play with TableCalendar's settings
                      //-----------------------👇
                      _buildTableCalendar(), //日历部分 圈圈
                  // _buildTableCalendarWithBuilders(),//日历部分 方块
                ),
                Expanded(child: _buildEventList()),
              ],
              // ),
            );
          }
        } else {
          // 请求未结束，显示loading
          return Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.deepOrange)));
        }
      },
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    print('calendar');
    print(_selectedDay);
    return TableCalendar(
      calendarController: _calendarController,
      events: _events, ///////////
      // holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.monday, //周起始
      calendarStyle: CalendarStyle(
        // selectedColor: Colors.deepOrange[400],
        // todayColor: Colors.deepOrange[200],
        // markersColor: Colors.brown[700],
        outsideDaysVisible: false, //不明白
      ),
      headerStyle: HeaderStyle(
        //橘色模式按钮
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      // onVisibleDaysChanged: _onVisibleDaysChanged,
      // onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventList() {
    print('events');
    print(_selectedDay);
    return ValueListenableBuilder(
      valueListenable: _selectedDay,
      builder: (BuildContext context, value, Widget child) {
        _selectedEvents = _events[_selectedDay.value] ?? [];
        _selectedEvents.sort(
            (a, b) => a['time'].toString().compareTo(b['time'].toString()));
        return ListView(
          children: _selectedEvents
              .map((event) => CupertinoLeftScroll(
                      key: Key(event.hashCode.toString()),
                      // closeTag: LeftScrollCloseTag('todo'),
                      buttonWidth: 60,
                      bounce: true,
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 2, color: Colors.deepOrange[200]
                                // Color(0xffe5e5e5)
                                ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: ListTile(
                              // tileColor:Colors.deepOrange[50],
                              title: Text(event['name'],
                                  style: TextStyle(
                                      color: Colors.brown[800], fontSize: 17)),
                              trailing: Text(
                                  event['time'] != null
                                      ? TimeOfDay(
                                              hour: event['time'].hour,
                                              minute: event['time'].minute)
                                          .format(context)
                                      : '全天',
                                  style: TextStyle(color: Colors.grey[700])),
                              onTap: () {
                                _alertDialog(
                                    name: event['name'],
                                    date: event['date'],
                                    time: event['time']);
                              })),
                      buttons: <Widget>[
                        InkWell(
                          child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(right: 8),
                              color: backgroundColor,
                              child: Icon(
                                Icons.delete,
                                color: Colors.deepOrange[600],
                                size: 30,
                              )),
                          onTap: () async {
                            await event.delete();
                            setState(() {});
                          },
                        ),
                        InkWell(
                          child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(right: 8),
                              color: backgroundColor,
                              child: Icon(
                                Icons.create,
                                color: Colors.deepOrange[600],
                                size: 30,
                              )),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => new EditEventPage(
                                          event: event,
                                        )));
                            setState(() {
                              _selectedDay = ValueNotifier<DateTime>(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
                            });
                          },
                        ),
                      ]))
              .toList(),
        );
      },
    );
  }
}
