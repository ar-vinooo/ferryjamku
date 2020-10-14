// To parse this JSON data, do
//
//     final tanggal = tanggalFromJson(jsonString);

import 'dart:convert';

List<Tanggal> tanggalFromJson(String str) => List<Tanggal>.from(json.decode(str).map((x) => Tanggal.fromJson(x)));

String tanggalToJson(List<Tanggal> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tanggal {
  Tanggal({
    this.id,
    this.tanggal,
    this.totalPenjualan,
    this.totalPoint,
  });

  String id;
  DateTime tanggal;
  String totalPenjualan;
  String totalPoint;

  factory Tanggal.fromJson(Map<String, dynamic> json) => Tanggal(
        id: json["id"] == null ? null : json["id"],
        tanggal: json["tanggal"] == null ? null : DateTime.parse(json["tanggal"]),
        totalPenjualan: json["total_penjualan"] == null ? null : json["total_penjualan"],
        totalPoint: json["total_point"] == null ? null : json["total_point"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "tanggal": tanggal == null ? null : "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "total_penjualan": totalPenjualan == null ? null : totalPenjualan,
        "total_point": totalPoint == null ? null : totalPoint,
      };
}
