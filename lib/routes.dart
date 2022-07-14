import 'package:flutter/material.dart';
import 'package:timemachine/pages/pageLogin.dart';
import 'tabs.dart';
import 'pages/actions/newEvent.dart';
import 'pages/actions/newDaka.dart';
import 'pages/actions/newTodo.dart';
import 'pages/actions/ratio.dart';
// import 'pages/pageSandClock.dart';

//配置路由 需要传参加arguments
final routes = {
  '/': (context) => LoginPage(),//Tabs(),
  '/tabs': (context) => Tabs(),

  // '/login': (context) => LoginPage(),//Tabs(),
  // '/form':(context,{arguments})=>FormPage(arguments: arguments),
  // '/myPaint':(context,{arguments})=>SearchPage(arguments: arguments),
  // '/login':(context)=>LoginPage(),
  //
  '/newEvent': (context) => NewEventPage(),
  '/newDaka': (context) => NewDakaPage(),
  '/newTodo': (context) => NewTodoPage(),
  '/ratio': (context) => RatioPage(),
  // '/pageSandClock': (context) =>SandClockPage(),
};
//固定写法
var onGenerateRoute = (RouteSettings settings) {
  //统一处理
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, time: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
