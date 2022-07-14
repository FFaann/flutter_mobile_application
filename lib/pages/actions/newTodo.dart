import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:timemachine/bean.dart';

class NewTodoPage extends StatefulWidget {
  NewTodoPage({Key key}) : super(key: key);

  @override
  _NewTodoPageState createState() => _NewTodoPageState();
}

class _NewTodoPageState extends State<NewTodoPage> {
  TextEditingController _nameController;
  FocusNode _focusNode = new FocusNode();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String validateName(value) {
    if (value.isEmpty) {
      return '待办事项名称不能为空!';
    }
    return null;
  }

  @override
  void initState() {   
    _nameController = new TextEditingController();
    _focusNode.addListener(() {});
    super.initState();
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
            resizeToAvoidBottomInset: false,
            backgroundColor: backgroundColor,
            appBar: AppBar(
              centerTitle: true,
              // backgroundColor: Color.fromRGBO(255, 255, 240, 1),
              title: Text("创建一个新待办事项"),
              actions: [
                FlatButton(
                  shape: CircleBorder(),
                  child: Icon(Icons.check, color: Colors.black),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      //只有输入通过验证，才会执行这里
                      _formKey.currentState.save();
                      LCObject todo = LCObject('Todo');
                      LCUser _user = await LCUser.getCurrent();
                      todo['user'] = _user;
                      todo['name'] = _nameController.text;
                      todo['completion'] = false;
                      await todo.save();
                      Navigator.pop(
                        context,
                        // Todo(name: this._nameController.text)
                      );
                    }
                  },
                )
              ],
            ),
            body:Form(
        key: _formKey,
        child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: "待办事项名称",
                      hintText: "例如补卡、买菜等",
                      prefixIcon: Icon(FontAwesomeIcons.listAlt),
                    ),                 
                    validator: validateName,//验证
                  ),
                ],
              ),
            ))));
  }
}

// class SelectionButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new RaisedButton(
//       onPressed: () {
//         _navigateAndDisplaySelection(context);
//       },
//       child: new Text('Pick an option, any option!'),
//     );
//   }

//   // A method that launches the SelectionScreen and awaits the result from
//   // Navigator.pop!
//   _navigateAndDisplaySelection(BuildContext context) async {
//     // Navigator.push returns a Future that will complete after we call
//     // Navigator.pop on the Selection Screen!
//     final result = await Navigator.push(
//       context,
//       new MaterialPageRoute(builder: (context) => new NewTodoPage()),
//     );

//     // After the Selection Screen returns a result, show it in a Snackbar!
//     Scaffold.of(context)
//         .showSnackBar(new SnackBar(content: new Text("$result")));
//   }
// }
