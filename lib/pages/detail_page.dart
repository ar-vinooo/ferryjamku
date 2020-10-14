import 'package:ferryjamku/controllers/penjualan_controller.dart';
import 'package:ferryjamku/models/penjualan_model.dart';
import 'package:ferryjamku/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatelessWidget {
  final String id;
  final DateTime tanggal;
  DetailPage(this.id, this.tanggal);
  final oCcy = new NumberFormat("#,###,###", "id_ID");

  String totalPemasukan(List<Penjualan> listPenjualan) {
    int totalPemasukan = 0;
    listPenjualan.forEach((element) {
      if (int.parse(element.point) > 0) {
        totalPemasukan += int.parse(element.point);
      }
    });
    return oCcy.format(totalPemasukan);
  }

  String totalPenjualan(List<Penjualan> listPenjualan) {
    int totalPenjualan = 0;
    listPenjualan.forEach((element) {
      if (int.parse(element.point) > 0) {
        totalPenjualan++;
      }
    });
    return totalPenjualan.toString();
  }

  String totalPengeluaran(List<Penjualan> listPenjualan) {
    int totalPengeluaran = 0;
    listPenjualan.forEach((element) {
      if (int.parse(element.point) < 0) {
        totalPengeluaran += int.parse(element.point);
      }
    });
    return oCcy.format(totalPengeluaran);
  }

  String totalBersih(List<Penjualan> listPenjualan) {
    int pemasukan = 0;
    int pengeluaran = 0;

    listPenjualan.forEach((element) {
      if (int.parse(element.point) > 0) {
        pemasukan += int.parse(element.point);
      }
    });

    listPenjualan.forEach((element) {
      if (int.parse(element.point) < 0) {
        pengeluaran += int.parse(element.point);
      }
    });

    int total = pemasukan + pengeluaran;

    return oCcy.format(total);
  }

  Future<void> onRefresh(PenjualanController penjualanController) async {
    await penjualanController.fetchPenjualan(id);
    return;
  }

  showCreatePenjualan(BuildContext buildContext, PenjualanController penjualanController) {
    TextEditingController detail = TextEditingController();
    TextEditingController point = TextEditingController();
    bool isLoading = false;

    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      context: buildContext,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            decoration: BoxDecoration(color: kWhiteColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
            padding: EdgeInsets.all(20),
            child: isLoading
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Tambah Penjualan', style: TextStyle(color: kDarkColor, fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      TextField(
                        textInputAction: TextInputAction.next,
                        controller: detail,
                        decoration: InputDecoration(
                          isDense: true,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.25),
                          hintText: 'Masukkan Informasi Penjualan',
                          hintStyle: TextStyle(fontSize: 16),
                          labelText: 'Informasi Penjualan',
                          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        controller: point,
                        decoration: InputDecoration(
                          isDense: true,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.25),
                          hintText: 'Masukkan Point Penjualan',
                          hintStyle: TextStyle(fontSize: 16),
                          labelText: 'Point Penjualan',
                          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 5),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: RaisedButton(
                          color: kDarkBlueColor,
                          onPressed: () async {
                            if (detail.text.isEmpty || point.text.isEmpty) {
                              return Get.showSnackbar(GetBar(
                                margin: EdgeInsets.all(10),
                                snackPosition: SnackPosition.TOP,
                                duration: Duration(seconds: 3),
                                message: 'field masih ada yang kosong!',
                              ));
                            }
                            setState(() {
                              isLoading = true;
                            });
                            Map<String, dynamic> status = await penjualanController.createPenjualan(id, detail.text, point.text);
                            if (status['code'] == 200) {
                              penjualanController.fetchPenjualan(id);
                              Get.back();
                            }
                            Get.showSnackbar(GetBar(
                              margin: EdgeInsets.all(10),
                              snackPosition: SnackPosition.TOP,
                              duration: Duration(seconds: 3),
                              message: status['message'],
                            ));
                            setState(() {
                              isLoading = true;
                            });
                          },
                          child: Text('Simpan', style: TextStyle(color: kWhiteColor)),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom))
                    ],
                  ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PenjualanController penjualanController = Get.put(PenjualanController()..fetchPenjualan(id));
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCreatePenjualan(context, penjualanController);
        },
        child: Icon(Icons.add),
      ),
      backgroundColor: kLightColor,
      body: RefreshIndicator(
        backgroundColor: kWhiteColor,
        onRefresh: () => onRefresh(penjualanController),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: kDarkColor,
              elevation: 0,
              textTheme: GoogleFonts.poppinsTextTheme(),
              toolbarHeight: 80,
              centerTitle: true,
              title: Text('Detail Penjualan', style: TextStyle(color: kWhiteColor, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${DateFormat('dd MMMM y').format(tanggal)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kDarkColor)),
                    SizedBox(height: 10),
                    GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      childAspectRatio: 1.3,
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: kLightBlueColor,
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(colors: [Color(0xFF2980B9), Color(0xFF3498DB)]),
                          ),
                          margin: EdgeInsets.only(right: 5),
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total\nPenjualan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kWhiteColor)),
                              Obx(() => Text('${penjualanController.penjualanStatus.value == PenjualanStatus.success ? totalPenjualan(penjualanController.listPenjualan) : '-'}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kWhiteColor))),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(color: kLightBlueColor, borderRadius: BorderRadius.circular(5), gradient: LinearGradient(colors: [Color(0xFFCA2C68), Color(0xFFEA4C88)])),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total\nPengeluaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kWhiteColor)),
                              Obx(() => Text('Rp ${penjualanController.penjualanStatus.value == PenjualanStatus.success ? totalPengeluaran(penjualanController.listPenjualan) : '-'}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kWhiteColor))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(color: kLightBlueColor, borderRadius: BorderRadius.circular(5), gradient: LinearGradient(colors: [Color(0xFF8E44AD), Color(0xFF9B59B6)])),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Pemasukan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kWhiteColor)),
                          Obx(() => Text('Rp ${penjualanController.penjualanStatus.value == PenjualanStatus.success ? totalPemasukan(penjualanController.listPenjualan) : '-'}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kWhiteColor))),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(color: kLightBlueColor, borderRadius: BorderRadius.circular(5), gradient: LinearGradient(colors: [Color(0xFF27AE60), Color(0xFF2ECC71)])),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Bersih', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kWhiteColor)),
                          Obx(() => Text('Rp ${penjualanController.penjualanStatus.value == PenjualanStatus.success ? totalBersih(penjualanController.listPenjualan) : '-'}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kWhiteColor))),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Daftar Penjualan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kDarkColor)),
                    SizedBox(height: 10),
                    Obx(() {
                      if (penjualanController.penjualanStatus.value == PenjualanStatus.success) {
                        if (penjualanController.listPenjualan.isNotEmpty) {
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: penjualanController.listPenjualan.length,
                            itemBuilder: (context, index) {
                              return BoxPenjualanWidget(id, penjualanController.listPenjualan[index], index, penjualanController.listPenjualan.length, penjualanController);
                            },
                          );
                        } else {
                          return Container(
                            decoration: BoxDecoration(color: kDarkColor, borderRadius: BorderRadius.circular(5)),
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            alignment: Alignment.center,
                            child: Text('Tidak Ada Data', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kWhiteColor)),
                          );
                        }
                      } else if (penjualanController.penjualanStatus.value == PenjualanStatus.failure) {
                        return Padding(
                          padding: EdgeInsets.all(20),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.cloud_off_rounded),
                                Text('Terjadi Kesalahan'),
                                RaisedButton(
                                  shape: StadiumBorder(),
                                  onPressed: () {
                                    penjualanController.fetchPenjualan(id);
                                  },
                                  child: Text('Refresh'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BoxPenjualanWidget extends StatelessWidget {
  final String id;
  final Penjualan penjualan;
  final int index;
  final int totalPenjualan;
  final PenjualanController penjualanController;
  BoxPenjualanWidget(this.id, this.penjualan, this.index, this.totalPenjualan, this.penjualanController);

  final oCcy = new NumberFormat("#,###,###", "id_ID");

  showDialogDelete(BuildContext buildContext) {
    bool isLoading = false;
    return showDialog(
      context: buildContext,
      child: StatefulBuilder(
        builder: (context, setState) {
          return isLoading
              ? SimpleDialog(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ],
                )
              : AlertDialog(
                  title: Text('Informasi'),
                  content: Text('Apakah kamu ingin menghapus data ke ${totalPenjualan - index}?'),
                  actions: [
                    FlatButton(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.green,
                      onPressed: () {
                        Get.back();
                      },
                      child: Text('Batal'),
                    ),
                    FlatButton(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.red,
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        Map<String, dynamic> status = await penjualanController.deletePenjualan(penjualan.id);
                        if (status['code'] == 200) {
                          penjualanController.fetchPenjualan(id);
                          Get.back();
                        }
                        Get.showSnackbar(GetBar(
                          margin: EdgeInsets.all(10),
                          snackPosition: SnackPosition.TOP,
                          duration: Duration(seconds: 3),
                          message: status['message'],
                        ));
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: Text('Hapus'),
                    ),
                  ],
                );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => showDialogDelete(context),
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: kLightBlueColor,
          borderRadius: BorderRadius.circular(5),
          gradient: int.parse(penjualan.point) < 0 ? LinearGradient(colors: [Color(0xFFC0392B), Color(0xFFE74C3C)]) : LinearGradient(colors: [Color(0xFF2980B9), Color(0xFF3498DB)]),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 4, offset: Offset(2, 2))],
        ),
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Penyatat : ${penjualan.penyatat}', style: TextStyle(color: kWhiteColor, fontSize: 16)),
              ],
            ),
            SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.25),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${totalPenjualan - index}. ${penjualan.detail}', style: TextStyle(color: kWhiteColor, fontSize: 16)),
                  Text('Rp ${oCcy.format(int.parse(penjualan.point))}', style: TextStyle(color: kWhiteColor, fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
