import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart' as permision;
import 'package:absensi_mobile_apps/home.dart';

class AllPresensiView extends StatefulWidget {
  const AllPresensiView({super.key});

  @override
  State<AllPresensiView> createState() => _AllPresensiState();
}

class _AllPresensiState extends State<AllPresensiView> {
  List<String> items = [];

  @override
  void initState() {
    super.initState();
    readFile();
  }

  String nikC = '';
  String ticketC = '';

  Future<String> combineFiles(String filePath1, String filePath2) async {
    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);

      final filePathIn =
          '/storage/emulated/0/Download/absen_in_$formattedDate.txt';
      final filePathOut =
          '/storage/emulated/0/Download/absen_out_$formattedDate.txt';
      final file1 = File(filePathIn);
      final file2 = File(filePathOut);

      if (await file1.exists() && await file2.exists()) {
        final contents1 = await file1.readAsString();
        final contents2 = await file2.readAsString();
        return '$contents1\n$contents2';
      } else {
        throw Exception('One or both files do not exist');
      }
    } catch (e) {
      throw Exception('Error combining files: $e');
    }
  }

  Future<void> readFile() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    final filePath = '/storage/emulated/0/Download/absen_in_$formattedDate.txt';
    // final file = File(filePath);

    final filePathOut =
        '/storage/emulated/0/Download/absen_in_$formattedDate.txt';
    // final fileOut = File(filePath);

    final combinedContent = await combineFiles(filePath, filePathOut);
    print(combinedContent);

    // final lines = await file.readAsLines();
    // // ignore: unnecessary_null_comparison
    // List<Object> myList = lines == null ? [] : lines.toList();
    // List<Object> stringList = myList.map((innerList) => innerList).toList();
    // print(stringList);

    // if (await file.exists()) {
    //   final lines = await file.readAsLines();
    //   // print(lines);
    //   // final count = lines.length;
    //   // ignore: unused_local_variable
    //   for (var data in lines) {
    //     final fields = data.split('|');
    //     final nikField = fields[0];
    //     final nik = nikField.split(':')[1];
    //     final ticketField = fields[1];
    //     final ticket = ticketField.split(':')[1];
    //     final dateField = fields[2];
    //     final date = dateField.split(':')[1];
    //     nikC = nik;
    //     print(nik);
    //     print(ticket);
    //     print(date);
    //   }
    //   setState(() {
    //     // counter = count;
    //     items = nikC as List<String>;
    //     print(items);
    //   });
    // } else {
    //   print('File not found');
    // }
    // Navigator.of(context).pop();
    // return stringList;
  }

  Future<void> cekFile() async {
    var storagePermission =
        await permision.Permission.manageExternalStorage.request();
    print(storagePermission);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    var path = "/storage/emulated/0/Download/absen_in_$formattedDate.txt";
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
      try {
        final contents = await file.readAsString();
        final lines = contents.split('\n');
        print(lines);
        setState(() {
          items = lines;
        });
      } catch (e) {
        print('Error reading file: $e');
      }
    } else {
      await file.create();
    }
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Data'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: items.length,
        itemBuilder: (context, index) {
          // return ListTile(
          //   title: Text(items[index]),
          // );
          // final item = items[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Material(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () => Get.to(const HomeScreen()),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  // margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    // color: Colors.blue[50],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "NIK ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text('cek 1'),
                        ],
                      ),
                      Text('masuk'),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Keluar",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text('cek'),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
