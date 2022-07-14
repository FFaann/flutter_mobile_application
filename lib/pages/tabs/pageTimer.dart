import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:timemachine/pages/pageSandClock.dart';
import 'package:timemachine/timer.dart';

class TimerPage extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => TimerPage(),
      ),
    );
  }

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final _isHours = true;
  // ValueNotifier<double> _counter;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    // onChange: (value) => print('onChange $value'), //
    // onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    // onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
  );

  final _scrollController = ScrollController();

  Future<LCUser> retrieveData() async {
    LCUser _user = await LCUser.getCurrent();
    return (_user);
  }

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.rawTime.listen((value) => print(
        'rawTime $value ${StopWatchTimer.getDisplayTime(value, milliSecond: false)}'));
    // _stopWatchTimer.minuteTime.listen((value) => {print('minuteTime $value')});
    // _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    // _stopWatchTimer.records.listen((value) => print('records $value'));

    /// Can be set preset time. This case is "00:01.23".
    // _stopWatchTimer.setPresetTime(mSec: 1234);
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  bool isRunning = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LCUser>(
      future: retrieveData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            LCUser user = snapshot.data;
            print(user['savedTime']);
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 17,
                  decoration: BoxDecoration(
                      border: Border(
                    top: BorderSide(width: 8, color: Colors.brown),
                    bottom: BorderSide(width: 2, color: Colors.brown[300]),
                  )),
                ),

                /// Display stop watch time
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: StreamBuilder<int>(
                    stream: _stopWatchTimer.rawTime,
                    initialData: _stopWatchTimer.rawTime.valueWrapper?.value,
                    builder: (context, snap) {
                      final value = snap.data;
                      final displayTime =
                          StopWatchTimer.getDisplayTime(value, hours: _isHours);
                      return Column(
                        children: <Widget>[
                          SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              displayTime,
                              style: TextStyle(
                                  color: Colors.brown[800],
                                  fontSize: 40,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8),
                          //   child: Text(
                          //     value.toString(),
                          //     style: const TextStyle(
                          //         fontSize: 16,
                          //         fontFamily: 'Helvetica',
                          //         fontWeight: FontWeight.w400),
                          //   ),
                          // ),
                        ],
                      );
                    },
                  ),
                ),
                // /// Recording time.
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 0),
                //   child: StreamBuilder<int>(
                //     stream: _stopWatchTimer.rawTime,
                //     initialData: _stopWatchTimer.rawTime.valueWrapper?.value,
                //     builder: (context, snap) {
                //       final value = snap.data;
                //       final displayTime = StopWatchTimer.getDisplayTime(value,
                //           milliSecond: false, hours: _isHours);
                //       return Column(
                //         children: <Widget>[
                //           Padding(
                //             padding: const EdgeInsets.all(8),
                //             child: Text(
                //               displayTime,
                //               style: const TextStyle(
                //                   fontSize: 17,
                //                   fontFamily: 'Helvetica',
                //                   fontWeight: FontWeight.bold),
                //             ),
                //           ),

                /// Lap time.
                Container(
                  height: 120,
                  margin: const EdgeInsets.all(8),
                  child: StreamBuilder<List<StopWatchRecord>>(
                    stream: _stopWatchTimer.records,
                    initialData: _stopWatchTimer.records.valueWrapper?.value,
                    builder: (context, snap) {
                      final value = snap.data;
                      if (value.isEmpty) {
                        return Container();
                      }
                      Future.delayed(const Duration(milliseconds: 100), () {
                        _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut);
                      });
                      print('Listen records. $value');
                      return ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          final data = value[index];
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  '${index + 1} ${data.displayTime}',
                                  style: TextStyle(
                                      color: Colors.brown[800],
                                      fontSize: 17,
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Divider(
                                height: 1,
                              )
                            ],
                          );
                        },
                        itemCount: value.length,
                      );
                    },
                  ),
                ),

                /// Button
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: RaisedButton(
                                child: isRunning
                                    ? Text("Stop",
                                        style: TextStyle(color: Colors.white))
                                    : Text(
                                        "Start",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                padding: const EdgeInsets.all(4),
                                color: isRunning ? Colors.red : Colors.green,
                                shape: const StadiumBorder(),
                                onPressed: () async {
                                  // _stopWatchTimer.onExecute.add(StopWatchExecute.start);

                                  if (isRunning == false) {
                                    _stopWatchTimer.onExecute
                                        .add(StopWatchExecute.start);
                                  } else {
                                    _stopWatchTimer.onExecute
                                        .add(StopWatchExecute.stop);
                                  }
                                  setState(() => isRunning = !isRunning);
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(0)
                                        .copyWith(right: 8),
                                    child: RaisedButton(
                                      child: const Text(
                                        'Lap',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      color: Colors.blueGrey[300],
                                      shape: const StadiumBorder(),
                                      onPressed: () async {
                                        _stopWatchTimer.onExecute
                                            .add(StopWatchExecute.lap);
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: RaisedButton(
                                      padding: const EdgeInsets.all(4),
                                      color: Colors.blue[600],
                                      shape: const StadiumBorder(),
                                      onPressed: () async {
                                        _stopWatchTimer.onExecute
                                            .add(StopWatchExecute.reset);
                                        setState(() => isRunning = false);
                                      },
                                      child: const Text(
                                        'Reset',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8),
                          child: 
                          Text(
                              "可休息时间:${user['savedTime'] ~/60}分${user['savedTime'] % 60}秒",
                              style: TextStyle(
                                  color: Colors.brown[700],
                                  fontSize: 18,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.bold))),
                      Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text("ratio:${user['ratio']}",
                              style: TextStyle(
                                  color: Colors.brown[700],
                                  fontSize: 18,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.bold))),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: RaisedButton(
                                child: Text(
                                  "Save",
                                  style: TextStyle(color: Colors.white),
                                ),
                                padding: const EdgeInsets.all(4),
                                color: Colors.amber[400],
                                shape: const StadiumBorder(),
                                onPressed: () {
                                  _stopWatchTimer.onExecute
                                      .add(StopWatchExecute.reset);
                                  setState(() {
                                    isRunning = false;
                                    print('isRunning' + isRunning.toString());
                                  });
                                  setState(() async {
                                    user['savedTime'] = user['savedTime'] +
                                        _stopWatchTimer.second ~/ user['ratio'];
                                    await user.save();
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: RaisedButton(
                                child: Text(
                                  "Relax",
                                  style: TextStyle(color: Colors.white),
                                ),
                                padding: const EdgeInsets.all(4),
                                color: Colors.red[300],
                                shape: const StadiumBorder(),
                                onPressed: () {
                                  _stopWatchTimer.onExecute
                                      .add(StopWatchExecute.stop);
                                  Future future =
                                      // Navigator.pushNamed(
                                      //     context, '/pageSandClock');
                                      Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => new SandClockPage(
                                            savedTime: user['savedTime'])),
                                  );
                                  future.then((value) {
                                    setState(() async {
                                      isRunning = false;
                                      user['savedTime'] = value;
                                      await user.save();
                                      setState(() {});
                                    });
                                  });
                                },
                              ),
                            ),
                          ]),
                      // Padding(
                      //   padding: const EdgeInsets.all(0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: <Widget>[
                      //       Padding(
                      //         padding: const EdgeInsets.symmetric(horizontal: 4),
                      //         child: RaisedButton(
                      //           padding: const EdgeInsets.all(4),
                      //           color: Colors.pinkAccent,
                      //           shape: const StadiumBorder(),
                      //           onPressed: () async {
                      //             _stopWatchTimer.setPresetHoursTime(1);
                      //           },
                      //           child: const Text(
                      //             'Set Hours',
                      //             style: TextStyle(color: Colors.white),
                      //           ),
                      //         ),
                      //       ),
                      //       Padding(
                      //         padding: const EdgeInsets.symmetric(horizontal: 4),
                      //         child: RaisedButton(
                      //           padding: const EdgeInsets.all(4),
                      //           color: Colors.pinkAccent,
                      //           shape: const StadiumBorder(),
                      //           onPressed: () async {
                      //             _stopWatchTimer.setPresetMinuteTime(59);
                      //           },
                      //           child: const Text(
                      //             'Set Minute',
                      //             style: TextStyle(color: Colors.white),
                      //           ),
                      //         ),
                      //       ),
                      //       Padding(
                      //         padding: const EdgeInsets.symmetric(horizontal: 4),
                      //         child: RaisedButton(
                      //           padding: const EdgeInsets.all(4),
                      //           color: Colors.pinkAccent,
                      //           shape: const StadiumBorder(),
                      //           onPressed: () async {
                      //             _stopWatchTimer.setPresetSecondTime(59);
                      //           },
                      //           child: const Text(
                      //             'Set Second',
                      //             style: TextStyle(color: Colors.white),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 4),
                      //   child: RaisedButton(
                      //     padding: const EdgeInsets.all(4),
                      //     color: Colors.pinkAccent,
                      //     shape: const StadiumBorder(),
                      //     onPressed: () async {
                      //       _stopWatchTimer.setPresetTime(mSec: 3599 * 1000);
                      //     },
                      //     child: const Text(
                      //       'Set PresetTime',
                      //       style: TextStyle(color: Colors.white),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            );
          }
        } else {
          // 请求未结束，显示loading
           return Center(child:CircularProgressIndicator(valueColor:  AlwaysStoppedAnimation<Color>(Colors.deepOrange)));
        }
      },
    );
  }
}
