import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter_emoji/flutter_emoji.dart';

// const Color bottomColor = const Color(0xFFfbab66);
const Color backgroundColor = const Color.fromRGBO(255, 255, 240, 1);
// const Color orangeColor = const Color.fromRGBO(255, 255, 240, 1);
// const Color topBarColor = const Color.fromRGBO(180,120,80,1);

// var parser = EmojiParser();

// class NewTodoWidget extends StatefulWidget {
//   NewTodoWidget(Key key) : super(key: key);
//   @override
//   State<StatefulWidget> createState() {
//     return NewTodoWidgetState();
//   }
// }
// class NewTodoWidgetState extends State<NewTodoWidget> {
//   bool _hidden = true;
//   TextEditingController textController = new TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Offstage(
//         offstage: _hidden,
//         child: Container(
//           decoration: BoxDecoration(
//               border:
//                   Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))
//               // borderRadius: BorderRadius.circular(12.0),
//               ),
//           padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//           child: ListTile(
//             leading: Checkbox(
//               activeColor: Colors.deepOrange,
//               value: false,
//               onChanged: (v) {},
//             ),
//             title: TextField(
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//               ),
//               controller: textController,
//               focusNode: new FocusNode(),
//               // onChanged: (text){
//               //   print(text);
//               // },
//             ),
//           ),
//         ));
//   }
//   void onPressed(bool count) {
//     setState(() {
//       _hidden = count;
//     });
//   }
//   String printValue() {
//     return textController.text;
//   }
// }
// GlobalKey<NewTodoWidgetState> textKey = GlobalKey();
// bool hidden = true;


// MyUser(
//   userid: 1,
//   name: "fififcx",
//   pwd: "123456",
//   email: "fifi@fcx.com",
// );

//提醒事项
class MyUser {
  // String nn;
  int userid;
  String email;
  String name;
  String pwd;
  MyUser({
    @required this.userid,
    @required this.name,
    @required this.pwd,
    this.email,
  });
}

//习惯
class Habit {
  String name;
  // int userid;
  int iconIndex;
  bool done;
  List<DateTime> records = [
    DateTime(2021, 5, 3),
    DateTime(2021, 5, 6),
    DateTime(2021, 5, 11),
    DateTime(2021, 5, 12)
  ];
  // int period;
  Habit({
    @required this.name,
    @required this.iconIndex,
    this.done = false,
  })
  // : record = []
  ;
}

// List emojis = [Emoji('coffee', '☕'), Emoji('', '👅'), Emoji('', '🌷')];
List<IconData> icons = [
  Icons.access_alarm,
  Icons.assignment,
  Icons.fitness_center,
  Icons.pool,
  Icons.spa,
  Icons.landscape,
  Icons.money,
  Icons.face,
  Icons.email,
  Icons.import_contacts,
  Icons.create,
  Icons.camera_alt,
  Icons.local_florist,
  Icons.beach_access,
  Icons.fastfood,
  Icons.cake,
  Icons.free_breakfast,
  Icons.local_cafe,
  Icons.smoking_rooms,
  Icons.desktop_mac,
  Icons.kitchen,
  Icons.wb_sunny,
  Icons.looks,
  Icons.directions_walk,
  Icons.directions_bike,
  Icons.directions_run,
  Icons.fitness_center,
  Icons.school,
  Icons.domain,
  Icons.store,
];

//提醒事项
class Todo {
  String name;
  bool completion;
  // int userid;
  Todo(
      {@required this.name,
      // @required this.userid,
      this.completion = false});
}

class Event {
  String name;
  DateTime date;
  TimeOfDay time;
  // int userid;
  Event({@required this.name, @required this.date, this.time
      // @required this.userid,
      });
}

// final toDay =
//     DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
// Map<DateTime, List<Event>> events = {
//   toDay.subtract(Duration(days: 30)): [
//     Event(name: '日程', date: toDay.subtract(Duration(days: 30))),
//     Event(name: '日程', date: toDay.subtract(Duration(days: 30))),
//   ],
//   toDay.subtract(Duration(days: 27)): [
//     Event(name: '日程', date: toDay.subtract(Duration(days: 27))),
//   ],
//   toDay.subtract(Duration(days: 20)): [
//     Event(name: '日程', date: toDay.subtract(Duration(days: 20))),
//     Event(name: '日程', date: toDay.subtract(Duration(days: 20))),
//     Event(name: '日程', date: toDay.subtract(Duration(days: 20))),
//   ],
//   toDay.subtract(Duration(days: 16)): [
//     Event(name: '日程', date: toDay.subtract(Duration(days: 16))),
//   ],
//   toDay.subtract(Duration(days: 10)): [
//     Event(name: '日程', date: toDay.subtract(Duration(days: 10))),
//   ],
//   toDay.subtract(Duration(days: 4)): [
//     Event(name: '日程', date: toDay.subtract(Duration(days: 4))),
//   ],
//   toDay.subtract(Duration(days: 2)): [
//     Event(name: '日程', date: toDay.subtract(Duration(days: 3))),
//   ],
//   toDay: [
//     Event(name: '1', date: toDay),
//     Event(name: '日程', date: toDay,time: TimeOfDay(hour: 1,minute: 1)),
//     Event(name: '日程', date: toDay,time: TimeOfDay(hour: 2,minute: 1)),
//     Event(name: '2', date: toDay),
//     Event(name: '日程', date: toDay,time: TimeOfDay(hour: 3,minute: 1)),
//     Event(name: '3', date: toDay),
//   ],
//   toDay.add(Duration(days: 1)): [
//     Event(name: '日程', date: toDay.add(Duration(days: 1))),
//     Event(name: '日程', date: toDay.add(Duration(days: 1))),
//     Event(name: '日程', date: toDay.add(Duration(days: 1))),
//     Event(name: '日程', date: toDay.add(Duration(days: 1))),
//   ],
//   toDay.add(Duration(days: 3)): [
//     Event(name: '日程', date: toDay.add(Duration(days: 3))),
//   ],
//   toDay.add(Duration(days: 7)): [
//     Event(name: '日程', date: toDay.add(Duration(days: 7))),
//   ],
//   toDay.add(Duration(days: 11)): [
//     Event(name: '日程', date: toDay.add(Duration(days: 11))),
//   ],
//   toDay.add(Duration(days: 17)): [
//     Event(name: '日程', date: toDay.add(Duration(days: 17))),
//   ],
// };

