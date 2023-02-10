import 'package:daily_expanditure_0131/shared/style.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String getValue;
  final Size customFixedSize;

  const CustomElevatedButton({super.key, required this.getValue, required this.customFixedSize});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        fixedSize: customFixedSize,
        backgroundColor: buttonColor,
        shadowColor: transparentColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonBorder[1]))
      ).copyWith(
        overlayColor: MaterialStateProperty.resolveWith((states) => states.contains(MaterialState.pressed) ? null : buttonColor),
        elevation: const MaterialStatePropertyAll(0),
      ),
      child: getValue.isEmpty ? const Text("0", style: sumTextStyle) : Text(getValue, style: sumTextStyle),
      onPressed: () => false
    );
  }
}
