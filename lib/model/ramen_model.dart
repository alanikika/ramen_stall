
class RamenModel {

  String name;
  String address;
  String latitude;
  String longitude;

	RamenModel.fromJsonMap(Map<String, dynamic> map):
		name = map["name"],
		address = map["address"],
		latitude = map["latitude"],
		longitude = map["longitude"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['name'] = name;
		data['address'] = address;
		data['latitude'] = latitude;
		data['longitude'] = longitude;
		return data;
	}
}
