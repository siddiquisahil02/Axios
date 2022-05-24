class EmergencyModel {
  EmergencyModel({
    required this.value,
  });
  late final List<Value> value;

  EmergencyModel.fromJson(Map<String, dynamic> json){
    value = List.from(json['value']).map((e)=>Value.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['value'] = value.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Value {
  Value({
    required this.number,
    required this.name,
  });
  late final String number;
  late final String name;

  Value.fromJson(Map<String, dynamic> json){
    number = json['number'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['number'] = number;
    _data['name'] = name;
    return _data;
  }
}