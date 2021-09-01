import 'package:flutter/material.dart';
import 'dart:async';
import 'package:happy_loading/services/get_data.dart';
import 'package:happy_loading/screens/requests_screen.dart';

const summonerDataUrl =
    'https://kr.api.riotgames.com/lol/summoner/v4/summoners/by-name/';

class SummonerInfoScreen extends StatefulWidget {
  final String value;
  SummonerInfoScreen(this.value);
  @override
  _SummonerInfoScreenState createState() => _SummonerInfoScreenState();
}

class _SummonerInfoScreenState extends State<SummonerInfoScreen> {
  late Future<SummonerData> myFuture;
  @override
  void initState() {
    super.initState();
    SummonerApiDecoder _dataTool = SummonerApiDecoder();
    myFuture = _dataTool.getData(id: widget.value, url: summonerDataUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('해피로딩'),
      ),
      body: SizedBox.expand(
        child: Container(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<SummonerData>(
                  future: myFuture,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text('none');
                      case ConnectionState.active:
                        return Text('active');
                      case ConnectionState.waiting:
                        return CircularProgressIndicator();
                      case ConnectionState.done:
                        if (!snapshot.hasData) {
                          return Text('소환사를 찾을 수 없습니다.');
                        }
                        int? mySummonerLevel = snapshot.data?.summonerLevel;
                        int? myProfileIconId = snapshot.data?.profileIconId;
                        return Column(
                          children: [
                            CircleAvatar(
                                radius: 75.0,
                                backgroundImage: AssetImage(
                                    "images/profileicon/$myProfileIconId.png")),
                            Text(
                              '소환사명: ${widget.value}',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              '소환사 레벨: ${mySummonerLevel.toString()}',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 100,
                            ),
                            ElevatedButton(
                                child: Text('접속여부조회 시작'),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return MakeRequestScreen(
                                        derivedId: snapshot.data?.id ?? null);
                                  }));
                                })
                          ],
                        );
                      default:
                        return Text('default');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
