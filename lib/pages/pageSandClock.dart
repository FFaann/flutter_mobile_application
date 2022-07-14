import 'package:flutter/material.dart';
import 'package:timemachine/bean.dart';
import 'package:timemachine/timer.dart';


class SandClockPage extends StatefulWidget {
  final savedTime;
  SandClockPage({this.savedTime});
  @override
  _SandClockPageState createState() =>
      _SandClockPageState(savedTime: savedTime);
}

// class _MyState extends State<My> {
class _SandClockPageState extends State<SandClockPage>
    with SingleTickerProviderStateMixin {
  final savedTime;
  final StopWatchTimer _stopWatchTimer;
  _SandClockPageState({@required this.savedTime})
      : _stopWatchTimer = StopWatchTimer(
          mode: StopWatchMode.countDown,
          presetMillisecond:
              StopWatchTimer.getMilliSecFromSecond(savedTime), //值
          onChange: (value) => print('onChange $value'),
          onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
          onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
        );

  //动画控制器需要传入 async, 要达到这一目的_MyHomePageState必须混合 SingleTickerProviderStateMixin
  Animation<double> animation; //创建了一个泛double型的Animation类对象
  AnimationController controller; //创建了一个动画控制器 AnimationController类型
  AnimationStatus animationState; //创建了一个动画状态 AnimationStatus类型
  double animationValue; //一个double类型的数值, 用来展示动画的状态进度值
  bool isRunning = true;
  final _isHours = true;

  // final _scrollController = ScrollController();

  @override
  void initState() {
    _stopWatchTimer.rawTime.listen((value) =>
        print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    _stopWatchTimer.records.listen((value) => print('records $value'));

    controller = //初始化进程中为控制器做初始化.
        AnimationController(
            duration: Duration(seconds: savedTime), vsync: this);
    animation = Tween<double>(begin: 0, end: 0.3)
        .animate(controller) //用一个Tween生成了一个Animation动画,同时给他了一个controller
          ..addListener(() {
            //创建完动画后, 为其添加一个监听,
            setState(() {
              animationValue = animation.value;
              //在这个监听里, 将这个动画的value赋值给之前创建的double数据animationValue
            });
          })
          ..addStatusListener((AnimationStatus state) {
            //然后又为动画添加了一个状态监听
            setState(() {
              animationState = state; //把动画的状态赋值给我们之前创建的动画状态对象animationState
            });
          });
    controller.forward();
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    super.initState();
  }

  // play() async {
  //   int result = await audioPlayer.play('ring.mp3',isLocal:true);
  //   if (result == 1) {
  //     // success
  //     print('play success');
  //   } else {
  //     print('play failed');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Color.fromRGBO(255, 255, 240, 1),
        // appBar: AppBar(title: Text("休息ing"),),
        // centerTitle: true,
        body: Container(
            color: backgroundColor,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: LayoutBuilder(builder: (context, constrains) {
              var width = constrains.maxWidth;
              var height = constrains.maxHeight;
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  CustomPaint(
                      size: Size(width, height),
                      painter: MyPainter(animationValue)),
                  Image.asset('assets/images/sandclock.png',
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: double.infinity),
                  Container(
                      // height: Size(MediaQuery.of(context).size.width,
                      child: RaisedButton(
                          color: Colors.brown[300],
                          child: controller.isCompleted
                              ? Text(" 返 回 ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25))
                              : Text(" 停 止 ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25)),
                          onPressed: () {
                            controller.stop();
                            _stopWatchTimer.onExecute
                                .add(StopWatchExecute.stop);
                            Navigator.pop(context, _stopWatchTimer.second);
                          })),
                  Positioned(
                    top: 0.2 * height,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: StreamBuilder<int>(
                        stream: _stopWatchTimer.rawTime,
                        initialData:
                            _stopWatchTimer.rawTime.valueWrapper?.value,
                        builder: (context, snap) {
                          final value = snap.data;
                          final displayTime =
                              StopWatchTimer.getDisplayTime(value,
                                  // milliSecond: false,
                                  hours: _isHours);
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              displayTime,
                              style: const TextStyle(
                                  fontSize: 50,
                                  fontFamily: 'Helvetica',
                                  color: Colors.brown,
                                  fontWeight: FontWeight.bold),
                            ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8),
                            //   child: Text(
                            //     value.toString(),
                            //     style: const TextStyle(
                            //         fontSize: 16,
                            //         fontFamily: 'Helvetica',
                            //         fontWeight: FontWeight.w400),
                            //   ),
                            // ),
                            // ],
                          );
                        },
                      ),
                    ),
                  )
                ],
              );
            })));
  }

  @override
  void dispose() {
    //当控件解散时把控制器销毁掉
    controller.dispose();
    super.dispose();
  }
}

class MyPainter extends CustomPainter {
  final time;
  MyPainter(this.time);
// @required
  @override
  void paint(Canvas canvas, Size size) {
    print(time);
    Paint _paint1 = Paint()
      ..color = Color.fromRGBO(169, 142, 117, 1)
      ..strokeWidth = 0.8 * size.width;
    Paint _paint2 = Paint()
      ..color = backgroundColor
      ..strokeWidth = 0.08 * size.width;
    Paint _paint3 = Paint()
      ..color = backgroundColor
      ..strokeWidth = 0.4 * size.width;

    canvas.drawLine(Offset(0.5 * size.width, (0.105 + time) * size.height),
        Offset(0.5 * size.width, 0.405 * size.height), _paint1);
    canvas.drawLine(Offset(0.12 * size.width, 0.26 * size.height),
        Offset(0.12 * size.width, 0.5 * size.height), _paint2);
    canvas.drawLine(Offset(0.19 * size.width, 0.34 * size.height),
        Offset(0.19 * size.width, 0.5 * size.height), _paint2);
    canvas.drawLine(Offset(0.26 * size.width, 0.38 * size.height),
        Offset(0.26 * size.width, 0.5 * size.height), _paint2);
    canvas.drawLine(Offset(0.33 * size.width, 0.42 * size.height),
        Offset(0.33 * size.width, 0.5 * size.height), _paint2);

    canvas.drawLine(Offset(0.88 * size.width, 0.26 * size.height),
        Offset(0.88 * size.width, 0.5 * size.height), _paint2);
    canvas.drawLine(Offset(0.81 * size.width, 0.34 * size.height),
        Offset(0.81 * size.width, 0.5 * size.height), _paint2);
    canvas.drawLine(Offset(0.74 * size.width, 0.38 * size.height),
        Offset(0.74 * size.width, 0.5 * size.height), _paint2);
    canvas.drawLine(Offset(0.67 * size.width, 0.42 * size.height),
        Offset(0.67 * size.width, 0.5 * size.height), _paint2);

    canvas.drawLine(Offset(0.5 * size.width, 0.46 * size.height),
        Offset(0.5 * size.width, 0.5 * size.height), _paint3);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
    // return false;
  }
}
