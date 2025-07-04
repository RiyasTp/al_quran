/// A description of an SVG icon asset.
///
/// This class is used to identify a specific SVG asset to be rendered by the
/// [CustomSvgIcon] widget.
class SvgIconData {
  /// The path to the SVG asset in your project's assets folder,
  /// e.g., 'assets/icons/my_icon.svg'.
  final String assetName;

  /// Creates a description of an SVG icon.
  ///
  /// The [assetName] argument must not be null.
  const SvgIconData(this.assetName);
}

/// A library of SVG icons used in the application.
///
/// This class provides static constants for each SVG icon, ensuring type safety
/// and easy access. To add a new icon, place the SVG file in the
/// 'assets/icons/' directory and add a corresponding static const here.
class SvgIcons {
  // This class is not meant to be instantiated.
  SvgIcons._();

  // Define the path prefix for convenience.
  static const String _path = 'assets/icons';


  // Define all your icons as static const SvgIconData fields.
  static const SvgIconData home = SvgIconData('$_path/home.svg');
  static const SvgIconData bookmark = SvgIconData('$_path/bookmark.svg');
  static const SvgIconData note = SvgIconData('$_path/note.svg');
  static const SvgIconData search = SvgIconData('$_path/search.svg');
  static const SvgIconData settings = SvgIconData('$_path/settings.svg');
}
