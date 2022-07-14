import 'package:flutter/material.dart';

class MyPaint extends StatefulWidget {
  // final arguments;

  // MyPaint({@required this.arguments});
  
  @override
  _MyPaintState createState() =>_MyPaintState();
  
  // @override
  // _MyPaintState createState() {print("arg"+arguments.toString());_MyPaintState(duration: this.arguments);
  // }
}

class _MyPaintState extends State<MyPaint> with SingleTickerProviderStateMixin {
  //动画控制器需要传入 async, 要达到这一目的_MyHomePageState必须混合 SingleTickerProviderStateMixin
  Animation<double> animation; //创建了一个泛double型的Animation类对象
  AnimationController controller; //创建了一个动画控制器 AnimationController类型
  AnimationStatus animationState; //创建了一个动画状态 AnimationStatus类型
  double animationValue; //一个double类型的数值, 用来展示动画的状态进度值
  // var duration;
  bool isRunning = true;
  _MyPaintState();
  // _MyPaintState({this.arguments=2});
  // _MyPaintState({@required this.duration});
  @override
  void initState() {
    // print("dur"+duration.toString());
    super.initState();
    controller = //初始化进程中为控制器做初始化.
        AnimationController(duration:  const Duration(seconds: 5), vsync: this);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                CustomPaint(
                    size: Size(MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height),
                    painter: MyPainter(animationValue)),
                Image.asset('images/sandclock.png',
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: double.infinity),
                RaisedButton(
                    child: isRunning
                        ? Text("暂停", style: TextStyle(color: Colors.black))
                        : Text("继续", style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      isRunning ? controller.stop() : controller.forward();
                      setState(() {
                        isRunning = !isRunning;
                      });
                    }),
              ],
            )));
  }

// CustomPaint(
  //         size:Size(300,500),
  //           painter: MyPainter())),

  //             Image.asset('images/sandclock.png',
  //                 fit: BoxFit.fill,
  //                 // width: double.infinity,
  //                 // height: double.infinity
  //                 )

//

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
      ..color = Colors.white
      ..strokeWidth = 0.08 * size.width;
    Paint _paint3 = Paint()
      ..color = Colors.white
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

// ///粉色超好看圆弧！
// class CircleProgressBar extends CustomPainter {
//   var duration;
//   CircleProgressBar({@required duration});
//   @override
//   void paint(Canvas canvas, Size size) {
//     final double drawRadius = 200;
//     final double progressWidth = 20;

//     final Offset offsetCenter = Offset(size.width / 2, size.height / 2);

//     final ringColor = Colors.pink[200];
//     final ringPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..color = ringColor
//       ..strokeWidth = 20; //宽度(outerRadius - innerRadius);
//     canvas.drawCircle(offsetCenter, drawRadius, ringPaint);

//     final Color currentDotColor = Colors.pink[300];
//     final progress = 0.4;
//     final angle = 360.0 * progress;
//     final double radians = angle * pi / 180;
//     final Rect arcRect =
//         Rect.fromCircle(center: offsetCenter, radius: drawRadius);
//     final Gradient gradient = new SweepGradient(
//       endAngle: radians,
//       colors: [
//         Colors.white,
//         currentDotColor,
//       ],
//     );
//     final progressPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round
//       ..strokeWidth = progressWidth
//       ..shader = gradient.createShader(arcRect);
//     canvas.drawArc(arcRect, 0.0, radians, false, progressPaint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return this != oldDelegate;
//     // return false;
//   }
// }

// // void main() {
// //   runApp(new MyPaint());
// // }
