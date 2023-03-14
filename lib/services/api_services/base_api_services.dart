import 'package:chatgptcustomized/models/chat_model.dart';
import 'package:chatgptcustomized/models/models_model.dart';

abstract class BaseApiServices {
  Future<List<ModelsModel>> getModels();
  Future<List<ChatModel>> sendMessage({
    required String message,
    required String modelId,
  });
}
