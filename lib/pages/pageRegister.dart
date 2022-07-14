import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:hb_password_input_textfield/hb_password_input_textfield.dart';
import '../bean.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //焦点
  FocusNode _focusNodeUserName = new FocusNode();
  FocusNode _focusNodePassWord = new FocusNode();
  FocusNode _focusNodeVertification = new FocusNode();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _vertificationController = new TextEditingController();

  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _password = ''; //用户名
  var _username = ''; //密码
  var _isShowPwd = false; //是否显示密码
  var _isShowClear = false; //是否显示输入框尾部的清除按钮

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // 移除焦点监听
    _focusNodeUserName.removeListener(_focusNodeListener);
    _focusNodePassWord.removeListener(_focusNodeListener);
    _focusNodeVertification.removeListener(_focusNodeListener);
    _userNameController.dispose();
    super.dispose();
  }

  // 监听焦点
  Future<Null> _focusNodeListener() async {
    if (_focusNodeUserName.hasFocus) {
      print("用户名框获取焦点");
      // 取消密码框的焦点状态
      _focusNodePassWord.unfocus();
      _focusNodeVertification.unfocus(); //
    }
    if (_focusNodePassWord.hasFocus) {
      print("密码框获取焦点");
      // 取消用户名框焦点状态
      _focusNodeUserName.unfocus();
      _focusNodeVertification.unfocus(); //
    }
    if (_focusNodePassWord.hasFocus) {
      print("密码框获取焦点");
      // 取消用户名框焦点状态
      _focusNodeUserName.unfocus();
      _focusNodePassWord.unfocus();
    }
  }

  /**
   * 验证用户名
   */
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

  /**
   * 验证密码
   */
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
        'Register',
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
              keyboardType: TextInputType.emailAddress,
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
    Widget registerButtonArea = new Container(
      margin: EdgeInsets.only(left: 70, right: 70),
      height: 45.0,
      child: new RaisedButton(
        color: Colors.brown[600],
        child: Text("注册",
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
              // 创建实例
              LCUser _user = LCUser();
              // 等同于 user['username'] = 'Tom';
              _user.username = _username;
              _user.password = _password;
              _user['savedTime'] = 0; //
              _user['ratio'] = 1;
              // 可选
              //user.email = 'tom@leancloud.rocks';
              // user.mobile = '+8618200008888';
              //user['gender'] = 'secret';// 设置其他属性的方法跟 LCObject 一样
              await _user.signUp();
              //event
              LCObject event = LCObject('Event');
              event['user'] = _user;
              event['name'] = '日程示例';
              event['date'] = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
              event['time'] = null;
              await event.save();
              //todo
              LCObject todo = LCObject('Todo');
              todo['user'] = _user;
              todo['name'] = '待办事项示例';
              todo['completion'] = false;
              await todo.save();
              //daka
              LCObject daka = LCObject('Daka');
              daka['user'] = _user;
              daka['name'] = '打卡示例';
              daka['iconIndex'] = 0;
              daka['records'] = [];
              await daka.save();

              Navigator.pop(context);
              _alertDialog('注册成功');
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

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        title: const Text('注册'),
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

            registerButtonArea,

            new SizedBox(
              height: ScreenUtil().setHeight(60),
            ),
            // thirdLoginArea,
            new SizedBox(
              height: ScreenUtil().setHeight(180),
            ),
//                      new SignInPage(),
//                      new SignUpPage(),
            // new Expanded(child: _pageView),
          ],
        ),
      ),
    );
  }
}
