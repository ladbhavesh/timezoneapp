import 'dart:convert';

import 'configuration.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<String> convertTime(String from, String to, String time) async {
    var headers = getDefaultHeaders();

    var url = Uri.parse(
        "${Configuration.apiRoot}/convert?from_zone=$from&to_zone=$to&time_info=$time");

    print(url);

    var response = await http.get(url, headers: headers);

    print("response code is ${response.statusCode}");

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      var convertedTime = result["result"];
      return convertedTime;
    }

    return "";
  }

  Future<List<String>> getTimezones() async {
    //throw Exception("customer error thrown");
    var headers = getDefaultHeaders();

    var url = Uri.parse("${Configuration.apiRoot}/timezones");

    print(url);

    var response = await http.get(url, headers: headers);

    print("response code is ${response.statusCode}");

    if (response.statusCode == 200) {
      var list = jsonDecode(response.body) as List<dynamic>;
      List<String> listStr = [];
      //listStr = list.map((e) => e as String) as List<String>;
      for (var i = 0; i < list.length; i++) {
        print(list[i]);
        var strValue = list[i] as String;

        listStr.add(strValue);
      }

      return listStr;
    }

    return [];
  }

  Map<String, String> getDefaultHeaders() {
    Map<String, String> withAuthHeaders = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Basic ${Configuration.token}"
    };
    return withAuthHeaders;
  }
}
