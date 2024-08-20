import 'dart:io';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:absensi_mobile_apps/home.dart';
import 'package:permission_handler/permission_handler.dart' as permision;
import 'package:absensi_mobile_apps/qr_scanner_out.dart';

const bgColor = Color(0xfffafafa);
int counter = 0;
int isExist = 0;

class ResultOut extends StatefulWidget {
  const ResultOut({
    super.key,
    required this.closeScreen,
    required this.code,
  });

  final String code;
  final Function() closeScreen;

  @override
  State<ResultOut> createState() => _ResultOutState();
}

class _ResultOutState extends State<ResultOut> {
  @override
  void initState() {
    super.initState();
    readFile();
  }

  final TextEditingController nikC = TextEditingController();
  final TextEditingController ticketC = TextEditingController();

  Future<void> writeToAssetFile() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String formattedTime = DateFormat('HH:mm:ss').format(now);
    final text = nikC.text;
    final ticket = ticketC.text;
    var path = "/storage/emulated/0/Download/absen_out_$formattedDate.txt";
    var file = File(path);
    if (await file.exists()) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          return const Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation(Colors.blue),
          ));
        },
      );
      bool isExist = await isNIKAlreadyExist(text);
      if (isExist) {
        await ArtSweetAlert.show(
            barrierDismissible: true,
            context: context,
            artDialogArgs: ArtDialogArgs(
                title: "Data dengan NIK $text sudah ada",
                type: ArtSweetAlertType.info));
        Navigator.of(context).pop();
        print('NIK $text already exists in the file.');
      } else if (text.isEmpty || ticket.isEmpty) {
        await ArtSweetAlert.show(
            barrierDismissible: true,
            context: context,
            artDialogArgs: ArtDialogArgs(
                title: "NIK atau Ticket tidak boleh kosong!",
                type: ArtSweetAlertType.info));
        Navigator.of(context).pop();
      } else {
        final lines = await file.readAsLines();
        lines
            .add('NIK:$text|Ticket:$ticket|Date:$formattedDate $formattedTime');
        await file.writeAsString(lines.join('\n'));

        await ArtSweetAlert.show(
            barrierDismissible: true,
            context: context,
            artDialogArgs: ArtDialogArgs(
                title: "Succes , Data Tersimpan..",
                type: ArtSweetAlertType.info));
        nikC.clear();
        ticketC.clear();
        Navigator.of(context).pop();
        Get.offAll(const HomeScreen());
        // Get.to(() => const FirstScreen());
      }
    } else {
      await file.create();
      final lines = await file.readAsLines();
      lines.add('NIK:$text|Ticket:$ticket|Date:$formattedDate $formattedTime');
      await file.writeAsString(lines.join('\n'));

      await ArtSweetAlert.show(
          barrierDismissible: true,
          context: context,
          artDialogArgs: ArtDialogArgs(
              title: "Succes , Data Tersimpan..",
              type: ArtSweetAlertType.info));
      nikC.clear();
      ticketC.clear();
      Navigator.of(context).pop();
      Get.offAll(const HomeScreen());
    }
  }

  Future<bool> isNIKAlreadyExist(String nik) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    var path = "/storage/emulated/0/Download/absen_out_$formattedDate.txt";
    var file = File(path);
    final contents = await file.readAsLines();
    for (String line in contents) {
      final ticketInfo = line.split('|');
      if (ticketInfo[0] == 'NIK:$nik') {
        return true; // NIK already exists
      }
    }
    return false; // NIK does not exist
  }

  Future<List<Object>> readFile() async {
    var storagePermission =
        await permision.Permission.manageExternalStorage.request();
    print(storagePermission);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final filePath =
        '/storage/emulated/0/Download/absen_out_$formattedDate.txt';
    final file = File(filePath);
    final lines = await file.readAsLines();
    // ignore: unnecessary_null_comparison
    List<Object> myList = lines == null ? [] : lines.toList();
    List<Object> stringList = myList.map((innerList) => innerList).toList();

    if (await file.exists()) {
      final lines = await file.readAsLines();
      final count = lines.length;
      // ignore: unused_local_variable
      for (var data in lines) {
        final fields = data.split('|');
        final nikField = fields[0];
        final nik = nikField.split(':')[1];
        final ticketField = fields[1];
        final ticket = ticketField.split(':')[1];
        print(nik);
        print(ticket);
      }
      setState(() {
        counter = count;
      });
    } else {
      print('File not found');
    }
    return stringList;
  }

  @override
  Widget build(BuildContext context) {
    nikC.text = widget.code;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Absensi-OUT",
          style: TextStyle(
            color: Colors.white,
            // fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Please Input Manual NIK",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "Please klik button Scan Barcode for Scanning",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Total Input/Scan : $counter ",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            )),
            const SizedBox(
              height: 20,
            ),
            TextField(
              autocorrect: false,
              controller: nikC,
              keyboardType: TextInputType.number,
              readOnly: false,
              // maxLength: 20,
              decoration: InputDecoration(
                labelText: "NIK",
                hintText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              autocorrect: false,
              controller: ticketC,
              keyboardType: TextInputType.number,
              readOnly: false,
              // maxLength: 20,
              decoration: InputDecoration(
                labelText: "Jumlah Ticket",
                hintText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () async {
                  writeToAssetFile();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () async {
                  Get.to(const ScannerOut());
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code_scanner, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      "Scan Barcode",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: Container(
              alignment: Alignment.center,
              child: const Text(
                "",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
