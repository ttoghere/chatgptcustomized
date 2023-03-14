import 'package:chatgptcustomized/models/models_model.dart';
import 'package:chatgptcustomized/providers/models_provider.dart';
import 'package:chatgptcustomized/services/api_services/api_services.dart';
import 'package:chatgptcustomized/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';

class ModelsDropDownWidget extends StatefulWidget {
  const ModelsDropDownWidget({super.key});

  @override
  State<ModelsDropDownWidget> createState() => _ModelsDropDownWidgetState();
}

class _ModelsDropDownWidgetState extends State<ModelsDropDownWidget> {
  String? currentModel;
  late ApiServices apiServices;
  @override
  void initState() {
    super.initState();
    apiServices = ApiServices();
  }

  @override
  Widget build(BuildContext context) {
    var modelProvider = Provider.of<ModelProvider>(context);
    currentModel = modelProvider.currentModel;
    return FutureBuilder<List<ModelsModel>>(
        future: modelProvider.getAllModels(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: TextWidget(label: snapshot.error.toString()),
            );
          }
          return snapshot.data == null || snapshot.data!.isEmpty
              ? const SizedBox.shrink()
              : FittedBox(
                  child: DropdownButton(
                    dropdownColor: scaffoldBackgroundColor,
                    iconEnabledColor: Colors.white,
                    items: List<DropdownMenuItem<String>>.generate(
                        snapshot.data!.length,
                        (index) => DropdownMenuItem(
                            value: snapshot.data![index].id,
                            child: TextWidget(
                              label: snapshot.data![index].id,
                              fontSize: 15,
                            ))),
                    value: currentModel,
                    onChanged: (value) {
                      modelProvider.setCurrentModel(value.toString());
                    },
                  ),
                );
        });
  }
}

/*
 DropdownButton(dropdownColor: scaffoldBackgroundColor,
    iconEnabledColor: Colors.white,
      items: getModelsItem,
      value: currentModel,
      onChanged: (value) {
        setState(() {
          currentModel = value.toString();
        });
      },
    );
 */