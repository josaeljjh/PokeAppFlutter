import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Vista de estado vacío o error con acción opcional.
class MessageView extends StatelessWidget {
  const MessageView({
    super.key,
    required this.message,
    required this.image,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final String image;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DsDimension.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(image, height: 120),
            const SizedBox(height: DsDimension.md),
            GenericLabel(
              label: message,
              alignment: AlignmentDirectional.center,
              textAlign: TextAlign.center,
              style: DsTypography.bodyRegular.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: DsDimension.lg),
              BasicFilledButton(
                label: actionLabel!,
                onPressed: onAction,
                width: 200,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
