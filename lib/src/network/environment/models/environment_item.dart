class EnvironmentItem {
  final String name;
  final String baseUrl;
  final List<String> apiKeys;

  const EnvironmentItem({
    required this.name,
    required this.baseUrl,
    this.apiKeys = const [],
  });
}
