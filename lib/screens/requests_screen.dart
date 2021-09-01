import 'package:flutter/material.dart';
import 'package:happy_loading/services/get_data.dart';
import 'dart:async';

String inGameDataUrl =
    'https://kr.api.riotgames.com/lol/spectator/v4/active-games/by-summoner/';

class MakeRequestScreen extends StatefulWidget {
  final String? derivedId;
  MakeRequestScreen({this.derivedId});
  // Declare a field that holds the Todo.

  @override
  _MakeRequestScreenState createState() => _MakeRequestScreenState();
}

class _MakeRequestScreenState extends State<MakeRequestScreen> {
  int stopper = 0;
  late Stream<InGameData> myStream;
  InGameDataDecoder myData = InGameDataDecoder();

  void _showNotification() {}

  @override
  void initState() {
    super.initState();
    myStream = myData.getData(id: widget.derivedId, url: inGameDataUrl);
    setUpTimedFetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('해피로딩'),
      ),
      body: Container(
        child: SafeArea(
          child: Column(
            children: [
              StreamBuilder<InGameData>(
                  stream: myStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text(
                        'Looking for your match,,,',
                        style: TextStyle(fontSize: 30.0),
                        textAlign: TextAlign.center,
                      );
                    } else {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Text('Select a lot');
                        case ConnectionState.waiting:
                          return Expanded(
                              child:
                                  Center(child: CircularProgressIndicator()));
                        case ConnectionState.active:
                          if (snapshot.data!.gameStartTime.toString() == '0') {
                            return Text(
                              'Got into loading screen!',
                              style: TextStyle(
                                fontSize: 30.0,
                                color: Colors.yellow,
                              ),
                            );
                          }
                          if (snapshot.data!.gameStartTime.toString().length >
                                  6 &&
                              snapshot.data!.gameStartTime.toString().length !=
                                  0) {
                            stopper = 1;
                            return Expanded(
                                child: Center(
                                    child: Text(
                              'Your game has started.',
                              style: TextStyle(
                                fontSize: 30.0,
                                color: Colors.greenAccent,
                              ),
                            )));
                          }
                          return Text('hmm,,,');
                        case ConnectionState.done:
                          return Text('done');
                      }
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  setUpTimedFetch() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (mounted && stopper == 0) {
        setState(() {
          // maybe i need to make this function repeated
          myStream = myData.getData(id: widget.derivedId, url: inGameDataUrl);
        });
      }
    });
  }
}
