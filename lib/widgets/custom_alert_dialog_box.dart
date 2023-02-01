// import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAlertDialogBox extends StatelessWidget {
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
        controller: controller,
        style: const TextStyle(color: CupertinoColors.black),
        placeholder: hintText,
        onSubmitted: (_) => submit(context),
      ),
      actions: [
        TextButton(
          onPressed: onSave,
          child: const Text("저장")
        )
      ],
    );
  }

  void submit(BuildContext context) {
    Navigator.of(context).pop(controller.text);
    controller.clear();
  }
}