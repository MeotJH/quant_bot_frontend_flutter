import 'package:flutter/material.dart';
import 'package:quant_bot_flutter/core/colors.dart';

class CustomToast extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color textColor;
  final Color backgroundColor;
  final String text;
  final bool isWarn;

  const CustomToast({
    super.key,
    required this.onPressed,
    required this.textColor,
    required this.backgroundColor,
    required this.text,
    required this.isWarn,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 15,
      height: 54,
      width: MediaQuery.of(context).size.width * 1,
      child: SizedBox(
        width: double.infinity,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isWarn
                    ? const Icon(Icons.error_outline, color: Colors.red)
                    : Icon(Icons.check_circle_outline,
                        color: CustomColors.clearBlue120),
                //SizedBox(width: 8.0),
                Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                const SizedBox(width: 8.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showCustomToast(BuildContext context, String message,
    {VoidCallback? onPressed, bool isWarn = false}) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => CustomToast(
      text: message,
      textColor: Colors.white,
      backgroundColor: Colors.black.withOpacity(0.7),
      onPressed: onPressed,
      isWarn: isWarn,
    ),
  );

  overlay.insert(overlayEntry);
  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}
