import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;
  var summonerName;
  var summonerLevel;
  var summonerProfileIcon;

  Future getSummonerData(String summonerName) async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String data = response.body;
      var decodeData = jsonDecode(data);
      print(decodeData);
      summonerName = decodeData['name'];
      summonerLevel = decodeData['summonerLevel'];
      summonerProfileIcon = decodeData['profileIconId'];
      return summonerName;
    } else {
      print(response.statusCode);
    }
  }
}
