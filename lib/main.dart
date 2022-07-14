import 'package:flutter/material.dart';
import 'routes.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:leancloud_storage/leancloud.dart';
//nox_adb.exe connect 127.0.0.1:62001

Future<void> main() async {
  //
  initializeDateFormatting().then((_) => runApp(MyApp()));
  LeanCloud.initialize(
      '8wjY9JRetnsC6QA1037OnWKp-gzGzoHsz', 'eO5OC6MAwOhn13rsryrrbERO',
      server: 'https://8wjy9jre.lc-cn-n1-shared.com',
      queryCache: new LCQueryCache());
  // LCLogger.setLevel(LCLogger.DebugLevel);
  // LCObject object = LCObject('TestObject');
  // object['words'] = 'Hello world!';
  // await object.save();

  // LCUser currentUser = await LCUser.getCurrent();
  // if (currentUser != null) {
  //   // 跳到首页
  //   runApp(new MyAppTabs());
  // } else {
  //   // 显示注册或登录页面
  //   runApp(new MyApp());
  // }

  runApp(new MyApp());
}

//自定义组件
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //去掉debug图标
      // home: Tabs(),
      initialRoute: '/', //初始化的时候加载到路由
      onGenerateRoute: onGenerateRoute, //不需要加括号
      theme: ThemeData(
        primaryColor: Color.fromRGBO(215, 185, 150, 1),
      ),
      // routes: {
      //   '/form':(context)=>FormPage(),
      //   '/search':(context)=>SearchPage(),
      // },
    );
  }}
//自定义组件
class MyAppTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //去掉debug图标
      // home: Tabs(),
      initialRoute: '/tabs', //初始化的时候加载到路由
      onGenerateRoute: onGenerateRoute, //不需要加括号
      theme: ThemeData(
        primaryColor: Color.fromRGBO(215, 185, 150, 1),
      ),
      // routes: {
      //   '/form':(context)=>FormPage(),
      //   '/search':(context)=>SearchPage(),
      // },
    );
  }
//memo:
  //默认标题appBar title fontSize 14
  //todo点击新增按钮增加输入组件
  //分割线算了吧
  //class初始化里this.很重要
//controller:
  //ScrollController
  //TabController
  //AnimationController
  //TextFieldTextEditingController
  //UIViewController
  //StreamController
  //HttpController
  //PageController
  //ViewController
//路由
  //Navigator.pushNamed(context, '/pageSandClock');
  //Navigator.push(context,new MaterialPageRoute(builder: (context) => new NewTodoPage()),);
  //2.返回根：默认返回根目录，可以用参数index调整
  // Navigator.of(context).pushAndRemoveUntil(
  //   new MaterialPageRoute(builder: (context)=> new Tabs(index:2)),
  //     (route) => route== null
  // );


//添花：⚪排序 ⚪左右切换 ⚪保存页面？ ⚪分时间段 ⚪日程提醒 ⚪登录记忆 ⚪计时器样式 ⚪截屏
//失败：⚪发送验证码 ⚪沙漏响铃 ⚪新建日程时间选择
}
