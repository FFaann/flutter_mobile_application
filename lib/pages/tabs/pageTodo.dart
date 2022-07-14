import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:left_scroll_actions/left_scroll_actions.dart';

class TodoPage extends StatefulWidget {
  TodoPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> with TickerProviderStateMixin {
  Map<int, TextEditingController> _textEditingControllers = new Map();
  Map<int, FocusNode> _focusNodes = new Map();
  bool _hidden = false;

  Future<List<LCObject>> retrieveData() async {
    LCQuery<LCObject> query = LCQuery('Todo');
    LCUser _user = await LCUser.getCurrent();
    query.whereEqualTo('user', _user); //查询
    if(_hidden==true){
      query.whereEqualTo('completion', false);
    }
    List<LCObject> results = await query.find();
    results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return (results);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingControllers.forEach((key, value) {
      _textEditingControllers[key].dispose();
    });
    _focusNodes.forEach((key, value) {
      _focusNodes[key].dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _focusNodes.forEach((key, value) {
            _focusNodes[key].unfocus();
          });
          // SystemChannels.textInput.invokeMethod('TextInput.hide');
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text("隐藏已完成",
                    style: TextStyle(color: _hidden?Colors.brown:Colors.grey[700], fontSize: 16)),
                Switch(
                  activeColor: Colors.brown,
                  activeTrackColor: Colors.brown[200],
                  // inactiveThumbColor:Colors.brown,
                  // inactiveTrackColor:Colors.brown[200],
                  value: _hidden,
                  onChanged: (bool value) {
                    setState(() {
                      _hidden = !_hidden;
                    });
                  },
                ),
              ]),
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(width: 8, color: Colors.brown),
                      bottom: BorderSide(width: 2, color: Colors.brown[300]))),
            ),
            // Container(
            //   height: 17,
            //   decoration: BoxDecoration(
            //       border: Border(
            //     top: BorderSide(width: 8, color: Colors.brown),
            //     bottom: BorderSide(width: 2, color: Colors.brown[300]),
            //   )),
            // ),
            // NewTodoWidget(textKey),
            Expanded(child: _buildTodoList()),
          ],
        ));
  }

  Widget _buildTodoList() {
    return FutureBuilder<List<LCObject>>(
      future: retrieveData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return new Divider(
                  height: 0.8,
                  color: Colors.grey,
                );
              },
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                LCObject data = snapshot.data[index];
                _textEditingControllers[data.hashCode] =
                    new TextEditingController(text: data['name']);
                _focusNodes[data.hashCode] = new FocusNode();
                _focusNodes[data.hashCode].addListener(() async {
                  if (!_focusNodes[data.hashCode].hasFocus) {
                    data['name'] = _textEditingControllers[data.hashCode].text;
                    await data.save();
                  }
                });
                return CupertinoLeftScroll(
                    key: Key(data.hashCode.toString()),
                    // closeTag: LeftScrollCloseTag('todo'),
                    buttonWidth: 60,
                    bounce: true,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1, color: Color(0xffe5e5e5)))
                          // borderRadius: BorderRadius.circular(12.0),
                          ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: ListTile(
                          leading: Checkbox(
                            activeColor: Colors.deepOrange,
                            value: data['completion'],
                            onChanged: (v) async {
                              data['completion'] = v;
                              await data.save();
                              setState(() {});
                            },
                          ),
                          title: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            // readOnly: false,
                            controller:
                                // TextEditingController(text: todo.name),
                                _textEditingControllers[data.hashCode],
                            focusNode: _focusNodes[data.hashCode],
                          ),
                          onTap: () => {
                                _focusNodes[data.hashCode].unfocus(),
                                // print('${data['name']} tapped!'),
                                // print("")
                              }),
                    ),
                    buttons: <Widget>[
                      InkWell(
                          child: Container(
                              alignment: Alignment.center,
                              color: Colors.deepOrange[600],
                              child: Icon(Icons.delete, color: Colors.white)),
                          onTap: () async {
                            await data.delete();
                            setState(() {});
                          })
                    ],
                    onTap: () {
                      print('tap row');
                    });
              },
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
