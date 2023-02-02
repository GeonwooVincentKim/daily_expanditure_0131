import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAlertDialogBox extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String hintText;
  final bool hasSumValue;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const CustomAlertDialogBox({
    super.key, 
    required this.controller, 
    required this.hintText, 
    required this.hasSumValue,
    required this.onSave, 
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return hasSumValue == true ? 
      CupertinoAlertDialog(
        content: CupertinoTextField(
          autofocus: true,
          keyboardType: TextInputType.number,
          controller: controller,
          style: const TextStyle(color: CupertinoColors.black),
          placeholder: hintText,
          onSubmitted: (_) => submit(context),
        ),
        actions: [
          // hasSumValue ? (
          //   TextButton(
          //     onPressed: onSave,
          //     child: const Text("저장")
          //   )
          // ) : CupertinoAlertDialog(
          //   content: const Text("총 합계를 먼저 입력해주세요"),
          //   actions: [
          //     TextButton(
          //       onPressed: onCancel,
          //       child: const Text("확인"),
          //     )
          //   ],
          // ),
          TextButton(
            onPressed: onSave,
            child: const Text("저장")
          ),
          TextButton(
            onPressed: onCancel,
            child: const Text("취소"),
          )
        ],
      ) : CupertinoAlertDialog(
        content: const Text("목표 금액을 설정하세요"),
        actions: [
          TextButton(
            onPressed: onCancel,
            child: const Text("뒤로 가기")
          )
        ],
      );
  }

  void submit(BuildContext context) {
    Navigator.of(context).pop(controller.text);
    controller.clear();
  }
}