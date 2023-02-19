class TabInfo {
  final String key;
  final String? categoryKey;
  final int? categoriesQuantity;
  const TabInfo({
    required this.key,
    this.categoryKey,
    this.categoriesQuantity,
  });

  bool get hasCategorySelector =>
      categoryKey != null &&
      categoryKey!.isNotEmpty &&
      categoriesQuantity != null &&
      categoriesQuantity! > 0;
}
