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
            content: Text("是否确定删除？"),
            actions: [
              FlatButton(
                child: Text("取消"),
                onPressed: () {
                  print("取消");
                  Navigator.pop(context, 'Cancel');
                },
              ),
              FlatButton(
                child: Text("确定"),
                onPressed: () async {
                  print("确定");
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
            title: Text("选择内容"),
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
            //浮动按钮
            // floatingActionButton: FloatingActionButton(
            //   //浮动按钮图标
            //   child: Icon(
            //     FontAwesomeIcons.cameraRetro,
            //     color: Colors.white,
            //   ),
            //   //浮动按钮背景色
            //   backgroundColor: Colors.deepOrange[600],
            //   onPressed: _simpleDialog,
            // ),
            //浮动按钮的位置
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.miniEndFloat,
            appBar: AppBar(
                centerTitle: true,
                backgroundColor: Color.fromRGBO(180, 120, 80, 1),
                title: Row(
                  children: [
                    Expanded(
                      child: TabBar(
                        // isScrollable: true, //如果是多个按钮的话可以滑动，不然会被盖住
                        indicatorColor: Colors.deepOrange[900], //指示器颜色
                        indicatorWeight: 2,
                        labelColor: Colors.white, //所选中的label颜色
                        unselectedLabelColor: Colors.brown[800],
                        indicatorSize:
                            TabBarIndicatorSize.tab, //指示器大小计算方式 tab是默认值
                        controller: _tabController,
                        tabs: [
                          Tab(
                            text: "历史记录",
                          ),
                          Tab(
                            text: "完成统计",
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
                        if (value == "修改习惯") {
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
                                value: '修改习惯', child: new Text('修改习惯')),
                            new PopupMenuItem<String>(
                                value: '删除习惯', child: new Text('删除习惯'))
                          ])
                ]),

            ///完成情况页面
            body: TabBarView(controller: _tabController, children: [
              RepaintBoundary(
                  key: _key, //设置Key
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
                        child: _buildTableCalendar(), //日历部分 圈圈
                      ),
                    ],
                    // ),
                  )),
              Stack(alignment: Alignment.center, children: [
                Container(color: Colors.white, height: 300),
                Row(children: [
                  Expanded(
                      flex: 4,
                      //左边是一个竖直方向排列的线性布局
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              //设置左右上下边距
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
                                    '已打卡',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              )),
                          Container(
                              //设置左右上下边距
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
                                    '未打卡',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              )),
                        ],
                      )),
                  //右边就是饼图区域
                  Expanded(
                    flex: 6,
                    //层叠布局
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
                          Text('打卡比例：$numerator天/$denominator天',
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
      startingDayOfWeek: StartingDayOfWeek.monday, //周起始
      calendarStyle: CalendarStyle(
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
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }
}

class CustomShapPainter extends CustomPainter {
  //数据内容
  // List list;
  int numerator;
  int denominator;

  CustomShapPainter(this.numerator, this.denominator);

  //来个画笔
  Paint _paint = new Paint()..isAntiAlias = true;

  //圆周率（Pi）是圆的周长与直径的比值，一般用希腊字母π表示
  //绘制内容
  @override
  void paint(Canvas canvas, Size size) {
    // double progress=numerator/denominator;
    //中心
    Offset center = Offset(size.width / 2, size.height / 2);
    //半径  取宽高 一半 最小值
    double radius = min(size.width / 2, size.height / 2);

    //开始绘制的弧度
    double startRadian = -pi / 2;

    //总金额

    // list.forEach((element) {
    //   total += element["number"];
    // });

    //开始绘制
    // for (var i = 0; i < list.length; i++) {
    //当前要绘制的选项
    // var item = list[i];

    //计算所占的比例
    double flag = numerator / denominator;

    //计算弧度
    double sweepRadin = flag * 2 * pi; // * progress;

    //开始绘制弧
    //设置一下画笔的颜色
    _paint.color = Colors.deepOrange;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startRadian,
        sweepRadin, true, _paint);

    //累加下次开始绘制的角度
    // startRadian += sweepRadin;
    // }
  }

  //返回true 刷新
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
