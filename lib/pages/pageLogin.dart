import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:timemachine/pages/pageRegister.dart';
import 'package:timemachine/tabs.dart';
import '../bean.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //焦点
  FocusNode _focusNodeUserName = new FocusNode();
  FocusNode _focusNodePassWord = new FocusNode();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _userNameController = new TextEditingController();

  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _password = ''; //用户名
  var _username = ''; //密码
  var _isShowPwd = false; //是否显示密码
  var _isShowClear = false; //是否显示输入框尾部的清除按钮

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // 移除焦点监听
    _focusNodeUserName.removeListener(_focusNodeListener);
    _focusNodePassWord.removeListener(_focusNodeListener);
    _userNameController.dispose();
    super.dispose();
  }

  // 监听焦点
  Future<Null> _focusNodeListener() async {
    if (_focusNodeUserName.hasFocus) {
      print("用户名框获取焦点");
      // 取消密码框的焦点状态
      _focusNodePassWord.unfocus();
    }
    if (_focusNodePassWord.hasFocus) {
      print("密码框获取焦点");
      // 取消用户名框焦点状态
      _focusNodeUserName.unfocus();
    }
  }


  String validateUserName(value) {
    // 正则匹配手机号
    // RegExp exp = RegExp(
    //     // r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$'
    //     '^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$');
    if (value.isEmpty) {
      return '用户名不能为空!';
      // } else if (!exp.hasMatch(value)) {
      //   return '请输入正确邮箱';
    }
    return null;
  }

  String validatePassWord(value) {
    if (value.isEmpty) {
      return '密码不能为空';
    } else if (value.trim().length < 6 || value.trim().length > 18) {
      return '密码长度不正确';
    }
    return null;
  }

  _alertDialog(String message) async {
    var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(message),
            
          );
        });
    print(result);
  }

  _toast(){ //无法改变外观
    Fluttertoast.showToast(msg: 'msg'
        // msg: "提示信息",
        // toastLength: Toast.LENGTH_SHORT,
        // gravity: ToastGravity.CENTER,
        // timeInSecForIosWeb: 1,
        // backgroundColor: Colors.black,
        // textColor: Colors.white,
        // fontSize: 16.0
    );

  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    print(ScreenUtil().scaleHeight);

    // // logo 图片区域
    // Widget logoImageArea = new Container(
    //   alignment: Alignment.topCenter,
    //   // 设置图片为圆形
    //   child: ClipOval(
    //     child: Image.asset(
    //       "images/logo.png",
    //       height: 100,
    //       width: 100,
    //       fit: BoxFit.cover,
    //     ),
    //   ),
    // );
    Widget titleArea = new Padding(
      padding: EdgeInsets.only(left: 28.0, top: 28),
      child: Text(
        'Login',
        style: TextStyle(fontSize: 42.0, color: Colors.brown[800]),
      ),
    );
    Widget titleLineArea = new Padding(
        padding: EdgeInsets.only(left: 31.0, top: 12.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            color: Colors.brown[800],
            width: 40.0,
            height: 2.0,
          ),
        ));

    //输入文本框区域
    Widget inputTextArea = new Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        // color: Colors.white
      ),
      child: new Form(
        key: _formKey,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new TextFormField(
              controller: _userNameController,
              focusNode: _focusNodeUserName,
              //设置键盘类型
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: "用户名",
                hintText: "请输入用户名",
                prefixIcon: Icon(Icons.person),
                //尾部添加清除按钮
                suffixIcon: (_isShowClear)
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          // 清空输入框内容
                          _userNameController.clear();
                        },
                      )
                    : null,
              ),
              //验证用户名
              validator: validateUserName,
              //保存数据
              onSaved: (String value) {
                _username = value;
              },
            ),
            new SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
            new TextFormField(
              focusNode: _focusNodePassWord,
              decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "请输入密码",
                  prefixIcon: Icon(Icons.lock),
                  // 是否显示密码
                  suffixIcon: IconButton(
                    icon: Icon(
                        (_isShowPwd) ? Icons.visibility : Icons.visibility_off),
                    // 点击改变显示或隐藏密码
                    onPressed: () {
                      setState(() {
                        _isShowPwd = !_isShowPwd;
                      });
                    },
                  )),
              obscureText: !_isShowPwd,
              //密码验证
              validator: validatePassWord,
              //保存数据
              onSaved: (String value) {
                _password = value;
              },
            )
          ],
        ),
      ),
    );

    // 登录按钮区域
    Widget loginButtonArea = new Container(
      margin: EdgeInsets.only(left: 70, right: 70),
      height: 45.0,
      child: new RaisedButton(
        color: Colors.brown[600],
        child: Text("登录",
            style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                letterSpacing: 5,
                fontWeight: FontWeight
                    .w400) // Theme.of(context).primaryTextTheme.headline,
            ),
        // 设置按钮圆角
        shape: StadiumBorder(side: BorderSide()),
        onPressed: () async {
          //点击登录按钮，解除焦点，回收键盘
          _focusNodePassWord.unfocus();
          _focusNodeUserName.unfocus();

          if (_formKey.currentState.validate()) {
            //只有输入通过验证，才会执行这里
            _formKey.currentState.save();
            //todo 登录操作
            print("$_username + $_password");
            try {
              // 登录成功
              LCUser user = await LCUser.login(_username, _password);      
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new Tabs()),
              );
              _alertDialog('登录成功');
            } on LCException catch (e) {
              // 登录失败（可能是密码错误）
              print('${e.code} : ${e.message}');
              _alertDialog(e.message);
              // _toast();
            }
          }
        },
      ),
    );

    //第三方登录区域
    Widget thirdLoginArea = new Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 80,
                height: 1.0,
                color: Colors.grey,
              ),
              Text('第三方登录'),
              Container(
                width: 80,
                height: 1.0,
                color: Colors.grey,
              ),
            ],
          ),
          new SizedBox(
            height: 18,
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                color: Colors.green[200],
                // 第三方库icon图标
                icon: Icon(FontAwesomeIcons.weixin),
                iconSize: 40.0,
                onPressed: () {},
              ),
              IconButton(
                color: Colors.green[200],
                icon: Icon(FontAwesomeIcons.facebook),
                iconSize: 40.0,
                onPressed: () {},
              ),
              IconButton(
                color: Colors.green[200],
                icon: Icon(FontAwesomeIcons.qq),
                iconSize: 40.0,
                onPressed: () {},
              )
            ],
          )
        ],
      ),
    );

    // //忘记密码  立即注册
    // Widget bottomArea = new Container(
    //   margin: EdgeInsets.only(right: 20, left: 30),
    //   child: new Row(
    //     mainAxisSize: MainAxisSize.max,
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: <Widget>[
    //       // FlatButton(
    //       //   child: Text(
    //       //     "忘记密码?",
    //       //     style: TextStyle(
    //       //       color: Colors.blue[400],
    //       //       fontSize: 16.0,
    //       //     ),
    //       //   ),
    //       //   //忘记密码按钮，点击执行事件
    //       //   onPressed: () {},
    //       // ),
    //       FlatButton(
    //         child: Text(
    //           "快速注册",
    //           style: TextStyle(
    //             color: Colors.blue[400],
    //             fontSize: 16.0,
    //           ),
    //         ),
    //         //点击快速注册、执行事件
    //         onPressed: () {
    //           Navigator.push(context,
    //               new MaterialPageRoute(builder: (context) => RegisterPage()));
    //         },
    //       )
    //     ],
    //   ),
    // );

    Widget buildRegisterText = new Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('没有账号？', style: TextStyle(fontSize: 20)),
            GestureDetector(
              child: Text(
                '点击注册',
                style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 20),
              ),
              onTap: () {
                //TODO 跳转到注册页面
                print('去注册');
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new RegisterPage()),
                );
              },
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('登录'),
      ),
      // 外层添加一个手势，用于点击空白部分，回收键盘
      body: new GestureDetector(
        onTap: () {
          // 点击空白区域，回收键盘
          print("点击了空白区域");
          _focusNodePassWord.unfocus();
          _focusNodeUserName.unfocus();
        },
        child: ListView(
          children: <Widget>[
            new SizedBox(
              height: ScreenUtil().setHeight(80),
            ),
            titleArea,
            titleLineArea,
            new SizedBox(
              height: ScreenUtil().setHeight(70),
            ),
            inputTextArea,
            new SizedBox(
              height: ScreenUtil().setHeight(200),
            ),
            loginButtonArea,
            new SizedBox(
              height: ScreenUtil().setHeight(60),
            ),
            // thirdLoginArea,
            new SizedBox(
              height: ScreenUtil().setHeight(180),
            ),
            // bottomArea,
            buildRegisterText,
//                      new SignInPage(),
//                      new SignUpPage(),
            // new Expanded(child: _pageView),
          ],
        ),
      ),
    );
  }
}
