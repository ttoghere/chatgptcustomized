import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatgptcustomized/constants/constants.dart';
import 'package:chatgptcustomized/models/chat_model.dart';
import 'package:chatgptcustomized/models/models_model.dart';
import 'package:chatgptcustomized/services/api_services/base_api_services.dart';
import 'package:http/http.dart' as http;

class ApiServices extends BaseApiServices {
  //Get list of useable Models
  @override
  Future<List<ModelsModel>> getModels() async {
    try {
      var url = Uri.parse("$baseUrl/models");
      var response = await http.get(url, headers: {
        "Authorization": "Bearer $apiKey",
      });
      Map jsonResponse = json.decode(response.body);
      if (jsonResponse["error"] != null) {
        dynamic errorText = jsonResponse['error']['message'];
        // log("jsonResponse['error']: $errorText");
        throw HttpException(errorText);
      }
      log("jsonResponse: $jsonResponse");
      List temp = [];
      for (var mm in jsonResponse["data"]) {
        temp.add(mm);
        // log("Temp ${mm['id']}");
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  //How to post request for how to send message
  @override
  Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      var url = Uri.parse("$baseUrl/completions");
      var response = await http.post(url,
          headers: {
            "Authorization": "Bearer $apiKey",
            "Content-Type": "application/json",
          },
          body: json.encode({
            "model": modelId,
            "prompt": message,
            "max_tokens": 200,
          }));
      Map jsonResponse = json.decode(response.body);
      if (jsonResponse["error"] != null) {
        dynamic errorText = jsonResponse['error']['message'];
        // log("jsonResponse['error']: $errorText");
        throw HttpException(errorText);
      }
      List<ChatModel> chatList = [];

      if (jsonResponse["choices"].length > 0) {
        // log("jsonResponse['choices']['text'] : ${jsonResponse['choices'][0]['text']}");
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
              msg: jsonResponse["choices"][index]["text"], chatIndex: 1),
        );
      }
      return chatList;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
