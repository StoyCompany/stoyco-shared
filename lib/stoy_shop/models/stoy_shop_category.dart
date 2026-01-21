/// Categories available for filtering StoyShop products.
///
/// These categories determine the type of products to retrieve
/// from the optimized endpoint.
enum StoyShopCategory {
  /// Cultural assets including NFTs, collectibles, and digital art.
  culturalAssets('CulturalAssets'),

  /// General products (merchandise, digital goods, etc.).
  products('Products'),

  /// Exclusive experiences and access.
  experiences('Experiences'),

  /// Recently added products.
  recent('Recent');

  const StoyShopCategory(this.value);

  final String value;

  static StoyShopCategory? fromString(String? value) {
    if (value == null) return null;
    return StoyShopCategory.values.cast<StoyShopCategory?>().firstWhere(
          (category) =>
              category?.value.toLowerCase() == value.toLowerCase() ||
              category?.name.toLowerCase() == value.toLowerCase(),
          orElse: () => null,
        );
  }
}
