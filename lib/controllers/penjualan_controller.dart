import 'package:ferryjamku/models/penjualan_model.dart';
import 'package:ferryjamku/services/api_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum PenjualanStatus { initial, loading, success, failure }

class PenjualanController extends GetxController {
  var listPenjualan = RxList<Penjualan>([]);
  var penjualanStatus = Rx<PenjualanStatus>(PenjualanStatus.initial);

  var apiService = ApiService();
  var getStorage = GetStorage();

  Future<void> fetchPenjualan(String id) async {
    penjualanStatus.value = PenjualanStatus.loading;
    try {
      listPenjualan.value = await apiService.fetchPenjualan(id);
      penjualanStatus.value = PenjualanStatus.success;
    } catch (e) {
      penjualanStatus.value = PenjualanStatus.failure;
    }
  }

  Future<Map<String, dynamic>> createPenjualan(String tanggalId, String detail, String point) async {
    String penyatat = getStorage.read('username');
    try {
      await apiService.createPenjualan(tanggalId, penyatat, detail, point);
      return {'code': 200, 'message': 'berhasil menambah penjualan!'};
    } catch (e) {
      return e;
    }
  }

  Future<Map<String, dynamic>> deletePenjualan(String id) async {
    try {
      await apiService.deletePenjualan(id);
      return {'code': 200, 'message': 'berhasil menghapus penjualan!'};
    } catch (e) {
      return e;
    }
  }
}
