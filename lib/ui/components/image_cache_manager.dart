import 'dart:typed_data';

class CachedImage {
  CachedImage({
    required this.bytes,
    required this.cachedAt,
  });
  
  final Uint8List bytes;
  final DateTime cachedAt;
  
  bool get isExpired {
    final now = DateTime.now();
    const ttl = Duration(hours: 1);
    return now.difference(cachedAt) > ttl;
  }
}

class ImageCacheManager {
  factory ImageCacheManager() => _instance;
  ImageCacheManager._internal();
  
  static final ImageCacheManager _instance = ImageCacheManager._internal();
  
  final Map<String, CachedImage> _cache = {};
  
  Uint8List? getCachedImage(String url) {
    final cached = _cache[url];
    if (cached == null) return null;
    
    if (cached.isExpired) {
      _cache.remove(url);
      return null;
    }
    
    return cached.bytes;
  }
  
  void cacheImage(String url, Uint8List bytes) {
    _cache[url] = CachedImage(
      bytes: bytes,
      cachedAt: DateTime.now(),
    );
  }
  
  void clearExpiredCache() {
    final expiredKeys = <String>[];
    for (final entry in _cache.entries) {
      if (entry.value.isExpired) {
        expiredKeys.add(entry.key);
      }
    }
    for (final key in expiredKeys) {
      _cache.remove(key);
    }
  }
  
  void clearCache() {
    _cache.clear();
  }
  
  int get cacheSize => _cache.length;
}