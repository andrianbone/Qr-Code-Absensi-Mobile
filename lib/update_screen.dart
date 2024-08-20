import 'dart:async';
import 'dart:io';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const bgColor = Color(0xfffafafa);
int counter = 0;
int isExist = 0;

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  final List<String> items = [
    'IN',
    'OUT',
  ];
  String? selectedValue;

  final TextEditingController nikC = TextEditingController();
  final TextEditingController ticketC = TextEditingController();

  Future<void> updateTicketOut() async {
    // Open the file and read its contents
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String formattedTime = DateFormat('HH:mm:ss').format(now);
    var path = "/storage/emulated/0/Download/absen_out_$formattedDate.txt";
    var file = File(path);

    final nikCtext = nikC.text;
    final ticket = ticketC.text;
    if (await file.exists()) {
      final contents = await file.readAsLines();
      for (int i = 0; i < contents.length; i++) {
        final ticketInfo = contents[i].split('|');
        if (ticketInfo[0] == 'NIK:$nikCtext') {
          isExist = 0;
          break;
        } else {
          isExist = 1;
        }
      }
      if (isExist == 1) {
        await ArtSweetAlert.show(
            barrierDismissible: true,
            // ignore: use_build_context_synchronously
            context: context,
            artDialogArgs: ArtDialogArgs(
                title: "NIK $nikCtext tidak ditemukan..",
                type: ArtSweetAlertType.info));
        print('NIK tidak ditemukan..');
        isExist = 0;
      } else {
        // contents.firstWhere((line) => line.contains('NIK:$nikCtext'));
        contents.removeWhere((line) => line.contains('NIK:$nikCtext'));
        contents.add(
            'NIK:$nikCtext|Ticket:$ticket|Date:$formattedDate $formattedTime');
        //  contents.insert(desiredIndex, newRow);
        // await file.writeAsString(
        //     'NIK:${nikC.text}|Ticket:${ticketC.text}|Date:$formattedDate $formattedTime\n',
        //     mode: FileMode.append);
        await file.writeAsString(contents.join('\n'));
        // await file.writeAsString(contents.join('\n'), mode: FileMode.append);
        await ArtSweetAlert.show(
            barrierDismissible: true,
            // ignore: use_build_context_synchronously
            context: context,
            artDialogArgs: ArtDialogArgs(
                title: "Ticket updated successfully..",
                type: ArtSweetAlertType.info));
        nikC.clear();
        ticketC.clear();
        print('Ticket updated successfully!');
      }
    } else {
      await ArtSweetAlert.show(
          barrierDismissible: true,
          // ignore: use_build_context_synchronously
          context: context,
          artDialogArgs: ArtDialogArgs(
              title: "Tidak Ditemukan File .txt",
              type: ArtSweetAlertType.info));
    }
  }

  void validation() async {
    final nikCtext = nikC.text;
    final ticket = ticketC.text;
    if (nikCtext.isEmpty &&
        ticket.isEmpty &&
        (selectedValue == null || selectedValue == '')) {
      await ArtSweetAlert.show(
          barrierDismissible: true,
          // ignore: use_build_context_synchronously
          context: context,
          artDialogArgs: ArtDialogArgs(
              title: "NIK , Ticket dan Absen harus diisi..",
              type: ArtSweetAlertType.info));
    } else if (nikCtext.isEmpty) {
      await ArtSweetAlert.show(
          barrierDismissible: true,
          // ignore: use_build_context_synchronously
          context: context,
          artDialogArgs: ArtDialogArgs(
              title: "NIK tidak boleh kosong..", type: ArtSweetAlertType.info));
    } else if (ticket.isEmpty) {
      await ArtSweetAlert.show(
          barrierDismissible: true,
          // ignore: use_build_context_synchronously
          context: context,
          artDialogArgs: ArtDialogArgs(
              title: "Ticket tidak boleh kosong..",
              type: ArtSweetAlertType.info));
    } else if (selectedValue == null || selectedValue == '') {
      await ArtSweetAlert.show(
          barrierDismissible: true,
          // ignore: use_build_context_synchronously
          context: context,
          artDialogArgs: ArtDialogArgs(
              title: "Silahkan pilih Absen terlebih dahulu..",
              type: ArtSweetAlertType.info));
    }
    if (selectedValue == 'IN') {
      updateTicketIN();
    }
    if (selectedValue == 'OUT') {
      updateTicketOut();
    }
  }

  Future<void> updateTicketIN() async {
    // Open the file and read its contents
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    var path = "/storage/emulated/0/Download/absen_in_$formattedDate.txt";
    var file = File(path);

    final nikCtext = nikC.text;
    final ticket = ticketC.text;
    if (await file.exists()) {
      final contents = await file.readAsLines();
      for (int i = 0; i < contents.length; i++) {
        final ticketInfo = contents[i].split('|');
        if (ticketInfo[0] == 'NIK:$nikCtext') {
          // Update the ticket information
          ticketInfo[1] = 'Ticket:$ticket'; // Update the ticket number
          // ticketInfo[2] = 'Jam:15:00:00'; // Update the jam
          // ticketInfo[3] = 'Tanggal:2024-07-18'; // Update the tanggal
          contents[i] = ticketInfo.join('|');
          isExist = 0;
          break;
        } else {
          isExist = 1;
        }
      }
      if (isExist == 1) {
        await ArtSweetAlert.show(
            barrierDismissible: true,
            // ignore: use_build_context_synchronously
            context: context,
            artDialogArgs: ArtDialogArgs(
                title: "NIK $nikCtext tidak ditemukan..",
                type: ArtSweetAlertType.info));
        print('NIK tidak ditemukan..');
        isExist = 0;
      } else {
        await file.writeAsString(contents.join('\n'));
        await ArtSweetAlert.show(
            barrierDismissible: true,
            // ignore: use_build_context_synchronously
            context: context,
            artDialogArgs: ArtDialogArgs(
                title: "Ticket updated successfully..",
                type: ArtSweetAlertType.info));
        nikC.clear();
        ticketC.clear();
        print('Ticket updated successfully!');
      }
    } else {
      await ArtSweetAlert.show(
          barrierDismissible: true,
          // ignore: use_build_context_synchronously
          context: context,
          artDialogArgs: ArtDialogArgs(
              title: "Tidak Ditemukan File .txt",
              type: ArtSweetAlertType.info));
    }

    // Write the updated contents back to the file
    // Get.offAll(() => const HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Update Data",
          style: TextStyle(
            color: Colors.white,
            // fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Container(
        key: _formKey,
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(
              height: 25,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: DropdownButtonFormField(
                value: selectedValue, // Currently selected value
                hint: const Text('Select Absen'), // Placeholder text
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: items
                    .map((String item) => DropdownMenuItem<String>(
                        value: item, child: Text(item)))
                    .toList(), // List of dropdown options
                icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                style: const TextStyle(color: Colors.black),
                onChanged: (String? newValue) {
                  // Handles dropdown selection change
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
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
                  validation();
                  // updateTicket();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.update_outlined, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      "Update",
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
