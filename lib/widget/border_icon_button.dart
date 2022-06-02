import 'package:flutter/material.dart';
import 'package:pocs_flutter/util/app_colors.dart';

class BorderIconButton extends StatelessWidget {
  const BorderIconButton({
    Key? key,
    required this.icon,
    this.size,
    this.color,
    this.borderRadius,
    required this.onPressed
  }) : super(key: key);

  final IconData icon;
  final double? size;
  final Color? color;
  final BorderRadius? borderRadius;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(6),
          border: Border.all(
            color: color ?? Color(AppColors.defaultTextColor),
            width: 1
          )
        ),
        child: Icon(
          icon,
          size: size ?? 24,
          color: color ?? Color(AppColors.defaultTextColor),
        ),
      ),
    );
  }
}
