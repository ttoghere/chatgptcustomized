import 'package:chatgptcustomized/constants/constants.dart';
import 'package:chatgptcustomized/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Services {
  static Future<void> showModalSheet({required BuildContext context}) async {
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      backgroundColor: scaffoldBackgroundColor,
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Flexible(
              child: TextWidget(
                label: "Chosen Model:",
                fontSize: 13,
              ),
            ),
            Flexible(
              flex: 2,
              child: ModelsDropDownWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
