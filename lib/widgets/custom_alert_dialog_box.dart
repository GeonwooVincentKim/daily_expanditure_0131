// import 'package:flutter/cupertino.dart';
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
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      content: TextField(
        controller: controller,
        style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white))
        ),
        onSubmitted: (_) => submit(context),
      ),
      actions: [
        // CupertinoButton(
        //   onPressed: onSave,
        //   color: CupertinoColors.black,
        //   child: const Text(
        //     "Save",
        //     style: TextStyle(color: CupertinoColors.white),
        //   ),
        // ),
        // CupertinoButton(
        //   onPressed: onSave,
        //   color: CupertinoColors.black,
        //   child: const Text(
        //     "Cancel",
        //     style: TextStyle(color: CupertinoColors.white),
        //   ),
        // ),
        MaterialButton(
          onPressed: onSave,
          color: Colors.black,
          child: const Text(
            "Save",
            style: TextStyle(color: Colors.white)
          ),
        ),
        MaterialButton(
          onPressed: onCancel,
          color: Colors.black,
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.white)
          ),
        )
      ],
    );
  }

  void submit(BuildContext context) {
    Navigator.of(context).pop(controller.text);
    controller.clear();
  }
}