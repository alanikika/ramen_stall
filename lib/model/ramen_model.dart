
class RamenModel {

	int id;
  String name;
  String address;
  String latitude;
  String longitude;


	RamenModel({this.id, this.name, this.address, this.latitude, this.longitude});

  RamenModel.fromJsonMap(Map<String, dynamic> map):
		id = map["id"],
		name = map["name"],
		address = map["address"],
		latitude = map["latitude"],
		longitude = map["longitude"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = id;
		data['name'] = name;
		data['address'] = address;
		data['latitude'] = latitude;
		data['longitude'] = longitude;
		return data;
	}
}
