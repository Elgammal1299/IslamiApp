import 'package:hive/hive.dart';

/// A generic Hive service for managing local storage across multiple projects.
///
/// This service provides a clean, type-safe interface for Hive operations
/// with built-in error handling, logging, and configuration options.
class HiveService<T> {
  final String boxName;
  final bool enableLogging;
  final Duration? operationTimeout;

  static final Map<String, HiveService> _instances = {};
  Box<T>? _box;

  /// Private constructor
  HiveService._({
    required this.boxName,
    this.enableLogging = false,
    this.operationTimeout,
  });

  /// Get or create a singleton instance for the given box name
  ///
  /// [boxName] - The name of the Hive box
  /// [enableLogging] - Whether to enable debug logging (default: false)
  /// [operationTimeout] - Optional timeout for operations
  static HiveService<T> instanceFor<T>({
    required String boxName,
    bool enableLogging = false,
    Duration? operationTimeout,
  }) {
    final key = '${boxName}_${T.toString()}';

    if (_instances.containsKey(key)) {
      return _instances[key] as HiveService<T>;
    } else {
      final instance = HiveService<T>._(
        boxName: boxName,
        enableLogging: enableLogging,
        operationTimeout: operationTimeout,
      );
      _instances[key] = instance;
      return instance;
    }
  }

  /// Initialize the Hive box
  ///
  /// Throws [HiveServiceException] if initialization fails
  Future<void> init() async {
    try {
      _log('Initializing box: $boxName');

      if (!Hive.isBoxOpen(boxName)) {
        _box = await Hive.openBox<T>(boxName);
        _log('Box opened successfully: $boxName');
      } else {
        _box = Hive.box<T>(boxName);
        _log('Box already open: $boxName');
      }
    } catch (e) {
      _log('Error initializing box: $e', isError: true);
      throw HiveServiceException('Failed to initialize box "$boxName": $e');
    }
  }

  /// Ensure the box is open and return it
  Box<T> get _ensureBox {
    if (_box == null || !_box!.isOpen) {
      throw HiveServiceException(
        'Box "$boxName" not initialized. Call init() first.',
      );
    }
    return _box!;
  }

  /// Add or update an item with a key
  ///
  /// [key] - The key for the item
  /// [item] - The item to store
  Future<void> put(String key, T item) async {
    try {
      _log('Putting item with key: $key');
      final box = _ensureBox;
      await box.put(key, item);
      _log('Item put successfully: $key');
    } catch (e) {
      _log('Error putting item: $e', isError: true);
      throw HiveServiceException('Failed to put item with key "$key": $e');
    }
  }

  /// Add an item at the end of the box
  ///
  /// [item] - The item to add
  /// Returns the index where the item was added
  Future<int> add(T item) async {
    try {
      _log('Adding item to box');
      final box = _ensureBox;
      final index = await box.add(item);
      _log('Item added at index: $index');
      return index;
    } catch (e) {
      _log('Error adding item: $e', isError: true);
      throw HiveServiceException('Failed to add item: $e');
    }
  }

  /// Add multiple items at once
  ///
  /// [items] - List of items to add
  /// Returns list of indices where items were added
  Future<List<int>> addAll(List<T> items) async {
    try {
      _log('Adding ${items.length} items to box');
      final box = _ensureBox;
      final indices = await box.addAll(items);
      _log('Items added successfully');
      return indices.toList();
    } catch (e) {
      _log('Error adding items: $e', isError: true);
      throw HiveServiceException('Failed to add items: $e');
    }
  }

  /// Replace all items in the box
  ///
  /// [items] - List of items to replace with
  Future<void> putAll(List<T> items) async {
    try {
      _log('Replacing all items (${items.length} items)');
      final box = _ensureBox;
      await box.clear();
      await box.addAll(items);
      _log('All items replaced successfully');
    } catch (e) {
      _log('Error replacing items: $e', isError: true);
      throw HiveServiceException('Failed to replace items: $e');
    }
  }

  /// Get an item by key
  ///
  /// [key] - The key of the item
  /// Returns the item or null if not found
  T? get(String key) {
    try {
      _log('Getting item with key: $key');
      final box = _ensureBox;
      final item = box.get(key);
      _log('Item retrieved: ${item != null ? 'found' : 'not found'}');
      return item;
    } catch (e) {
      _log('Error getting item: $e', isError: true);
      throw HiveServiceException('Failed to get item with key "$key": $e');
    }
  }

  /// Get an item by index
  ///
  /// [index] - The index of the item
  /// Returns the item or null if index is out of bounds
  T? getAt(int index) {
    try {
      _log('Getting item at index: $index');
      final box = _ensureBox;
      final item = box.getAt(index);
      _log('Item retrieved: ${item != null ? 'found' : 'not found'}');
      return item;
    } catch (e) {
      _log('Error getting item at index: $e', isError: true);
      throw HiveServiceException('Failed to get item at index $index: $e');
    }
  }

  /// Get all items in the box
  ///
  /// Returns a list of all items
  Future<List<T>> getAll() async {
    try {
      _log('Getting all items');
      final box = _ensureBox;
      final items = box.values.toList();
      _log('Retrieved ${items.length} items');
      return items;
    } catch (e) {
      _log('Error getting all items: $e', isError: true);
      throw HiveServiceException('Failed to get all items: $e');
    }
  }

