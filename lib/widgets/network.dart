import 'dart:async';
import 'dart:convert';

import './route.dart';
import 'package:http/http.dart' as http;

class NetworkUtil {
  static final BASE_URL =
      "https://maps.googleapis.com/maps/api/directions/json?";

  static NetworkUtil _instance = new NetworkUtil.internal();

  NetworkUtil.internal();

  factory NetworkUtil() => _instance;
  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url) {

    return http.get(BASE_URL + url).then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
      print('API response: '+ res);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        res = "{\"status\":" +
            statusCode.toString() +
            ",\"message\":\"error\",\"response\":" +
            res +
            "}";
        throw new Exception(res);
      }

      List<Steps> steps;
      var distance;
      try {
        distance = _decoder.convert(res)["routes"][0]["legs"][0]["distance"]["text"];
        steps =
            parseSteps(_decoder.convert(res)["routes"][0]["legs"][0]["steps"]);
      } catch (e) {
        throw new Exception(res);
      }

      return {"distance": distance, "steps":steps};
    });
  }

  List<Steps> parseSteps(final responseBody) {
    var list =
    responseBody.map<Steps>((json) => new Steps.fromJson(json)).toList();

    return list;
  }
}
