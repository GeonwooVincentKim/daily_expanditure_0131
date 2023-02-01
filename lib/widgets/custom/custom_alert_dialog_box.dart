import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAlertDialogBox extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String hintText;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const CustomAlertDialogBox({
    super.key, 
    required this.controller, 
    required this.hintText, 
    required this.onSave, 
    required this.onCancel
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      content: CupertinoTextField(
        autofocus: true,
        keyboardType: TextInputType.number,
        controller: controller,
        style: const TextStyle(color: CupertinoColors.black),
        placeholder: hintText,
        onSubmitted: (_) => submit(context),
      ),
      actions: [
        TextButton(
          onPressed: onSave,
          child: const Text("저장")
        ),
        TextButton(
          onPressed: onCancel,
          child: const Text("취소"),
        )
      ],
    );
  }

  void submit(BuildContext context) {
    Navigator.of(context).pop(controller.text);
    controller.clear();
  }
}
