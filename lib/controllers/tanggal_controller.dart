import 'package:ferryjamku/models/tanggal_model.dart';
import 'package:ferryjamku/services/api_service.dart';
import 'package:get/get.dart';

enum TanggalStatus { initial, loading, success, failure }

class TanggalController extends GetxController {
  var tanggalStatus = Rx<TanggalStatus>(TanggalStatus.initial);
  var listTanggal = RxList<Tanggal>([]);
  var nowTanggal = Rx<Tanggal>();

  ApiService apiService = ApiService();
  DateTime dateNow = DateTime.now();

  Future<void> fetchTanggal() async {
    tanggalStatus.value = TanggalStatus.loading;
    try {
      listTanggal.value = await apiService.fetchTanggal();
      nowTanggal.value = listTanggal.where((element) => element.tanggal.day == dateNow.day && element.tanggal.month == dateNow.month).isNotEmpty ? listTanggal.where((element) => element.tanggal.day == dateNow.day && element.tanggal.month == dateNow.month).first : null;
      tanggalStatus.value = TanggalStatus.success;
    } catch (e) {
      tanggalStatus.value = TanggalStatus.failure;
    }
  }

  Future<Map<String, dynamic>> createTanggal() async {
    try {
      await apiService.createTanggal();
      return {'code': 200, 'message': 'berhasil membuat data!'};
    } catch (e) {
      return e;
    }
  }
}
