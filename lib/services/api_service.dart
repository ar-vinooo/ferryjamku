import 'package:ferryjamku/models/penjualan_model.dart';
import 'package:ferryjamku/models/tanggal_model.dart';
import 'package:ferryjamku/utils.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<Tanggal>> fetchTanggal() async {
    var response = await http.get(
      '$kApiUrl/tanggal.php?all',
      headers: {'x-api-key': 'ferryjamku', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return tanggalFromJson(response.body);
      }
      return [];
    } else {
      throw {'code': response.statusCode, 'message': response.body};
    }
  }

  Future<void> createTanggal() async {
    var response = await http.post(
      '$kApiUrl/tanggal.php',
      headers: {'x-api-key': 'ferryjamku'},
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw {'code': response.statusCode, 'message': response.body};
    }
  }

  Future<List<Penjualan>> fetchPenjualan(String id) async {
    var response = await http.get(
      '$kApiUrl/penjualan.php?id=$id',
      headers: {'x-api-key': 'ferryjamku'},
    );
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return penjualanFromJson(response.body);
      }
      return [];
    } else {
      throw {'code': response.statusCode, 'message': response.body};
    }
  }

  Future<void> createPenjualan(String tanggalId, String penyatat, String detail, String point) async {
    var response = await http.post(
      '$kApiUrl/penjualan.php',
      body: {
        'tanggal_id': tanggalId,
        'penyatat': penyatat,
        'detail': detail,
        'point': point,
      },
      headers: {'x-api-key': 'ferryjamku'},
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw {'code': response.statusCode, 'message': response.body};
    }
  }

  Future<void> deletePenjualan(String id) async {
    var response = await http.post(
      '$kApiUrl/penjualan.php?delete=$id',
      headers: {'x-api-key': 'ferryjamku'},
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw {'code': response.statusCode, 'message': response.body};
    }
  }
}
