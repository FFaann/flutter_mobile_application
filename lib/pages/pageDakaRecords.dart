import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:timemachine/bean.dart';
import 'package:timemachine/pages/actions/editDaka.dart';
import 'package:timemachine/tabs.dart';
import '../../table_calendar/table_calendar.dart';

class DakaRecordsPage extends StatefulWidget {
  LCObject daka;

  DakaRecordsPage({Key key, this.daka}) : super(key: key);
  @override
  _DakaRecordsPageState createState() => _DakaRecordsPageState(this.daka);
}

class _DakaRecordsPageState extends State<DakaRecordsPage>
    with TickerProviderStateMixin {
  LCObject daka;
  _DakaRecordsPageState(this.daka);
  var numerator;
  int denominator;
  AnimationController _animationController;
  CalendarController _calendarController;
  TabController _tabController;

  GlobalKey _key = new GlobalKey(); //////

  final ValueNotifier<int> _actionIcon = ValueNotifier<int>(0);
  int _iconIndex;
  List _record;

  @override
  void initState() {
    numerator = daka['records'].length;
    denominator = // DateTime.now().difference(daka.createdAt).inDays + 1;
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                .difference(DateTime(daka.createdAt.year, daka.createdAt.month,
                    daka.createdAt.day))
                .inDays +
            1;

    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      _actionIcon.value = _tabController.index;
    });
    _iconIndex = daka['iconIndex'];
    _record = daka['records'];
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  _alertDialog() async {
    var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("?????????????????????"),
            actions: [
              FlatButton(
                child: Text("??????"),
                onPressed: () {
                  print("??????");
                  Navigator.pop(context, 'Cancel');
                },
              ),
              FlatButton(
                child: Text("??????"),
                onPressed: () async {
                  print("??????");
                  await daka.delete();
                  Navigator.of(context).pushAndRemoveUntil(
                      new MaterialPageRoute(
                          builder: (context) => Tabs(index: 2)),
                      (route) => route == null);
                },
              ),
            ],
          );
        });
    print(result);
  }

  _simpleDialog() async {
    var result = await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("????????????"),
            children: [
              SimpleDialogOption(
                child: Text("Option A"),
                onPressed: () {
                  print("Option A");
                  Navigator.pop(context, "A");
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text("Option B"),
                onPressed: () {
                  print("Option B");
                  Navigator.pop(context, "B");
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text("Option C"),
                onPressed: () {
                  print("Option C");
                  Navigator.pop(context, "C");
                },
              ),
            ],
          );
        });
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            backgroundColor: backgroundColor,
            resizeToAvoidBottomInset: false,
            //????????????
            // floatingActionButton: FloatingActionButton(
            //   //??????????????????
            //   child: Icon(
            //     FontAwesomeIcons.cameraRetro,
            //     color: Colors.white,
            //   ),
            //   //?????????????????????
            //   backgroundColor: Colors.deepOrange[600],
            //   onPressed: _simpleDialog,
            // ),
            //?????????????????????
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.miniEndFloat,
            appBar: AppBar(
                centerTitle: true,
                backgroundColor: Color.fromRGBO(180, 120, 80, 1),
                title: Row(
                  children: [
                    Expanded(
                      child: TabBar(
                        // isScrollable: true, //????????????????????????????????????????????????????????????
                        indicatorColor: Colors.deepOrange[900], //???????????????
                        indicatorWeight: 2,
                        labelColor: Colors.white, //????????????label??????
                        unselectedLabelColor: Colors.brown[800],
                        indicatorSize:
                            TabBarIndicatorSize.tab, //??????????????????????????? tab????????????
                        controller: _tabController,
                        tabs: [
                          Tab(
                            text: "????????????",
                          ),
                          Tab(
                            text: "????????????",
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                actions: [
                  PopupMenuButton<String>(
                      onSelected: (String value) {
                        // setState(() {
                        //   _bodyStr = value;
                        // });
                        if (value == "????????????") {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new EditDakaPage(
                                      daka: daka,
                                    )),
                          );
                        } else {
                          _alertDialog();
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuItem<String>>[
                            new PopupMenuItem<String>(
                                value: '????????????', child: new Text('????????????')),
                            new PopupMenuItem<String>(
                                value: '????????????', child: new Text('????????????'))
                          ])
                ]),

            ///??????????????????
            body: TabBarView(controller: _tabController, children: [
              RepaintBoundary(
                  key: _key, //??????Key
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        height: 17,
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(width: 8, color: Colors.brown),
                                bottom: BorderSide(
                                    width: 2, color: Colors.brown[300]))),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 15),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 2, color: Colors.brown[300]
                                    // Color(0xffe5e5e5)
                                    ))),
                        child: _buildTableCalendar(), //???????????? ??????
                      ),
                    ],
                    // ),
                  )),
              Stack(alignment: Alignment.center, children: [
                Container(color: Colors.white, height: 300),
                Row(children: [
                  Expanded(
                      flex: 4,
                      //????????????????????????????????????????????????
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              //????????????????????????
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 10),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      shape: BoxShape.circle,
                                    ),
                                    width: 10,
                                    height: 10,
                                  ),
                                  Text(
                                    '?????????',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              )),
                          Container(
                              //????????????????????????
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 10),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange[50],
                                      shape: BoxShape.circle,
                                    ),
                                    width: 10,
                                    height: 10,
                                  ),
                                  Text(
                                    '?????????',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              )),
                        ],
                      )),
                  //????????????????????????
                  Expanded(
                    flex: 6,
                    //????????????
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(alignment: Alignment.center, children: [
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.deepOrange[50],
                                shape: BoxShape.circle,
                              ),
                            ),
                            CustomPaint(
                              size: Size(200, 200),
                              painter:
                                  CustomShapPainter(numerator, denominator),
                            ),
                          ]),
                          Text('???????????????$numerator???/$denominator???',
                              style: TextStyle(
                                  color: Colors.brown[800], fontSize: 20))
                        ]),
                  ),
                ])
              ])
            ])));
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      isDV: true,
      donedaysC: _record,
      iconC: icons[_iconIndex],
      startingDayOfWeek: StartingDayOfWeek.monday, //?????????
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false, //?????????
      ),
      headerStyle: HeaderStyle(
        //??????????????????
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }
}

class CustomShapPainter extends CustomPainter {
  //????????????
  // List list;
  int numerator;
  int denominator;

  CustomShapPainter(this.numerator, this.denominator);

  //????????????
  Paint _paint = new Paint()..isAntiAlias = true;

  //????????????Pi????????????????????????????????????????????????????????????????????
  //????????????
  @override
  void paint(Canvas canvas, Size size) {
    // double progress=numerator/denominator;
    //??????
    Offset center = Offset(size.width / 2, size.height / 2);
    //??????  ????????? ?????? ?????????
    double radius = min(size.width / 2, size.height / 2);

    //?????????????????????
    double startRadian = -pi / 2;

    //?????????

    // list.forEach((element) {
    //   total += element["number"];
    // });

    //????????????
    // for (var i = 0; i < list.length; i++) {
    //????????????????????????
    // var item = list[i];

    //?????????????????????
    double flag = numerator / denominator;

    //????????????
    double sweepRadin = flag * 2 * pi; // * progress;

    //???????????????
    //???????????????????????????
    _paint.color = Colors.deepOrange;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startRadian,
        sweepRadin, true, _paint);

    //?????????????????????????????????
    // startRadian += sweepRadin;
    // }
  }

  //??????true ??????
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
