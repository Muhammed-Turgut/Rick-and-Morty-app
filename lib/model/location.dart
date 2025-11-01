
class Location{

  int id;
  String name;
  String type;
  String dimension;
  List<String> residents;

  Location.fromMap(Map<String, dynamic> locationMap):

      id = locationMap["id"] ?? 0,
      name = locationMap["name"] ?? "",
      type = locationMap["type"] ?? "",
      dimension = locationMap["dimension"] ?? "",
      residents = (locationMap["residents"] as List<dynamic>)
          .map((e) => e.toString()).toList();

}
