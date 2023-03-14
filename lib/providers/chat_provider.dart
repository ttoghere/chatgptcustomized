import 'dart:developer';
import 'package:chatgptcustomized/models/chat_model.dart';
import 'package:chatgptcustomized/providers/models_provider.dart';
import 'package:chatgptcustomized/services/api_services/api_services.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  ApiServices apiServices = ApiServices();

  List<ChatModel> _chatList = [];
  List<ChatModel> get chatList {
    return [..._chatList];
  }

  void scrollListToEnd({
    required ScrollController sController,
  }) {
    sController.animateTo(sController.position.maxScrollExtent,
        duration: const Duration(seconds: 2), curve: Curves.bounceIn);
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId}) async {
    if (chosenModelId.toLowerCase().startsWith("gpt")) {
      chatList.addAll(await apiServices.sendMessageGPT(
        message: msg,
        modelId: chosenModelId,
      ));
    } else {
      chatList.addAll(await apiServices.sendMessage(
        message: msg,
        modelId: chosenModelId,
      ));
    }
    notifyListeners();
  }

  Future<void> sendMessageMethod({
    required BuildContext context,
    required ModelProvider modelProvider,
    required List<ChatModel> chatList,
    required TextEditingController textEditingController,
    required FocusNode focusNode,
    required ScrollController scrollController,
    required ChatProvider chatProvider,
  }) async {
    try {
      String msg = textEditingController.text;
      String currentModel = modelProvider.currentModel;
      log("Request has been sent ");
      modelProvider.changeStatus();

      chatList.add(ChatModel(
        msg: msg,
        chatIndex: 0,
      ));
      textEditingController.clear();
      focusNode.unfocus();

      chatList.addAll(
        await apiServices.sendMessage(
          message: msg,
          modelId: currentModel,
        ),
      );

      modelProvider.changeStatus();
      chatProvider.scrollListToEnd(sController: scrollController);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: ${error}"),
      ));
      log(error.toString());
    }
  }
}
