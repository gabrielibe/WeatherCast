import 'dart:convert';
import 'package:http/http.dart';

class NetworkHelper {
  final String urll;

  NetworkHelper(this.urll);

  Future getData() async {
     final url = Uri.parse(urll);
    Response response = await get(url);

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}