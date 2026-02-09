/// ثوابت خاصة بميزة الختمات
class KhatmahConstants {
  // عدد الأجزاء في القرآن الكريم
  static const int totalJuz = 30;

  // عدد الصفحات في القرآن الكريم
  static const int totalPages = 604;

  // عدد الصفحات في كل جزء (تقريبي)
  static const int pagesPerJuz = 20;

  // خيارات المدة الافتراضية (بالأيام)
  static const List<int> defaultDurations = [10, 20, 30, 40];

  // أسماء الخيارات
  static const Map<int, String> durationNames = {
    10: '10 أيام (3 أجزاء يومياً)',
    20: '20 يوم (1.5 جزء يومياً)',
    30: '30 يوم (جزء واحد يومياً)',
    40: '40 يوم (0.75 جزء يومياً)',
  };

  // صفحات بداية كل جزء
  static const Map<int, int> juzStartPages = {
    1: 1,
    2: 22,
    3: 42,
    4: 62,
    5: 82,
    6: 102,
    7: 122,
    8: 142,
    9: 162,
    10: 182,
    11: 202,
    12: 222,
    13: 242,
    14: 262,
    15: 282,
    16: 302,
    17: 322,
    18: 342,
    19: 362,
    20: 382,
    21: 402,
    22: 422,
    23: 442,
    24: 462,
    25: 482,
    26: 502,
    27: 522,
    28: 542,
    29: 562,
    30: 582,
  };

  // صفحات نهاية كل جزء
  static const Map<int, int> juzEndPages = {
    1: 21,
    2: 41,
    3: 61,
    4: 81,
    5: 101,
    6: 121,
    7: 141,
    8: 161,
    9: 181,
    10: 201,
    11: 221,
    12: 241,
    13: 261,
    14: 281,
    15: 301,
    16: 321,
    17: 341,
    18: 361,
    19: 381,
    20: 401,
    21: 421,
    22: 441,
    23: 461,
    24: 481,
    25: 501,
    26: 521,
    27: 541,
    28: 561,
    29: 581,
    30: 604,
  };

  // Hive box names
  // NOTE: bumped because of schema/ID conflicts. Current stable is v4.
  static const String khatmahBoxName = 'khatmahs_v4';
  static const String hadithBoxName = 'hadiths_v4';

  // Type IDs for Hive (shifted to 100+ to avoid common conflicts)
  static const int khatmahModelTypeId = 100;
  static const int dailyProgressTypeId = 101;
  static const int juzProgressTypeId = 102;
  static const int hadithModelTypeId = 103;
}
