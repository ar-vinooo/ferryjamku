// To parse this JSON data, do
//
//     final penjualan = penjualanFromJson(jsonString);

import 'dart:convert';

List<Penjualan> penjualanFromJson(String str) => List<Penjualan>.from(json.decode(str).map((x) => Penjualan.fromJson(x)));

String penjualanToJson(List<Penjualan> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Penjualan {
  Penjualan({
    this.id,
    this.tanggalId,
    this.penyatat,
    this.detail,
    this.point,
    this.tanggal,
  });

  String id;
  String tanggalId;
  String penyatat;
  String detail;
  String point;
  DateTime tanggal;

  factory Penjualan.fromJson(Map<String, dynamic> json) => Penjualan(
        id: json["id"] == null ? null : json["id"],
        tanggalId: json["tanggal_id"] == null ? null : json["tanggal_id"],
        penyatat: json["penyatat"] == null ? null : json["penyatat"],
        detail: json["detail"] == null ? null : json["detail"],
        point: json["point"] == null ? null : json["point"],
        tanggal: json["tanggal"] == null ? null : DateTime.parse(json["tanggal"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "tanggal_id": tanggalId == null ? null : tanggalId,
        "penyatat": penyatat == null ? null : penyatat,
        "detail": detail == null ? null : detail,
        "point": point == null ? null : point,
        "tanggal": tanggal == null ? null : tanggal.toIso8601String(),
      };
}
