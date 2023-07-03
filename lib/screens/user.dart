import 'dart:convert';

List<Lifecoach> lifecoachFromJson(String str) => List<Lifecoach>.from(
      json.decode(str).map(
            (x) => Lifecoach.fromJson(x),
          ),
    );

String lifecoachToJson(List<Lifecoach> data) => json.encode(
      List<dynamic>.from(
        data.map(
          (x) => x.toJson(),
        ),
      ),
    );

class Lifecoach {
  int id;
  String name;
  String route;

  Lifecoach({
    required this.id,
    required this.name,
    required this.route,
  });

  factory Lifecoach.fromJson(Map<String, dynamic> json) => Lifecoach(
        id: json["id"],
        name: json["name"],
        route: json["route"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "route": route,
      };
}

class User2 {
  String email;
  String password;
  User2(this.email, this.password);
}
