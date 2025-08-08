import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/theme/constants/app_colors.dart';

class ElevatedButtonWithState extends StatelessWidget {
  final bool isLoading;
  final bool isError;
  final Widget child;
  final VoidCallback? onPressed;
  final ButtonStyle? customStyle;

  const ElevatedButtonWithState({
    Key? key,
    required this.isLoading,
    required this.isError,
    required this.child,
    required this.onPressed,
    this.customStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style:
          customStyle ??
          ElevatedButton.styleFrom(
            disabledBackgroundColor: AppColors.green.withOpacity(.6),
            disabledForegroundColor: Colors.white70,


            backgroundColor: isError
                ? Theme.of(context).colorScheme.error
                : null,
          ),
      child: _getState(),
    );
  }

  Widget _getState() {
    if (isLoading) {
      return const CircularProgressIndicator.adaptive(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
      );
    }
    if (isError) {
      return Text('error'.tr);
    }
    return child;
  }
}
