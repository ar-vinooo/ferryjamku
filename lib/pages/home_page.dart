import 'package:ferryjamku/controllers/auth_controller.dart';
import 'package:ferryjamku/controllers/tanggal_controller.dart';
import 'package:ferryjamku/models/tanggal_model.dart';
import 'package:ferryjamku/pages/detail_page.dart';
import 'package:ferryjamku/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  final TanggalController tanggalController = Get.put(TanggalController()..fetchTanggal());
  final AuthController authController = Get.find();
  final DateTime dateNow = DateTime.now();
  final oCcy = new NumberFormat("#,###,###", "id_ID");

  Future<void> onRefresh() async {
    await tanggalController.fetchTanggal();
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightColor,
      body: RefreshIndicator(
        backgroundColor: kWhiteColor,
        onRefresh: () => onRefresh(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: kDarkColor,
              elevation: 0,
              textTheme: GoogleFonts.poppinsTextTheme(),
              toolbarHeight: 80,
              centerTitle: true,
              title: Text('Ferry Jamku', style: TextStyle(color: kWhiteColor, fontSize: 20, fontWeight: FontWeight.bold)),
              actions: [
                FlatButton(
                  color: Colors.black.withOpacity(0.1),
                  onPressed: () {
                    Get.dialog(AlertDialog(
                      title: Text('Informasi'),
                      content: Text('Apakah kamu ingin keluar dari username ${authController.username}'),
                      actions: [
                        FlatButton(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          onPressed: () {
                            Get.back();
                          },
                          child: Text('Batal'),
                        ),
                        FlatButton(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.green,
                          onPressed: () {
                            Get.back();
                            authController.logout();
                          },
                          child: Text('Ya'),
                        ),
                      ],
                    ));
                  },
                  child: Text('Logout', style: TextStyle(color: kWhiteColor, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.black.withOpacity(0.1),
                padding: EdgeInsets.all(20),
                child: Text('Username : ${authController.username}', style: TextStyle(color: kDarkColor, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Penjualan Hari Ini', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kDarkColor)),
                              Text('${DateFormat('dd MMMM y').format(dateNow)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kDarkColor)),
                            ],
                          ),
                        ),
                        Obx((){
                          if(tanggalController.tanggalStatus.value == TanggalStatus.success){
                            if(tanggalController.nowTanggal.value != null){
                              return IconButton(icon: Icon(Icons.arrow_forward_ios_outlined),onPressed: (){
                                Get.to(DetailPage(tanggalController.nowTanggal.value.id, tanggalController.nowTanggal.value.tanggal));
                              },);
                            }
                          }
                          return SizedBox();
                        }),
                      ],
                    ),
                    SizedBox(height: 10),
                    Obx(() {
                      if (tanggalController.tanggalStatus.value == TanggalStatus.success) {
                        if (tanggalController.nowTanggal.value != null) {
                          return Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: kLightBlueColor,
                                  borderRadius: BorderRadius.circular(5),
                                  gradient: LinearGradient(colors: [Color(0xFF8E44AD), Color(0xFF9B59B6)]),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 4, offset: Offset(2, 2))],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Total Penjualan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kWhiteColor)),
                                    Obx(() => Text('${tanggalController.nowTanggal.value.totalPenjualan}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kWhiteColor))),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: kLightBlueColor,
                                  borderRadius: BorderRadius.circular(5),
                                  gradient: LinearGradient(colors: [Color(0xFF27AE60), Color(0xFF2ECC71)]),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 4, offset: Offset(2, 2))],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Total Bersih', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kWhiteColor)),
                                    Obx(() => Text('Rp ${tanggalController.nowTanggal.value.totalPoint != null ? oCcy.format(int.parse(tanggalController.nowTanggal.value.totalPoint)) : '0'}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kWhiteColor))),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: kLightBlueColor,
                              borderRadius: BorderRadius.circular(5),
                              gradient: LinearGradient(colors: [Color(0xFFC0392B), Color(0xFFE74C3C)]),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 4, offset: Offset(2, 2))],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Data Hari Ini Belum Dibuat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kWhiteColor)),
                                SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: RaisedButton(
                                    shape: StadiumBorder(),
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    onPressed: () async {
                                      Map<String, dynamic> status = await tanggalController.createTanggal();
                                      if (status['code'] == 200 || status['code'] == 403) {
                                        tanggalController.fetchTanggal();
                                      }
                                      Get.showSnackbar(GetBar(
                                        margin: EdgeInsets.all(10),
                                        snackPosition: SnackPosition.BOTTOM,
                                        duration: Duration(seconds: 3),
                                        message: status['message'],
                                      ));
                                    },
                                    child: Text('Buat'),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      } else if (tanggalController.tanggalStatus.value == TanggalStatus.failure) {}
                      return Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }),
                    SizedBox(height: 20),
                    Text('Daftar Hari', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kDarkColor)),
                    SizedBox(height: 10),
                    Obx(() {
                      if (tanggalController.tanggalStatus.value == TanggalStatus.success) {
                        if (tanggalController.listTanggal.isNotEmpty) {
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: tanggalController.listTanggal.length,
                            itemBuilder: (context, index) {
                              return BoxHariWidget(tanggalController.listTanggal[index]);
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
                      } else if (tanggalController.tanggalStatus.value == TanggalStatus.failure) {
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
                                    tanggalController.fetchTanggal();
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

class BoxHariWidget extends StatelessWidget {
  final Tanggal tanggal;
  BoxHariWidget(this.tanggal);

  final oCcy = new NumberFormat("#,###,###", "id_ID");
  final DateTime dateNow = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: kLightBlueColor,
        borderRadius: BorderRadius.circular(5),
        gradient: tanggal.tanggal.day == dateNow.day && tanggal.tanggal.month == dateNow.month ? LinearGradient(colors: [Color(0xFF2C3E50), Color(0xFF34495E)]) : LinearGradient(colors: [Color(0xFF2980B9), Color(0xFF3498DB)]),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 4, offset: Offset(2, 2))],
      ),
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.25),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${DateFormat('dd MMMM yyyy').format(tanggal.tanggal)}', style: TextStyle(color: kWhiteColor, fontSize: 18)),
                  Text('Total Bersih : Rp ${tanggal.totalPoint != null ? oCcy.format(int.parse(tanggal.totalPoint)) : '0'}', style: TextStyle(color: kWhiteColor, fontSize: 16)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 10),
                shape: StadiumBorder(),
                onPressed: () {
                  Get.to(DetailPage(tanggal.id, tanggal.tanggal));
                },
                child: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
