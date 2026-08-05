/// Egypt's governorates, used both for the city dropdown and for matching
/// whatever the device geocoder reports back when reverse-geocoding a pin.
abstract class EgyptCities {
  static const List<String> all = [
    'القاهرة',
    'الجيزة',
    'الإسكندرية',
    'الدقهلية',
    'البحر الأحمر',
    'البحيرة',
    'الفيوم',
    'الغربية',
    'الإسماعيلية',
    'المنوفية',
    'المنيا',
    'القليوبية',
    'الوادي الجديد',
    'السويس',
    'أسوان',
    'أسيوط',
    'بني سويف',
    'بورسعيد',
    'دمياط',
    'الشرقية',
    'جنوب سيناء',
    'كفر الشيخ',
    'مطروح',
    'الأقصر',
    'قنا',
    'شمال سيناء',
    'سوهاج',
  ];

  /// Maps a raw geocoder string (e.g. "محافظة القاهرة", "Cairo Governorate")
  /// onto one of [all], or null when nothing matches — callers must not push a
  /// non-matching value into the dropdown, as that would break it.
  static String? matchFrom(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;

    final normalized = _normalize(raw);
    if (normalized.isEmpty) return null;

    for (final city in all) {
      final candidate = _normalize(city);
      if (normalized.contains(candidate) || candidate.contains(normalized)) {
        return city;
      }
    }

    // The geocoder may answer in English if the device locale wins out.
    final english = raw.toLowerCase();
    for (final entry in _englishAliases.entries) {
      if (english.contains(entry.key)) return entry.value;
    }
    return null;
  }

  /// Strips the "محافظة" prefix and folds the alef/ta-marbuta spelling variants
  /// so "محافظة القاهره" still matches "القاهرة".
  static String _normalize(String value) => value
      .replaceAll('محافظة', '')
      .replaceAll(RegExp('[أإآ]'), 'ا')
      .replaceAll('ة', 'ه')
      .replaceAll('ي', 'ى')
      .replaceAll(RegExp(r'\s+'), '')
      .trim();

  static const Map<String, String> _englishAliases = {
    'cairo': 'القاهرة',
    'giza': 'الجيزة',
    'alexandria': 'الإسكندرية',
    'dakahlia': 'الدقهلية',
    'red sea': 'البحر الأحمر',
    'beheira': 'البحيرة',
    'faiyum': 'الفيوم',
    'fayoum': 'الفيوم',
    'gharbia': 'الغربية',
    'ismailia': 'الإسماعيلية',
    'monufia': 'المنوفية',
    'minya': 'المنيا',
    'qalyubia': 'القليوبية',
    'new valley': 'الوادي الجديد',
    'suez': 'السويس',
    'aswan': 'أسوان',
    'asyut': 'أسيوط',
    'beni suef': 'بني سويف',
    'port said': 'بورسعيد',
    'damietta': 'دمياط',
    'sharqia': 'الشرقية',
    'south sinai': 'جنوب سيناء',
    'kafr el': 'كفر الشيخ',
    'matrouh': 'مطروح',
    'matruh': 'مطروح',
    'luxor': 'الأقصر',
    'qena': 'قنا',
    'north sinai': 'شمال سيناء',
    'sohag': 'سوهاج',
  };
}
