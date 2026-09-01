class MenuCacheService {
  MenuCacheService._();

  static final MenuCacheService instance = MenuCacheService._();

  final Map<String, Map<String, dynamic>> _cache = {};

  Map<String, dynamic>? readMap(String key) {
    final value = _cache[key];

    if (value == null) {
      return null;
    }

    return Map<String, dynamic>.from(value);
  }

  void writeMap(String key, Map<String, dynamic> value) {
    _cache[key] = Map<String, dynamic>.from(value);
  }

  void remove(String key) {
    _cache.remove(key);
  }

  void clear() {
    _cache.clear();
  }
}
