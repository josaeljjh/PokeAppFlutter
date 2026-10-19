import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Imagen remota con placeholder de pokeball (equivalente a
/// `ImageView.setBackgroundUrl` con Glide del proyecto Android).
class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  static const String _placeholder =
      'packages/design_system/res/images/pokeball.png';

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final placeholder = Image.asset(
      _placeholder,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
    if (url.isEmpty) return placeholder;
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, __) => placeholder,
      errorWidget: (_, __, ___) => placeholder,
    );
  }
}
