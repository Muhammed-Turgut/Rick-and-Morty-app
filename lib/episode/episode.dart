class Episode {
  int id;
  String name;
  String air_date;
  String episode;
  List<String> characters; // 🔹 Burayı List<String> yapıyoruz
  String url;

  Episode.fromMap(Map<String,dynamic> episodeMap)
      : id = episodeMap["id"] ?? 0,
        name = episodeMap["name"] ?? "",
        air_date = episodeMap["air_date"] ?? "",
        episode = episodeMap["episode"] ?? "",
        characters = (episodeMap["characters"] as List<dynamic>)
            .map((e) => e.toString())
            .toList(), // 🔹 Her elemanı stringe çeviriyoruz
        url = episodeMap["url"] ?? "";
}
