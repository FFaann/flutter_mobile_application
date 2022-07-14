import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import '../../table_calendar/table_calendar.dart';
import 'package:timemachine/bean.dart';
import 'package:timemachine/pages/pageDakaRecords.dart';

class DakaPage extends StatefulWidget {
  DakaPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DakaPageState createState() => _DakaPageState();
}

class _DakaPageState extends State<DakaPage> with TickerProviderStateMixin {
  bool _hidden = false;

  Future<List<LCObject>> retrieveData() async {
    LCQuery<LCObject> query = LCQuery('Daka');
    LCUser _user = await LCUser.getCurrent();
    query.whereEqualTo('user', _user); //查询
    if (_hidden == true) {
      query.whereNotEqualTo(
          'records',
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day));
    }
    List<LCObject> results = await query.find();
    return (results);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text("隐藏已完成",
                style: TextStyle(
                    color: _hidden ? Colors.brown : Colors.grey[700],
                    fontSize: 16)),
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
        Expanded(child: _buildHabitList()),
      ],
    );
  }

  Widget _buildHabitList() {
    Color _color = Colors.brown[400];
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return FutureBuilder<List<LCObject>>(
        future: retrieveData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return LayoutBuilder(builder: (context, constrains) {
                var _width = constrains.maxWidth;
                var _height = constrains.maxHeight;
                return Container(
                    padding: EdgeInsets.only(left: 50, right: 50),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, //列数，即一行有几个子元素
                        childAspectRatio:
                            ((_width - 160) / 2) / ((_height) / 3), //子元素的宽高比例
                        crossAxisSpacing: 60, //次轴方向上的空隙间距；
                      ),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        LCObject daka = snapshot.data[index];
                        return Container(
                            child: Column(children: [
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                              width: (_width - 160) / 2,
                              height: (_width - 160) / 2,
                              child: RaisedButton(
                                color: daka['records'].contains(today)
                                    ? _color //Colors.deepOrange[800]
                                    : backgroundColor,
                                child: Icon(icons[daka['iconIndex']],
                                    size: (_width - 20) / 6,
                                    color: daka['records'].contains(today)
                                        ? backgroundColor
                                        : _color), //Colors.deepOrange[800]),
                                shape: CircleBorder(
                                    side: BorderSide(
                                        color: daka['records'].contains(today)
                                            ? _color //Colors.deepOrange[800]
                                            : Colors.black26,
                                        width: 7)),
                                onPressed: () async {
                                  print("${daka['name']} tapped!");
                                  if (daka['records'].contains(today)) {
                                    daka.remove('records', today);
                                  } else {
                                    daka.add('records', today); //队尾 unique?
                                  }
                                  await daka.save();
                                  setState(() {});
                                },
                                onLongPress: () {
                                  print("${daka['name']} loooooooooongTapped!");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              new DakaRecordsPage(
                                                daka: daka,
                                              )));
                                },
                              )),
                          Text(daka['name'],
                              style: TextStyle(
                                  fontSize: ((_width - 160) / 14) - 2,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.brown[800],
                                  letterSpacing: 1)),
                        ]));
                      },
                    ));
              });
            }
          } else {
            // 请求未结束，显示loading
            return Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.deepOrange)));
          }
        });
  }
}
