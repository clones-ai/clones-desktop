String getFaviconUrl(String? domain) {
  if (domain == null || domain.isEmpty) return '';
  final cleanDomain = domain.replaceAll(RegExp(r'^(https?:\/\/)?(www\.)?'), '');
  final encodedDomain = Uri.encodeComponent(cleanDomain);
  final googleFaviconUrl = 'https://www.google.com/s2/favicons?domain=$encodedDomain&sz=32';
  // Use the Tauri proxy to avoid CORS issues
  return 'http://127.0.0.1:19847/proxy-image?url=${Uri.encodeComponent(googleFaviconUrl)}';
}
