import 'dart:ui';
import 'package:flutter/cupertino.dart';
// import 'package:timemachine/theme.dart' as theme;

class Theme {
  // 背景颜色
  static const Color backgroundColor = const Color(0xFFfbab66);
  // 登录界面，定义渐变的颜色
  static const Color loginGradientStart = const Color(0xFFfbab66);
  static const Color loginGradientEnd = const Color(0xFFf7418c);

  static const LinearGradient primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}