  /// Update an item at a specific index
  ///
  /// [index] - The index to update
  /// [item] - The new item
  Future<void> putAt(int index, T item) async {
    try {
      _log('Updating item at index: $index');
      final box = _ensureBox;
      await box.putAt(index, item);
      _log('Item updated successfully at index: $index');
    } catch (e) {
      _log('Error updating item: $e', isError: true);
      throw HiveServiceException('Failed to update item at index $index: $e');
    }
  }

  /// Delete an item by key
  ///
  /// [key] - The key of the item to delete
  Future<void> delete(String key) async {
    try {
      _log('Deleting item with key: $key');
      final box = _ensureBox;
      await box.delete(key);
      _log('Item deleted successfully: $key');
    } catch (e) {
      _log('Error deleting item: $e', isError: true);
      throw HiveServiceException('Failed to delete item with key "$key": $e');
    }
  }

  /// Delete an item by index
  ///
  /// [index] - The index of the item to delete
  Future<void> deleteAt(int index) async {
    try {
      _log('Deleting item at index: $index');
      final box = _ensureBox;
      await box.deleteAt(index);
      _log('Item deleted successfully at index: $index');
    } catch (e) {
      _log('Error deleting item at index: $e', isError: true);
      throw HiveServiceException('Failed to delete item at index $index: $e');
    }
  }

  /// Clear all items from the box
  Future<void> clear() async {
    try {
      _log('Clearing all items from box');
      final box = _ensureBox;
      await box.clear();
      _log('Box cleared successfully');
    } catch (e) {
      _log('Error clearing box: $e', isError: true);
      throw HiveServiceException('Failed to clear box: $e');
    }
  }

  /// Close the box
  Future<void> close() async {
    try {
      _log('Closing box: $boxName');
      if (_box != null && _box!.isOpen) {
        await _box!.close();
        _box = null;
        _log('Box closed successfully');
      }
    } catch (e) {
      _log('Error closing box: $e', isError: true);
      throw HiveServiceException('Failed to close box: $e');
    }
  }

  /// Check if the box is open
  bool get isOpen => _box != null && _box!.isOpen;

  /// Get the number of items in the box
  int get length {
    if (_box == null || !_box!.isOpen) return 0;
    return _box!.length;
  }

  /// Check if the box is empty
  bool get isEmpty => length == 0;

  /// Check if the box has items
  bool get isNotEmpty => !isEmpty;

  /// Get all keys in the box
  List<dynamic> get keys {
    if (_box == null || !_box!.isOpen) return [];
    return _box!.keys.toList();
  }

  /// Check if a key exists
  bool containsKey(String key) {
    if (_box == null || !_box!.isOpen) return false;
    return _box!.containsKey(key);
  }

  /// Get items that match a condition
  ///
  /// [test] - Function that returns true for items to include
  List<T> where(bool Function(T) test) {
    if (_box == null || !_box!.isOpen) return [];
    return _box!.values.where(test).toList();
  }

  /// Get the first item that matches a condition
  ///
  /// [test] - Function that returns true for the item to find
  /// Returns the first matching item or null if none found
  T? firstWhere(bool Function(T) test, {T? orElse}) {
    if (_box == null || !_box!.isOpen) return orElse;
    try {
      if (orElse == null) {
        return _box!.values.firstWhere(test);
      } else {
        return _box!.values.firstWhere(test, orElse: () => orElse);
      }
    } catch (e) {
      return orElse;
    }
  }

  /// Get box statistics
  Map<String, dynamic> get statistics {
    return {
      'boxName': boxName,
      'isOpen': isOpen,
      'length': length,
      'isEmpty': isEmpty,
      'type': T.toString(),
    };
  }

  /// Log a message if logging is enabled
  void _log(String message, {bool isError = false}) {
    if (enableLogging) {
      final prefix = isError ? '❌' : '📦';
      print('$prefix HiveService[$boxName]: $message');
    }
  }

  /// Dispose of the service and close the box
  Future<void> dispose() async {
    await close();
    final key = '${boxName}_${T.toString()}';
    _instances.remove(key);
  }
}

/// Custom exception for Hive service operations
class HiveServiceException implements Exception {
  final String message;

  HiveServiceException(this.message);

  @override
  String toString() => 'HiveServiceException: $message';
}

/// Extension to provide additional utility methods
extension HiveServiceExtensions<T> on HiveService<T> {
  /// Get items as a map of key-value pairs
  Map<String, T> toMap() {
    if (_box == null || !_box!.isOpen) return {};
    final map = <String, T>{};
    for (final key in _box!.keys) {
      final value = _box!.get(key);
      if (value != null) {
        map[key.toString()] = value;
      }
    }
    return map;
  }

  /// Get items as a list of key-value pairs
  List<MapEntry<String, T>> toEntries() {
    return toMap().entries.toList();
  }

  /// Get all values as a list
  List<T> toList() {
    if (_box == null || !_box!.isOpen) return [];
    return _box!.values.toList();
  }
}
