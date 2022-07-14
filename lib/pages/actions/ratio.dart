import 'package:flutter/material.dart';
import 'dart:math';
import 'package:timemachine/bean.dart';

class RatioPage extends StatefulWidget {
  final ratio;
  RatioPage({Key key, this.ratio}) : super(key: key);
  @override
  State<StatefulWidget> createState() => RatioState(ratio);
}

class RatioState extends State<RatioPage> {
  final ratio;
  RatioState(this.ratio);
  ValueNotifier<double> ratioNotifier;

  @override
  void initState() {
    ratioNotifier = ValueNotifier<double>(ratio);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        leading: TextButton(
          child: Icon(Icons.keyboard_backspace, color: Colors.black),
          onPressed: () {
            Navigator.pop(context, ratioNotifier.value);
          },
        ),
        title: Text('设置沙漏钟比例'),
        // actions: [
        //   TextButton(
        //       child: Icon(Icons.check, color: Colors.black),
        //       onPressed: () {
        //         // setState(() {});
        //         Navigator.pop(context,ratioNotifier.value);
        //       })
        // ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Image.asset('images/ratio.png',width: 240,height: 240,),
          CircleProgressBar(
            // radius: 120.0,
            // dotColor: Colors.pink,
            // dotRadius: 18.0,
            // shadowWidth: 2.0,
            progress: (ratioNotifier.value - 0.5) / 3,
            progressChanged: (value) {
              setState(() {
                ratioNotifier.value = ((10 * (3 * value + 0.5)).round() / 10);
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Text(
              'ratio:${ratioNotifier.value}',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              '休息时间=专注时间÷ratio',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ],
      ),
    );
  }
}

typedef ProgressChanged<double> = void Function(double value);

num degToRad(num deg) => deg * (pi / 180.0);

num radToDeg(num rad) => rad * (180.0 / pi);

class CircleProgressBar extends StatefulWidget {
  final double radius;
  final double progress;
  final double dotRadius;
  final double shadowWidth;
  final Color shadowColor;
  final Color dotColor;
  final Color dotEdgeColor;
  final Color ringColor;

  final ProgressChanged progressChanged;

  const CircleProgressBar({
    Key key,
    this.radius = 120.0,
    this.dotRadius = 18.0,
    this.dotColor = Colors.brown,
    this.shadowWidth = 2.0,
    this.shadowColor = Colors.black12,
    this.ringColor = const Color(0XFFF7F7FC),
    this.dotEdgeColor = const Color(0XFFF5F5FA),
    @required this.progress, //
    this.progressChanged,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CircleProgressState();
}

class _CircleProgressState extends State<CircleProgressBar>
    with SingleTickerProviderStateMixin {
  AnimationController progressController;
  AnimationController ratioController;
  bool isValidTouch = false;
  final GlobalKey paintKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    progressController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    if (widget.progress != null) progressController.value = widget.progress;
    progressController.addListener(() {
      if (widget.progressChanged != null)
        widget.progressChanged(progressController.value);
      setState(() {});
    });
  }

  @override
  void dispose() {
    progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = widget.radius * 2.0;
    final size = new Size(width, width);
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Container(
        alignment: FractionalOffset.center,
        child: CustomPaint(
          key: paintKey,
          size: size,
          painter: ProgressPainter(
              dotRadius: widget.dotRadius,
              shadowWidth: widget.shadowWidth,
              shadowColor: widget.shadowColor,
              ringColor: widget.ringColor,
              dotColor: widget.dotColor,
              dotEdgeColor: widget.dotEdgeColor,
              // radius: widget.radius,
              progress: progressController.value),
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    RenderBox getBox = paintKey.currentContext.findRenderObject();
    Offset local = getBox.globalToLocal(details.globalPosition);
    isValidTouch = _checkValidTouch(local);
    if (!isValidTouch) {
      return;
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!isValidTouch) {
      return;
    }
    RenderBox getBox = paintKey.currentContext.findRenderObject();
    Offset local = getBox.globalToLocal(details.globalPosition);
    final double x = local.dx;
    final double y = local.dy;
    final double center = widget.radius;
    double radians = atan((x - center) / (center - y));
    if (y > center) {
      radians = radians + degToRad(180.0);
    } else if (x < center) {
      radians = radians + degToRad(360.0);
    }
    progressController.value = radians / degToRad(360.0);
  }

  void _onPanEnd(DragEndDetails details) {
    if (!isValidTouch) {
      return;
    }
  }

  bool _checkValidTouch(Offset pointer) {
    final double validInnerRadius = widget.radius - widget.dotRadius * 3;
    final double dx = pointer.dx;
    final double dy = pointer.dy;
    final double distanceToCenter =
        sqrt(pow(dx - widget.radius, 2) + pow(dy - widget.radius, 2));
    if (
        // distanceToCenter < validInnerRadius ||
        distanceToCenter > widget.radius) {
      return false;
    }
    return true;
  }
}

class ProgressPainter extends CustomPainter {
  final double dotRadius;
  final double shadowWidth;
  final Color shadowColor;
  final Color dotColor;
  final Color dotEdgeColor;
  final Color ringColor;
  final double progress;

  ProgressPainter({
    this.dotRadius,
    this.shadowWidth = 2.0,
    this.shadowColor,
    this.ringColor,
    this.dotColor,
    this.dotEdgeColor,
    this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    print(progress);
    final double center = size.width * 0.5;
    final Offset offsetCenter = Offset(center, center);
    final double drawRadius = size.width * 0.5 - dotRadius;
    final angle = 360.0 * progress;
    final double radians = degToRad(angle);

    final double radiusOffset = dotRadius * 0.4;
    final double outerRadius = center - radiusOffset;
    final double innerRadius = center - dotRadius * 2 + radiusOffset;

    // draw shadow.
    // final shadowPaint = Paint()
    //   ..style = PaintingStyle.stroke
    //   ..color = shadowColor
    //   ..strokeWidth = shadowWidth
    //   ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowWidth);
  //    canvas.drawCircle(offsetCenter, outerRadius, shadowPaint);
  //    canvas.drawCircle(offsetCenter, innerRadius, shadowPaint);

    Path path = Path.combine(
        PathOperation.difference,
        Path()
          ..addOval(Rect.fromCircle(center: offsetCenter, radius: outerRadius)),
        Path()
          ..addOval(
              Rect.fromCircle(center: offsetCenter, radius: innerRadius)));
    canvas.drawShadow(path, shadowColor, 4.0, true);

    final double dx = center + drawRadius * sin(radians);
    final double dy = center - drawRadius * cos(radians);
    final Color currentDotColor = Color.alphaBlend(
        dotColor.withOpacity(0.7 + (0.3 * progress)), Colors.white);
    final linePaint = Paint()
      ..color = Colors.brown
      ..strokeWidth = 5;
    //drwa line
    canvas.drawLine(
        Offset(center + 0.7 * drawRadius * sin(0),
            center - 0.7 * drawRadius * cos(0)),
        Offset(center + drawRadius * sin(0), center - drawRadius * cos(0)),
        linePaint); //0.5
      //0.5 1 1.5 2 2.5 3
    canvas.drawLine(
        Offset(center + 0.7 * drawRadius * sin(pi / 3),
            center - 0.7 * drawRadius * cos(pi / 3)),
        Offset(center + drawRadius * sin(pi / 3),
            center - drawRadius * cos(pi / 3)),
        linePaint); //1
    canvas.drawLine(
        Offset(center + 0.7 * drawRadius * sin(2 * pi / 3),
            center - 0.7 * drawRadius * cos(2 * pi / 3)),
        Offset(center + drawRadius * sin(2 * pi / 3),
            center - drawRadius * cos(2 * pi / 3)),
        linePaint); //1.5
    canvas.drawLine(
        Offset(center + 0.7 * drawRadius * sin(pi),
            center - 0.7 * drawRadius * cos(pi)),
        Offset(center + drawRadius * sin(pi), center - drawRadius * cos(pi)),
        linePaint); //2
    canvas.drawLine(
        Offset(center + 0.7 * drawRadius * sin(4 * pi / 3),
            center - 0.7 * drawRadius * cos(4 * pi / 3)),
        Offset(center + drawRadius * sin(4 * pi / 3),
            center - drawRadius * cos(4 * pi / 3)),
        linePaint); //2.5
    canvas.drawLine(
        Offset(center + 0.7 * drawRadius * sin(5 * pi / 3),
            center - 0.7 * drawRadius * cos(5 * pi / 3)),
        Offset(center + drawRadius * sin(5 * pi / 3),
            center - drawRadius * cos(5 * pi / 3)),
        linePaint); //3

    canvas.drawLine(Offset(center, center),
        Offset(center, center - 0.6 * drawRadius * cos(0)), linePaint);
    canvas.drawLine(Offset(center, center), Offset(dx, dy), linePaint);
    // draw ring.
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.brown
      // ringColor
      ..strokeWidth =
          // radius;
          (outerRadius - innerRadius);
    // ..style = PaintingStyle.fill;

    canvas.drawCircle(offsetCenter, drawRadius, ringPaint);

    // draw progress.
    if (progress > 0.0) {
      final progressWidth = outerRadius - innerRadius + radiusOffset;
      final double offset = asin(progressWidth * 0.5 / drawRadius);
      if (radians > offset) {
        canvas.save();
        canvas.translate(0.0, size.width);
        canvas.rotate(degToRad(-90.0));
        final Gradient gradient = new SweepGradient(
          endAngle: radians,
          colors: [
            Colors.brown[200],
            currentDotColor,
          ],
        );
        // final Rect arcRect =
        //     Rect.fromCircle(center: offsetCenter, radius: drawRadius);
        final Rect arcRect =
            Rect.fromCircle(center: offsetCenter, radius: drawRadius);
        final progressPaint = Paint()
          ..style = PaintingStyle.stroke
          // .stroke

          ..strokeCap = StrokeCap.round
          ..strokeWidth = progressWidth
          ..shader = gradient.createShader(arcRect);
        canvas.drawArc(arcRect, offset, radians - offset, false, progressPaint);
        // canvas.drawLine(p1, , paint)
        canvas.restore();
      }
    }

    // draw dot.

    final dotPaint = Paint()..color = currentDotColor;

    canvas.drawCircle(new Offset(dx, dy), dotRadius, dotPaint);
    dotPaint
      ..color = dotEdgeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = dotRadius * 0.3;
    canvas.drawCircle(new Offset(dx, dy), dotRadius, dotPaint);

  //    canvas.drawLine(
  //        Offset(center, 0.0),
  //        Offset(center, size.height),
  //        Paint()
  //          ..strokeWidth = 1.0
  //          ..color = Colors.black);  // 测试基准线
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
