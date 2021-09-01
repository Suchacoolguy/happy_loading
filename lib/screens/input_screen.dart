import 'package:flutter/material.dart';
import 'package:happy_loading/screens/summoner_info.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  String? typedName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('해피로딩'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              onSubmitted: (value) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SummonerInfoScreen(value);
                }));
              },
              decoration: InputDecoration(
                labelText: 'User Name',
                hintText: '소환사명(닉네임)을 입력하세요.',
                prefixIcon: Icon(Icons.perm_identity),
                // filled: true,
                // fillColor: Colors.black12
                // border:
              ),
            ),
          ],
        ),
      ),
    );
  }
}
