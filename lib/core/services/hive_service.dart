import 'package:hive/hive.dart';

class HiveService<T> {
  final String boxName;
  static final Map<String, HiveService> _instances = {};

  Box<T>? _box;

  /// private constructor
  HiveService._(this.boxName);

  /// Singleton instance getter
  static HiveService<T> instanceFor<T>(String boxName) {
    if (_instances.containsKey(boxName)) {
      return _instances[boxName] as HiveService<T>;
    } else {
      final instance = HiveService<T>._(boxName);
      _instances[boxName] = instance;
      return instance;
    }
  }

  /// فتح الصندوق مرة واحدة فقط
  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      _box = await Hive.openBox<T>(boxName);
    } else {
      _box = Hive.box<T>(boxName);
    }
  }

  /// تأكد أن الصندوق مفتوح
  Box<T> get _ensureBox {
    if (_box == null || !_box!.isOpen) {
      throw Exception('Box "$boxName" not initialized. Call init() first.');
    }
    return _box!;
  }

  Future<void> putAll(List<T> items) async {
    final box = _ensureBox;
    await box.clear();
    await box.addAll(items);
  }

  Future<void> addItem(String key, T item) async {
    final box = _ensureBox;
    await box.put(key, item);
  }

  Future<List<T>> getAll() async {
    final box = _ensureBox;
    return box.values.toList();
  }

  Future<void> updateItemAt(int index, T item) async {
    final box = _ensureBox;
    await box.putAt(index, item);
  }

  Future<void> deleteItemAt(int index) async {
    final box = _ensureBox;
    await box.deleteAt(index);
  }

  Future<void> deleteItem(String key) async {
    final box = _ensureBox;
    await box.delete(key);
  }

  Future<void> clearBox() async {
    final box = _ensureBox;
    await box.clear();
  }

  Future<void> closeBox() async {
    final box = _ensureBox;
    await box.close();
    _box = null;
  }
}
