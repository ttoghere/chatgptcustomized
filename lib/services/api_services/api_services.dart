import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatgptcustomized/constants/constants.dart';
import 'package:chatgptcustomized/models/models_model.dart';
import 'package:chatgptcustomized/services/api_services/base_api_services.dart';
import 'package:http/http.dart' as http;

class ApiServices extends BaseApiServices {
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
}
