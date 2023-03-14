import 'package:chatgptcustomized/models/models_model.dart';
import 'package:chatgptcustomized/services/api_services/api_services.dart';
import 'package:flutter/material.dart';

class ModelProvider extends ChangeNotifier {
  bool isTyping = false;
  ApiServices apiServices = ApiServices();
  List<ModelsModel> modelsList = [];
  List<ModelsModel> get getModelsList {
    return [...modelsList];
  }

  Future<List<ModelsModel>> getAllModels() async {
    modelsList = await apiServices.getModels();
    return modelsList;
  }

  String _currentModel = "text-davinci-003";
  String get currentModel {
    return _currentModel;
  }

  void changeStatus() {
    isTyping = !isTyping;
    notifyListeners();
  }

  void setCurrentModel(String newModel) {
    _currentModel = newModel;
    notifyListeners();
  }

}
