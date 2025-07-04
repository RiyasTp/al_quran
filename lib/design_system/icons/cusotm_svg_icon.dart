import 'package:al_quran/design_system/icons/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A customizable SVG icon widget that uses [SvgIconData].
///
/// This widget loads an SVG asset identified by an [SvgIconData] object.
/// It allows for customization of size and color, defaulting to the ambient
/// [IconTheme] if not provided.
class CustomSvgIcon extends StatelessWidget {
  /// The SVG icon data to display.
  final SvgIconData icon;

  /// The size (width and height) of the icon.
  ///
  /// If null, it defaults to the `size` from the ambient `IconTheme`,
  /// which itself defaults to 24.0.
  final double? size;

  /// The color to apply to the icon.
  ///
  /// If null, it defaults to the `color` from the ambient `IconTheme`.
  final Color? color;

  /// An optional semantic label for accessibility.
  final String? semanticsLabel;

  const CustomSvgIcon({
    super.key,
    required this.icon, // <-- Updated from assetName
    this.size,
    this.color,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final finalSize = size ?? iconTheme.size ?? 24.0;
    final finalColor = color ?? iconTheme.color;

    return SvgPicture.asset(
      icon.assetName, // <-- Updated from assetName
      width: finalSize,
      height: finalSize,
      colorFilter: finalColor != null
          ? ColorFilter.mode(finalColor, BlendMode.srcIn)
          : null,
      semanticsLabel: semanticsLabel,
    );
  }
}