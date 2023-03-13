import 'package:chatgptcustomized/models/models_model.dart';

abstract class BaseApiServices {
  Future<List<ModelsModel>> getModels();
}
