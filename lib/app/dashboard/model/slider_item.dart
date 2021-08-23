

class SliderItem {
  final String key;
  final String primaryText;
  final String? secondaryText;
  final String iconPath;
  SliderItem({
    required this.key,
    required this.primaryText,
    required this.iconPath,
    this.secondaryText
  });
}