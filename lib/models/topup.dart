class TopUp {
  //atribut
  late int id;
  late int harga;

  //metod kontruktor
  TopUp({required this.id, required this.harga});

  TopUp.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    harga = json['harga'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['harga'] = harga;
    return data;
  }
}
