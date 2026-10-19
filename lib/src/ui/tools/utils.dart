import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void changeNotificationBarColorIcon({required bool isLight}) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isLight ? Brightness.light : Brightness.dark,
      statusBarBrightness: isLight ? Brightness.dark : Brightness.light,
    ),
  );
}

/// Snackbar de la app (migrado de `View.snackbar` / `snackbarConexion`).
void showSnack(BuildContext context, String message, {IconData? icon}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: DsColors.white, size: DsDimension.iconSm),
              const SizedBox(width: DsDimension.sm),
            ],
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
}

/// Loader modal bloqueante (migrado de `FragmentActivity.loading()`).
void showLoadingDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const PopScope(
      canPop: false,
      child: Center(child: LottieLoader()),
    ),
  );
}

Future<T?> dialogBottomSheet<T>({
  required BuildContext context,
  required Widget child,
}) =>
    showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => child,
    );
