import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:timemachine/pages/actions/ratio.dart';
import 'package:timemachine/pages/pageLogin.dart';
import 'pages/tabs/pageCalendar.dart';
import 'pages/tabs/pageDaka.dart';
import 'pages/tabs/pageTodo.dart';
import 'pages/tabs/pageTimer.dart';
import 'bean.dart';

class Tabs extends StatefulWidget {
  final index;
  Tabs({Key key, this.index = 0}) : super(key: key);
  @override
  _TabsState createState() => _TabsState(
        this.index,
      );
}

class _TabsState extends State<Tabs> {
  int _currentIndex; ///////////?????????????
  // bool _count = true;
  _TabsState(index) {
    this._currentIndex = index;
  }

  List _pageList = [
    //实际开发最好用list把tab和page放一起
    CalendarPage(),
    TodoPage(),
    DakaPage(),
    TimerPage(),
  ];
  List _titleList = [
    "日程",
    "Todo",
    "今日打卡",
    "Timer",
  ];
  List _actionList = [
    "/newEvent",
    "/newTodo",
    "/newDaka",
    "/ratio",
  ];

  _developerDialog() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('开发者：河北工业大学范晨旭175170'),
          );
        });
  }

   _contactDialog() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('联系方式：913247938@qq.com'),
          );
        });
  }

  Future<LCUser> retrieveData() async {
    LCUser _user = await LCUser.getCurrent();
    return (_user);
  }

  @override
  void initState() {
    // actionIcon.value = 0;
    super.initState();
  }

  _logoutDialog() async {
    var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // title: Text(""),
            content: Text("退出登录"),
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
                  await LCUser.logout();
                  // Navigator.pop(context);
                  Navigator.of(context).pushAndRemoveUntil(
                      new MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => route == null);
                },
              ),
            ],
          );
        });
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LCUser>(
      future: retrieveData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            LCUser _user = snapshot.data;
            return Scaffold(
              backgroundColor: backgroundColor,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: Color.fromRGBO(180, 120, 80, 1),
                // Color.fromRGBO(215, 185, 150, 1),
                centerTitle: true,
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: new Icon(Icons.person_pin),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                title: Text(this._titleList[this._currentIndex]),
                // automaticallyImplyLeading: false,

                actions: [
                  // FlatButton(
                  //     color: Colors.blue,
                  //     shape: CircleBorder(),
                  //     child: _currentIndex == 3
                  //         ? Icon(Icons.restore_sharp)
                  //         : (_currentIndex != 2
                  //             ? Icon(Icons.add)
                  //             : _count
                  //                 ? Icon(Icons.add)
                  //                 : Icon(Icons.check)),
                  //     onPressed: () {
                  //       setState(() {
                  //         if (this._currentIndex == 1) {
                  //           Future future = Navigator.pushNamed(
                  //               context, this._actionList[this._currentIndex]);
                  //           future.then((value) {
                  //             // habits.add(value);
                  //             // print("habit:" +
                  //             //     value.name.toString() +
                  //             //     value.icondata.toString());
                  //           });
                  //         }
                  //         if (this._currentIndex == 2) {
                  //         //   if (hidden == false &&
                  //         //     textKey.currentState.printValue() != '') {
                  //         //   setState(() {
                  //         //     print("??????????????");
                  //         //     todos.insert(
                  //         //         0,
                  //         //         Todo(
                  //         //             name: textKey.currentState.printValue(),
                  //         //             completion: false));
                  //         //             textKey = GlobalKey();
                  //         //   });
                  //         // }
                  //         // hidden = !hidden;
                  //         // textKey.currentState.onPressed(hidden);
                  //         // print(hidden);
                  //         // }
                  //       }});
                  //     }),
                  FlatButton(
                      color: Color.fromRGBO(180, 120, 80, 1),
                      shape: CircleBorder(),
                      child:
                          Icon(_currentIndex != 3 ? Icons.add : Icons.restore),
                      onPressed: () {
                        setState(() {
                          if (_currentIndex == 3) {
                            Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => new RatioPage(
                                            ratio: _user['ratio'].toDouble())))
                                .then((value) {
                              setState(() {
                                _user['ratio'] = value;
                                _user.save();
                              });
                            });
                          } else {
                            // Future future =
                            Navigator.pushNamed(
                                context, this._actionList[this._currentIndex]);
                            print(this._actionList[this._currentIndex]);
                          }
                        });
                      })
                ],
              ),
              // floatingActionButton:TextButton(child: Text("保存"),onPressed: (){},),
              body: this._pageList[this._currentIndex],
              //BottomNavigationBar是Scaffold的参数
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Color.fromRGBO(215, 185, 150, 1),
                // Color.fromRGBO(255, 255, 240, 1),
                selectedItemColor: Colors.deepOrange[700],
                //  Colors.brown[400],
                // Color.fromRGBO(235, 235, 220, 1),
                // Colors.white,

                currentIndex: this._currentIndex, //默认选中第几个 e.g.1->第二个
                onTap: (int index) {
                  //选中变化回调函数
                  setState(() {
                    this._currentIndex = index;
                  });
                },
                // iconSize: 36, //设置图标大小
                // fixedColor: Colors.green, //设置选中的颜色
                //放四个以上的item要设置type
                type: BottomNavigationBarType.fixed, //配置底部tabs可以有多个按钮
                items: [
                  //底部导航按钮合集
                  BottomNavigationBarItem(
                    icon: this._currentIndex == 0
                        ? Icon(Icons.event)
                        : Icon(Icons.date_range), //today
                    label: "日历",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.listAlt),
                    // this._currentIndex==1?Icon(FontAwesomeIcons.circleNotch):
                    //stars,data_usage,drag_indicator
                    label: "待办事项",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.data_usage),
                    // this._currentIndex==2?Icon(FontAwesomeIcons.listAlt):Icon(Icons.list_alt),
                    // Icon(Icons.storage), //storage  view_list>dns<format_list_bulleted
                    // Icon(Icons.list_alt),
                    label: "打卡",
                  ),
                  BottomNavigationBarItem(
                    icon: this._currentIndex == 3
                        ? Icon(FontAwesomeIcons.hourglassEnd)
                        : Icon(FontAwesomeIcons.hourglassStart),
                    // this._currentIndex==3?Icon(FontAwesomeIcons.stopwatch):Icon(FontAwesomeIcons.hourglassHalf), //timer
                    label: "沙漏钟",
                  ),
                  //action里好多合适的 硬件里filter_yilt_s brightness
                ],
              ),
              drawer: Drawer(
                child:Column(
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text(_user.username ?? "",style: TextStyle(fontSize: 20,color: Colors.brown[800])),
                      accountEmail: Text(_user.email ?? ""), //
                      // currentAccountPicture: CircleAvatar(
                      //   backgroundImage: NetworkImage(
                      //       "https://img2.doubanio.com/view/photo/l/public/p480747492.webp"),
                      // ),
                      onDetailsPressed: () {
                        _logoutDialog();
                      }
                    ),
                    ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color.fromRGBO(215, 185, 150, 1),
                          child: Icon(
                            FontAwesomeIcons.idCard,
                            color: Colors.brown,
                          ),
                        ),
                        title: Text("开发者信息",
                            style: TextStyle(
                                color: Colors.brown[800], fontSize: 16)),
                        onTap: () {
                          _developerDialog();
                        }),
                    Divider(),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color.fromRGBO(215, 185, 150, 1),
                        child: Icon(
                          FontAwesomeIcons.envelope,
                          color: Colors.brown,
                        ),
                      ),
                      title: Text("与开发者联系",
                          style:
                              TextStyle(color: Colors.brown[800], fontSize: 16)),
                      onTap: () {
                          _contactDialog();
                        }),
                    
                    // Divider(),
                    // ListTile(
                    //   leading: CircleAvatar(
                    //     child: Icon(Icons.settings),
                    //   ),
                    //   title: Text("设置中心"),
                    // ),
                    // Divider(),
                  ],
                ),
              ),
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
}
