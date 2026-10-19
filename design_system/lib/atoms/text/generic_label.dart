import 'package:flutter/widgets.dart';

import '../../tokens/typography.dart';

class GenericLabel extends StatelessWidget {
  const GenericLabel({
    super.key,
    required this.label,
    this.style,
    this.lines = 20,
    this.textAlign = TextAlign.left,
    this.alignment = AlignmentDirectional.centerStart,
    this.overflow = TextOverflow.ellipsis,
    this.softWrap = true,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
  });

  final String label;
  final TextStyle? style;
  final int? lines;
  final TextAlign textAlign;
  final AlignmentDirectional alignment;
  final TextOverflow overflow;
  final bool softWrap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: margin,
        child: Padding(
          padding: padding,
          child: Text(
            label,
            overflow: overflow,
            softWrap: softWrap,
            style: style ?? DsTypography.bodyRegular,
            maxLines: lines,
            textAlign: textAlign,
          ),
        ),
      ),
    );
  }
}
