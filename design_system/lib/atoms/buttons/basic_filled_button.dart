import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/dimensions.dart';
import '../../tokens/typography.dart';

class BasicFilledButton extends StatelessWidget {
  const BasicFilledButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = DsColors.primary,
    this.textColor = DsColors.white,
    this.width = DsDimension.buttonWidth,
    this.height = DsDimension.buttonHeight,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Color color;
  final Color textColor;
  final double width;
  final double height;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          disabledBackgroundColor: color.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DsDimension.radiusSm),
          ),
        ),
        child: isLoading
            ? SizedBox.square(
                dimension: DsDimension.iconSm,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: textColor,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: DsDimension.sm),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: DsTypography.captionBold.copyWith(
                        color: textColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
