import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:timemachine/bean.dart';

class NewDakaPage extends StatefulWidget {
  NewDakaPage({Key key}) : super(key: key);

  @override
  _NewDakaPageState createState() => _NewDakaPageState();
}

class _NewDakaPageState extends State<NewDakaPage> {
  TextEditingController _nameController;
  FocusNode _focusNode = new FocusNode();
  int _iconIndex = 0;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String validateName(value) {
    print(value);
    if (value.isEmpty) {
      return '打卡名称不能为空!';
    }else if(value.length>7){
      return '打卡名称长度过长!';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _nameController = new TextEditingController();
    _focusNode.addListener(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _focusNode.unfocus();
        },
        child: Scaffold(
            backgroundColor: backgroundColor,
            resizeToAvoidBottomInset: false, //
            appBar: AppBar(
              centerTitle: true,
              title: Text("新建一个新打卡"),
              actions: [
                FlatButton(
                  shape: CircleBorder(),
                  child: Icon(Icons.check, color: Colors.black),
                  onPressed: () async {
                    _focusNode.unfocus();
                    if (_formKey.currentState.validate()) {
                      //只有输入通过验证，才会执行这里
                      _formKey.currentState.save();
                      LCObject daka = LCObject('Daka');
                      LCUser _user = await LCUser.getCurrent();
                      daka['user'] = _user;
                      daka['name'] = _nameController.text;
                      daka['iconIndex'] = _iconIndex;
                      daka['records'] = [
                        DateTime(2021, 5, 11),
                        DateTime(2021, 5, 12),
                        DateTime(2021, 5, 13),
                        DateTime(2021, 5, 15),
                      ];
                      await daka.save();
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
            body: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        focusNode: _focusNode,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: "打卡名称",
                          hintText: "例如早起、健身等",
                          prefixIcon: Icon(Icons.data_usage),
                        ),
                        validator: validateName, //验证
                      ),
                      SizedBox(height: 30),
                      //Icon
                      Text("挑选一个图标",
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 16)),
                      SizedBox(height: 20),
                      Container(
                        width: 400,
                        height: 200,
                        color: Color.fromRGBO(215, 185, 150, 1),
                        child: GridView.count(
                          scrollDirection: Axis.horizontal,
                          crossAxisCount: 3, //横轴Widget数量
                          crossAxisSpacing: 10, //横轴间距
                          mainAxisSpacing: 10, //主轴间距
                          padding: EdgeInsets.all(10), //间距
                          children: List<int>.generate(icons.length,
                                  (int index) {
                            // 也是可变数组
                            return index;
                          })
                              .map((index) => Container(
                                      child: RaisedButton(
                                    child: Icon(icons[index],
                                        color: index == _iconIndex
                                            ? backgroundColor
                                            : Color.fromRGBO(191, 42, 42, 1)),
                                    splashColor: Colors.pink[300], //水波纹
                                    color: index == _iconIndex
                                        ? Color.fromRGBO(191, 42, 42, 1)
                                        : backgroundColor,
                                    // shape: CircleBorder(
                                    //     side: BorderSide(
                                    //         color: Color.fromRGBO(191, 42, 42, 1),
                                    //         width: 5)),
                                    onPressed: () {
                                      setState(() {
                                        _focusNode.unfocus();
                                        _iconIndex = index;
                                      });
                                    },
                                  )))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}
