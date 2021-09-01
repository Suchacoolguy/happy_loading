import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = 'my api key';

class SummonerData {
  final String? id;
  final String? name;
  final int? profileIconId;
  final int? summonerLevel;

  SummonerData(
      {required this.id,
      required this.name,
      required this.profileIconId,
      required this.summonerLevel});

  factory SummonerData.fromJson(Map<String, dynamic> json) {
    return SummonerData(
      id: json['id'],
      name: json['name'],
      profileIconId: json['profileIconId'],
      summonerLevel: json['summonerLevel'],
    );
  }
}

class InGameData {
  final int? gameStartTime;

  InGameData({required this.gameStartTime});

  factory InGameData.fromJson(Map<String, dynamic> json) {
    return InGameData(gameStartTime: json['gameStartTime']);
  }
}

class InGameDataDecoder {
  Stream<InGameData> getData(
      {required String? id, required String url}) async* {
    http.Response response =
        await http.get(Uri.parse('$url$id?api_key=$apiKey'));

    if (response.statusCode == 200) {
      yield* Stream.periodic(Duration(seconds: 1), (int abc) {
        return InGameData.fromJson(json.decode(response.body));
      });
    } else {
      throw Exception('데이터를 불러오는 데 실패했습니다. 죄송합니다. 죽여주십시오.');
    }
  }
}

class SummonerApiDecoder {
  Future<SummonerData> getData(
      {required String id, required String url}) async {
    http.Response response =
        await http.get(Uri.parse('$url$id?api_key=$apiKey'));

    if (response.statusCode == 200) {
      return SummonerData.fromJson(json.decode(response.body));
    } else {
      throw Exception('데이터를 불러오는 데 실패했습니다. 죄송합니다. 죽여주십시오.');
    }
  }
}
