import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:timemachine/bean.dart';

class NewEventPage extends StatefulWidget {
  NewEventPage({Key key}) : super(key: key);

  @override
  _NewEventPageState createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  var _nameController = new TextEditingController();
  bool _allDay = false;
  DateTime selectedDate;
  TimeOfDay selectedTime;
  FocusNode _focusNode = new FocusNode();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String validateName(value) {
    if (value.isEmpty) {
      return '日程名称不能为空!';
    }
    return null;
  }

    @override
  void initState() {   
    selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    selectedTime = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
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

  Future<void> _selectDate() async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    setState(() {
      selectedDate = DateTime(date.year, date.month, date.day);
    });
    print(selectedDate);
  }

  Future<void> _selectTime() async {
    final TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (time == null) return;

    setState(() {
      selectedTime = time;
    });
    print(selectedTime);
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
              title: Text("创建一个新日程"),
              actions: [
                FlatButton(
                  shape: CircleBorder(),
                  child: Icon(Icons.check, color: Colors.black),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      //只有输入通过验证，才会执行这里
                      _formKey.currentState.save();
                      LCObject event = LCObject('Event');
                      LCUser _user = await LCUser.getCurrent();
                      event['user'] = _user;
                      event['name'] = this._nameController.text;
                      event['date'] = selectedDate;
                      event['time'] = _allDay
                          ? null
                          : DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute);
                      await event.save();
                 
                      Navigator.pop(
                        context,
                      );
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
                      //打卡项目名
                      TextFormField(
                        controller: _nameController,
                        focusNode: _focusNode,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: "日程名称",
                          hintText: "例如开会、上课等",
                          prefixIcon: Icon(Icons.event),
                        ),
                        validator: validateName, //验证
                      ),
                      SizedBox(height: 30),
                      //Icon
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("选择日期时间",
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 16)),
                            Row(children: [
                              Text("全天日程",
                                  style: TextStyle(
                                      color: _allDay?Colors.brown:Colors.grey[700], fontSize: 16)),
                              Switch(
                                activeColor: Colors.brown,
                                activeTrackColor: Colors.brown[200],
                                // inactiveThumbColor:Colors.brown,
                                // inactiveTrackColor:Colors.brown[200],
                                value: _allDay,
                                onChanged: (bool value) {
                                  setState(() {
                                    _allDay = !_allDay;
                                  });
                                },
                              )
                            ]),
                          ]),
                      SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            onTap: _selectDate,
                            child: Row(
                              children: <Widget>[
                                Text(DateFormat.yMMMMd().format(selectedDate),
                                    style: TextStyle(
                                        color: Colors.grey[850], fontSize: 16)),
                                Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                          Offstage(
                              offstage: _allDay,
                              child: InkWell(
                                onTap: _selectTime,
                                child: Row(
                                  children: <Widget>[
                                    Text(selectedTime.format(context),
                                        style: TextStyle(
                                            color: Colors.grey[850],
                                            fontSize: 16)),
                                    Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ))));
  }
}
