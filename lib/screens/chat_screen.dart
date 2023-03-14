import 'dart:developer';

import 'package:chatgptcustomized/models/chat_model.dart';
import 'package:chatgptcustomized/providers/models_provider.dart';
import 'package:chatgptcustomized/services/api_services/api_services.dart';
import 'package:chatgptcustomized/services/assets_manager.dart';
import 'package:chatgptcustomized/services/services.dart';
import 'package:chatgptcustomized/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textEditingController = TextEditingController();

  late ApiServices apiServices;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    apiServices = ApiServices();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  List<ChatModel> chatList = [];

  @override
  Widget build(BuildContext context) {
    var modelProvider = Provider.of<ModelProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openAiLogo),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context: context);
            },
            icon: const Icon(
              Icons.more_vert_outlined,
              color: Colors.white,
            ),
          ),
        ],
        title: const Text("ChatGPT"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: modelProvider.isTyping ? 500 : 510,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  var access = chatList[index];
                  return ChatWidget(
                    msg: access.msg,
                    chatIndex: access.chatIndex,
                  );
                },
                itemCount: chatList.length,
                shrinkWrap: true,
              ),
            ),
            if (modelProvider.isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
            const SizedBox(
              height: 9,
            ),
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        controller: textEditingController,
                        onSubmitted: (value) {},
                        decoration: const InputDecoration.collapsed(
                          hintText: "How can i help you ?",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await sendMessageMethod(modelProvider: modelProvider);
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> sendMessageMethod({required ModelProvider modelProvider}) async {
    try {
      log("Request has been sent ");
      modelProvider.changeStatus();
      setState(() {
        chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        textEditingController.clear();
        focusNode.unfocus();
      });
      chatList.addAll(
        await apiServices.sendMessage(
          message: textEditingController.text,
          modelId: modelProvider.currentModel,
        ),
      );
      setState(() {});
      modelProvider.changeStatus();
    } catch (error) {
      log(error.toString());
    }
  }
}
