enum FileModality {
  image,
  text,
  audio;

  String toJson() => name;

  static FileModality fromJson(String json) {
    return FileModality.values.firstWhere(
      (e) => e.name == json,
      orElse: () => FileModality.text,
    );
  }
}
