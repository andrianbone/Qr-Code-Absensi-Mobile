import 'dart:async';
import 'dart:io';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:absensi_mobile_apps/qr_scanner.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gsheets/gsheets.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:permission_handler/permission_handler.dart' as permision;
import 'package:share_plus/share_plus.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

const bgColor = Color(0xfffafafa);
int counter = 0;
int isExist = 0;

const _credentials = r'''
{
  "type": "service_account",
  "project_id": "absensi-project-428303",
  "private_key_id": "e80a6b91f4ac20a7a220f5dcacc9b0745b0c43fa",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCoFuV5ALt8e9mh\npxZ9lD/UHcrNxDinFpFo94U7SidSeEzXLp3rXsgUoXRv6vQSNpubvlmMY3F3M2J6\n82obsap3AjxaTuixWl6KMiY1GyC/9mLXc/Eg8wI8JRx8UBO1vvtAGY8TUV+W/mdV\nLemn93fPyg/dZh9WrEVgiyLjbhrX+Me/yiEuj5Vsiow113oOFAWLn2T3LwqDKLzt\nC3VQDt+Uy0VyB5mngw6e+3N4AnzlJUtkTfL7PRjC5V737S+oEyOCe8wj8Er1K1v8\nnyn2eKAJ3sAa87Agaoyo9t4rbOOBc3nK93AK2zrGrMNH8OK231GwiUMjvPGphZAo\nX292ebuNAgMBAAECggEABytw2XmJRbz0/RLxio+QrcAhPCfRlc5Ii15mya8MSyrT\n9j1oDC0vDMg6kqKGNiJWVAKUHcDzyvaUuF4FHuN0EV71oDwrlehe+MyST3jAgRz7\nPX7rIFwVMpJlAGgcVcfXaODI4Z/6hegvPqrLw7fHyG5xQPY/7HRtLM91KxfGyoL2\n9FEwnOuiiV6NP7lHQXhSpPeMrHMi2tW56RW5U+TGGXLmgzfrUuZZS98IQV4wYmna\nDBVTqiRQofuJm6miD5c60lhUMfsfZ4kSfq3IhlkNuUQa7L7VEK0fyG/t34pi/R0J\nqCpJVlqrRfEMU76VH5WxpehwINZp00J9x6TlMZKrkQKBgQDRtD687zD4KKPelk3n\nRqmUljAju0rjeKmPDwQMrh6/u3pGtV/++E3K00dD0OnsaJas6tC22Mu5eRO3AGdT\n/N5qxiCNV1n5VRSlPzznIMyH7j/B4V7kAVU5iSN9sxbHS1b33vDTHJCZzi7KDfuT\naV89748Fi3p2S4J6j/C0RG7W0QKBgQDNMrwIpr0uP7QKLRmXC47o1sTA2zOnI5je\nCx54u2MzduZqoN3r8kQPRziDWW1fnMdbApQVe9FUNexXy2P4BbhMIdG4pX/2F+va\nMiDop+/XJkR5IRk+q4g2sPNVCnD4dSU8cuFc/RDK/rxcEuaR8uxLQZ1O2t8gkv/W\nWxEJ1XI//QKBgC+7/cP4FoeGiLa0NAt/ND7UaSTZD1T0NHSSEHPqdqliPZU22CEr\n2Flg+onfVkAwFoxJ7zSP6N/RRcGUX/DoUKCxdNt3lM2Cpm5vFKfv+V6/xteVO4pf\nG007gE6uo3K+HY/SubL0f53jJxdrU2bcx4dLrpyugTPIQG0xsrL2GNzhAoGBAJ/H\njKET7KVRl0iBO7bgmiP17/jX9s2Dq2nisJSEHUeaouqOXp914scexwOII+Fae+UD\nCfn8ktAGuQTX6/zZv1sQznP/8rbWg6FAfV2MPvaB5rmHK1ggSw2DFca3PaZJ2XfL\nYG5+44+dcWAkm4Mz7Ajhi7M2PJ3puOrZuFe266KlAoGAaVvSj+Gy0Vij+os4jvtE\nfUHYfv2DK6BIBDAWJLW9oKIsgxwQgDxYCrmqFTYnmyUyylF2Qg11VEfmWiwsL5MW\nQlBg4cQ05WXdUSimM3oet4Tuwno+1xToZ79G4dAgmTqJf+qJ44awtuH6eBgUVVZ2\neHeR4xdQt78B5CmAgHdCA+w=\n-----END PRIVATE KEY-----\n",
  "client_email": "absensi-project@absensi-project-428303.iam.gserviceaccount.com",
  "client_id": "105736064428045743472",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/absensi-project%40absensi-project-428303.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';

var credentials = auth.ServiceAccountCredentials.fromJson(r'''
    {
  "type": "service_account",
  "project_id": "absensi-project-428303",
  "private_key_id": "e80a6b91f4ac20a7a220f5dcacc9b0745b0c43fa",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCoFuV5ALt8e9mh\npxZ9lD/UHcrNxDinFpFo94U7SidSeEzXLp3rXsgUoXRv6vQSNpubvlmMY3F3M2J6\n82obsap3AjxaTuixWl6KMiY1GyC/9mLXc/Eg8wI8JRx8UBO1vvtAGY8TUV+W/mdV\nLemn93fPyg/dZh9WrEVgiyLjbhrX+Me/yiEuj5Vsiow113oOFAWLn2T3LwqDKLzt\nC3VQDt+Uy0VyB5mngw6e+3N4AnzlJUtkTfL7PRjC5V737S+oEyOCe8wj8Er1K1v8\nnyn2eKAJ3sAa87Agaoyo9t4rbOOBc3nK93AK2zrGrMNH8OK231GwiUMjvPGphZAo\nX292ebuNAgMBAAECggEABytw2XmJRbz0/RLxio+QrcAhPCfRlc5Ii15mya8MSyrT\n9j1oDC0vDMg6kqKGNiJWVAKUHcDzyvaUuF4FHuN0EV71oDwrlehe+MyST3jAgRz7\nPX7rIFwVMpJlAGgcVcfXaODI4Z/6hegvPqrLw7fHyG5xQPY/7HRtLM91KxfGyoL2\n9FEwnOuiiV6NP7lHQXhSpPeMrHMi2tW56RW5U+TGGXLmgzfrUuZZS98IQV4wYmna\nDBVTqiRQofuJm6miD5c60lhUMfsfZ4kSfq3IhlkNuUQa7L7VEK0fyG/t34pi/R0J\nqCpJVlqrRfEMU76VH5WxpehwINZp00J9x6TlMZKrkQKBgQDRtD687zD4KKPelk3n\nRqmUljAju0rjeKmPDwQMrh6/u3pGtV/++E3K00dD0OnsaJas6tC22Mu5eRO3AGdT\n/N5qxiCNV1n5VRSlPzznIMyH7j/B4V7kAVU5iSN9sxbHS1b33vDTHJCZzi7KDfuT\naV89748Fi3p2S4J6j/C0RG7W0QKBgQDNMrwIpr0uP7QKLRmXC47o1sTA2zOnI5je\nCx54u2MzduZqoN3r8kQPRziDWW1fnMdbApQVe9FUNexXy2P4BbhMIdG4pX/2F+va\nMiDop+/XJkR5IRk+q4g2sPNVCnD4dSU8cuFc/RDK/rxcEuaR8uxLQZ1O2t8gkv/W\nWxEJ1XI//QKBgC+7/cP4FoeGiLa0NAt/ND7UaSTZD1T0NHSSEHPqdqliPZU22CEr\n2Flg+onfVkAwFoxJ7zSP6N/RRcGUX/DoUKCxdNt3lM2Cpm5vFKfv+V6/xteVO4pf\nG007gE6uo3K+HY/SubL0f53jJxdrU2bcx4dLrpyugTPIQG0xsrL2GNzhAoGBAJ/H\njKET7KVRl0iBO7bgmiP17/jX9s2Dq2nisJSEHUeaouqOXp914scexwOII+Fae+UD\nCfn8ktAGuQTX6/zZv1sQznP/8rbWg6FAfV2MPvaB5rmHK1ggSw2DFca3PaZJ2XfL\nYG5+44+dcWAkm4Mz7Ajhi7M2PJ3puOrZuFe266KlAoGAaVvSj+Gy0Vij+os4jvtE\nfUHYfv2DK6BIBDAWJLW9oKIsgxwQgDxYCrmqFTYnmyUyylF2Qg11VEfmWiwsL5MW\nQlBg4cQ05WXdUSimM3oet4Tuwno+1xToZ79G4dAgmTqJf+qJ44awtuH6eBgUVVZ2\neHeR4xdQt78B5CmAgHdCA+w=\n-----END PRIVATE KEY-----\n",
  "client_email": "absensi-project@absensi-project-428303.iam.gserviceaccount.com",
  "client_id": "105736064428045743472",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/absensi-project%40absensi-project-428303.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
    }
  ''');

const String _spreadsheetId = '1AIE81DbmuJbPUxyZG5XNITf2S1KEPoy9ZCgWMSwebxI';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final _formKey = GlobalKey<FormState>();
  List<String> items = [];
  List<String> lastFiveLines = [];
  String dateFormated = '';
  FocusNode focusNode = FocusNode();
  // String _scanBarcodeResult = '';

  @override
  void initState() {
    super.initState();
    cekFile();
    _readLastFiveLines();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          readFile();
          _readLastFiveLines();
        });
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  final TextEditingController nikC = TextEditingController();
  final TextEditingController ticketC = TextEditingController();
  final TextEditingController locationC = TextEditingController();
  LatLng myCurrentLocation = const LatLng(-6.1948088, 106.7644942);
  // LatLng myCurrentLocation = const LatLng(28.578382, 81.63359);
  late GoogleMapController googleMapController;
  Set<Marker> markers = {};

  String strLatLong = 'Belum Mendapatkan Lat dan Long';
  String strAlamat = 'Mencari lokasi...';
  bool loading = false;

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      debugPrint(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      nikC.text = barcodeScanRes;
    });
  }

  // Function to determine the user's current position
  Future<Position> currentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Checking if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    // Checking the location permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Requesting permission if it is denied
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    // Handling the case where permission is permanently denied
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    // Getting the current position of the user
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // location service not enabled, don't continue
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location service Not Enabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions denied forever , we cannot access..');
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> getAddressFromLongLat(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    setState(() {
      // strAlamat = '${place.street}, ${place.subLocality}, ${place.locality}, '
      //     '${place.postalCode}, ${place.country}';
      strAlamat = '${place.street}, ${place.subLocality}';
      locationC.text = strAlamat;
    });
  }

  Future<void> _readLastFiveLines() async {
    var storagePermission =
        await permision.Permission.manageExternalStorage.request();
    print(storagePermission);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    var path = "/storage/emulated/0/Download/absen_in_$formattedDate.txt";
    var file = File(path);

    try {
      if (await file.exists()) {
        final contents = await file.readAsString();
        final lines = contents.split('\n');
        setState(() {
          // lastFiveLines =
          //     lines.length > 5 ? lines.sublist(lines.length - 5) : lines;
          // items = lastFiveLines;
          lastFiveLines = lines.length > 5
              ? lines.sublist(lines.length - 5).reversed.toList()
              : lines.reversed.toList();
          items = lastFiveLines;
        });
      } else {
        await file.create();
      }
    } catch (e) {
      print('Error reading file: $e');
    }
  }

  Future<void> shareFile() async {
    var storagePermission =
        await permision.Permission.manageExternalStorage.request();
    print(storagePermission);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    var path = "/storage/emulated/0/Download/absen_in_$formattedDate.txt";
    var file = File(path);
    if (await file.exists()) {
      // ignore: deprecated_member_use
      await Share.shareFiles([path]);
    } else {
      await ArtSweetAlert.show(
          barrierDismissible: true,
          // ignore: use_build_context_synchronously
          context: context,
          artDialogArgs: ArtDialogArgs(
              title: "File not found", type: ArtSweetAlertType.info));
      print('File not found');
    }
  }

  Future<void> cekFile() async {
    var storagePermission =
        await permision.Permission.manageExternalStorage.request();
    print(storagePermission);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    // String formattedTime = DateFormat('HH:mm:ss').format(now);
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
      final lines = await file.readAsLines();
      final count = lines.length;
      // ignore: unused_local_variable
      for (var data in lines) {
        final fields = data.split('|');
        final nikField = fields[0];
        final nik = nikField.split(':')[1];
        // final ticketField = fields[1];
        // final ticket = ticketField.split(':')[1];
        // final dateField = fields[2];
        // final date = dateField.split(':')[1].trim();
        print(nik);
      }
      setState(() {
        counter = count;
        dateFormated = formattedDate;
        items = lines;
      });
      // Navigator.of(context).pop();
    } else {
      await file.create();
    }
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  Future<bool> isNIKAlreadyExist(String nik) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    // Open the file and read its contents
    var path = "/storage/emulated/0/Download/absen_in_$formattedDate.txt";
    var file = File(path);
    final contents = await file.readAsLines();
    // Check if the NIK already exists in the file
    for (String line in contents) {
      final ticketInfo = line.split('|');
      if (ticketInfo[0] == 'NIK:$nik') {
        return true; // NIK already exists
      }
    }
    return false; // NIK does not exist
  }

  Future<void> writeToAssetFile() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String formattedTime = DateFormat('HH:mm:ss').format(now);
    final text = nikC.text;
    final ticket = ticketC.text;
    final location = locationC.text;
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
      // List<Object> datas = await readFile();
      // final content = await file.readAsString();
      bool isExist = await isNIKAlreadyExist(text);
      if (isExist) {
        await ArtSweetAlert.show(
            barrierDismissible: true,
            // ignore: use_build_context_synchronously
            context: context,
            artDialogArgs: ArtDialogArgs(
                title: "Data dengan NIK $text sudah ada",
                type: ArtSweetAlertType.info));
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        print('NIK $text already exists in the file.');
      } else if (text.isEmpty || ticket.isEmpty || location.isEmpty) {
        await ArtSweetAlert.show(
            barrierDismissible: true,
            // ignore: use_build_context_synchronously
            context: context,
            artDialogArgs: ArtDialogArgs(
                title: "NIK, Ticket dan Location tidak boleh kosong!",
                type: ArtSweetAlertType.info));
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      } else {
        final lines = await file.readAsLines();
        lines.add(
            'NIK:$text|Ticket:$ticket|Date:$formattedDate $formattedTime|Location:$location');
        await file.writeAsString(lines.join('\n'));
        await ArtSweetAlert.show(
            barrierDismissible: true,
            // ignore: use_build_context_synchronously
            context: context,
            artDialogArgs: ArtDialogArgs(
                title: "Succes , Data Tersimpan..",
                type: ArtSweetAlertType.info));
        nikC.clear();
        ticketC.clear();
        Navigator.of(context).pop();
      }
    } else {
      await file.create();
      final lines = await file.readAsLines();
      lines.add(
          'NIK:$text|Ticket:$ticket|Date:$formattedDate $formattedTime|Location:$location');
      await file.writeAsString(lines.join('\n'));
      // await file.writeAsString(
      //     'NIK:${nikC.text}|Ticket:${ticketC.text}|Date:$formattedDate $formattedTime\n',
      //     mode: FileMode.append);
      await ArtSweetAlert.show(
          barrierDismissible: true,
          // ignore: use_build_context_synchronously
          context: context,
          artDialogArgs: ArtDialogArgs(
              title: "Succes , Data Tersimpan..",
              type: ArtSweetAlertType.info));
      nikC.clear();
      ticketC.clear();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }

  Future<List<Object>> readFile() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    final filePath = '/storage/emulated/0/Download/absen_in_$formattedDate.txt';
    final file = File(filePath);

    final lines = await file.readAsLines();
    // ignore: unnecessary_null_comparison
    List<Object> myList = lines == null ? [] : lines.toList();
    List<Object> stringList = myList.map((innerList) => innerList).toList();

    if (await file.exists()) {
      final lines = await file.readAsLines();
      final count = lines.length;
      // ignore: unused_local_variable
      // for (var data in lines) {
      //   final fields = data.split('|');
      //   final nikField = fields[0];
      //   final nik = nikField.split(':')[1];
      //   final ticketField = fields[1];
      //   final ticket = ticketField.split(':')[1];
      //   // print(nik);
      //   // print(ticket);
      // }
      setState(() {
        counter = count;
      });
    } else {
      print('File not found');
    }
    // Navigator.of(context).pop();
    return stringList;
  }

  Future<List<String>> getDataSheets() async {
    // var result = await (Connectivity().checkConnectivity());
    // // ignore: unrelated_type_equality_checks
    // if (result == ConnectivityResult.none) {
    //   print("No internet");
    //   // ignore: unrelated_type_equality_checks
    // } else if (result == ConnectivityResult.mobile ||result == ConnectivityResult.wifi) {
    //   print("You are connected over Mobile data Or Wifi");
    // }
    var client = await auth.clientViaServiceAccount(
        credentials, [sheets.SheetsApi.spreadsheetsScope]);
    var sheetsApi = sheets.SheetsApi(client);
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
    var range = 'absensi!A2:A6000';
    var response =
        await sheetsApi.spreadsheets.values.get(_spreadsheetId, range);
    var values = response.values;
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();

    List<List<Object?>>? myList = values == null ? [] : values.toList();

    List<String> stringList =
        myList.map((innerList) => innerList.join()).toList();

    if (values != null && values.isNotEmpty) {
      final rowCount = values.length;
      for (var row in stringList) {
        print(row);
      }
      setState(() {
        counter = rowCount;
      });
    } else {
      print('Tidak ada data yang ditemukan.');
    }
    client.close();
    return stringList;
  }

  void createNewSheet_() async {
    // Set up authentication
    var client = await auth.clientViaServiceAccount(
        credentials, [sheets.SheetsApi.spreadsheetsScope]);
    var sheetsApi = sheets.SheetsApi(client);

    // Set up the spreadsheet ID and new sheet name
    const spreadsheetId = 'absensi_mnc_2024_07_22';
    const newSheetName = 'absensi-mnc';

    // Create a new sheet
    final requestBody = sheets.BatchUpdateSpreadsheetRequest(
      requests: [
        sheets.Request(
          addSheet: sheets.AddSheetRequest(
            properties: sheets.SheetProperties(
              title: newSheetName,
            ),
          ),
        ),
      ],
    );

    try {
      // Batch update the spreadsheet
      final response = await sheetsApi.spreadsheets.batchUpdate(
        spreadsheetId as sheets.BatchUpdateSpreadsheetRequest,
        requestBody as String,
      );

      print(response);
      print('New sheet created: ${response.spreadsheetId}');
    } catch (e) {
      if (e is sheets.DetailedApiRequestError && e.status == 404) {
        print('Error: Spreadsheet not found');
      } else {
        print('Error: $e');
      }
    }
  }

  void createNewSheet() async {
    // Set up authentication
    var client = await auth.clientViaServiceAccount(
        credentials, [sheets.SheetsApi.spreadsheetsScope]);
    var sheetsApi = sheets.SheetsApi(client);

    // Set up the spreadsheet ID and new sheet name

    const newSheetName = 'absensi-mnc';

    // Create a new sheet request
    final request = sheets.BatchUpdateSpreadsheetRequest.fromJson({
      'requests': [
        {
          'addSheet': {
            'properties': {
              'title': newSheetName,
            },
          },
        },
      ],
    });

    // Make the batchUpdate request
    final response =
        await sheetsApi.spreadsheets.batchUpdate(request, _spreadsheetId);

    print(response);

    print('New sheet created with title: $newSheetName');

    // print('New sheet created: ${response.updates.spreadsheetId}');
  }

  Future<List<String>> readData() async {
    var client = await auth.clientViaServiceAccount(
        credentials, [sheets.SheetsApi.spreadsheetsScope]);
    var sheetsApi = sheets.SheetsApi(client);
    var range = 'absensi!A2:A6000';
    var response =
        await sheetsApi.spreadsheets.values.get(_spreadsheetId, range);
    var values = response.values;

    List<List<Object?>>? myList = values == null ? [] : values.toList();

    List<String> stringList =
        myList.map((innerList) => innerList.join()).toList();

    if (values != null && values.isNotEmpty) {
      final rowCount = values.length;
      for (var row in stringList) {
        print(row);
      }
      setState(() {
        counter = rowCount;
      });
    } else {
      print('Tidak ada data yang ditemukan.');
    }
    client.close();
    return stringList;
  }

  void readDatafromGSheet() async {
    final gsheets = GSheets(_credentials);
    final ss = await gsheets.spreadsheet(_spreadsheetId);
    var sheet = ss.worksheetByTitle('absensi');
    int rows = sheet!.rowCount;
    List<Cell> cellsRow;
    for (var i = 1; i < rows; i++) {
      cellsRow = await sheet.cells.row(i);
      print(cellsRow.elementAt(0).value);
    }
  }

  void submitForm() async {
    List<String> data = await readData();
    print(data);

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String formattedTime = DateFormat('HH:mm:ss').format(now);

    const String scriptURL =
        'https://script.google.com/macros/s/AKfycbynGQtSprZyqYSe6cCsG_BPA7ptO3u6lQwCJSFDiIb6NrVvFH4IUbqZKD8Sa5YMwzRR5g/exec';

    String tempNik = nikC.text;
    String tempTicket = ticketC.text;
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
    for (var row in data) {
      if (tempNik == row) {
        isExist = 1;
        print('ada duplicate data');
      }
    }
    if (isExist == 1) {
      print('ada duplicate data');
      await ArtSweetAlert.show(
          barrierDismissible: true,
          context: context,
          artDialogArgs: ArtDialogArgs(
              title: "Data dengan NIK $tempNik sudah ada",
              type: ArtSweetAlertType.info));
      Navigator.of(context).pop();
      isExist = 0;
    } else if (tempNik == '' ||
        tempNik.isEmpty ||
        tempTicket == '' ||
        tempTicket.isEmpty) {
      await ArtSweetAlert.show(
          barrierDismissible: true,
          context: context,
          artDialogArgs: ArtDialogArgs(
              title: "NIK atau Ticket tidak boleh kosong!",
              type: ArtSweetAlertType.info));
      Navigator.of(context).pop();
    } else {
      print('tidak ada duplicate data');
      String tempTgl = "$formattedDate $formattedTime";
      String queryString = "?nik=$tempNik&tanggal=$tempTgl&ticket=$tempTicket";
      var finalURI = Uri.parse(scriptURL + queryString);
      var response = await http.get(finalURI);

      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        // Check if the response body contains any error messages
        if (response.body.contains('error')) {
          await ArtSweetAlert.show(
              barrierDismissible: true,
              context: context,
              artDialogArgs: ArtDialogArgs(
                  title: "Error: ${response.body}",
                  type: ArtSweetAlertType.info));
        } else {
          print('Data inserted successfully!');
          await ArtSweetAlert.show(
              barrierDismissible: true,
              context: context,
              artDialogArgs: ArtDialogArgs(
                  title: "Succes , Data Berhasil Disimpan..",
                  type: ArtSweetAlertType.info));
          nikC.clear();
          ticketC.clear();
          Navigator.of(context).pop();
          readData();
        }
      } else {
        await ArtSweetAlert.show(
            barrierDismissible: true,
            context: context,
            artDialogArgs: ArtDialogArgs(
                title: "Error: ${response.statusCode}",
                type: ArtSweetAlertType.info));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Absensi-IN",
          style: TextStyle(
            color: Colors.white,
            // fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        key: _formKey,
        physics: const BouncingScrollPhysics(),
        // width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Please Input Manual NIK",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Input/Scan : $counter ",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Date : $dateFormated ",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              autocorrect: false,
              autofocus: false,
              focusNode: focusNode,
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
              height: 10,
            ),
            TextField(
              autocorrect: false,
              autofocus: false,
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
              height: 10,
            ),
            TextField(
              autocorrect: false,
              autofocus: false,
              controller: locationC,
              keyboardType: TextInputType.text,
              readOnly: false,
              // maxLength: 20,
              decoration: InputDecoration(
                labelText: "Location",
                hintText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Save
                  Container(
                    padding: const EdgeInsets.all(0),
                    alignment: Alignment.bottomRight,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        writeToAssetFile();
                        focusNode.requestFocus();
                        FocusScope.of(context).unfocus();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save, color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                              "Save",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Location
                  Container(
                    padding: const EdgeInsets.all(0),
                    alignment: Alignment.bottomRight,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });

                        Position position = await _getGeoLocationPosition();
                        setState(() {
                          loading = false;
                          strLatLong =
                              '${position.latitude}, ${position.longitude}';
                        });
                        getAddressFromLongLat(position);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on_outlined,
                                color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                              "Location",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Scan
                  Container(
                    padding: const EdgeInsets.all(0),
                    alignment: Alignment.bottomRight,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () async {
                        scanBarcodeNormal();
                        // Get.to(const QRScanner());
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.qr_code_scanner, color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                              "Scan",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.blue[50],
              thickness: 2,
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       const Text(
            //         "Last 5 Input",
            //         style:
            //             TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            //       ),
            //       TextButton(
            //         onPressed: () async {
            //           shareFile();
            //         },
            //         child: const Text("Share Data",
            //             style: TextStyle(
            //                 fontSize: 12, fontWeight: FontWeight.bold)),
            //       )
            //     ],
            //   ),
            // ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              width: double.infinity,
              height: 315, // or any other fixed height
              child: GoogleMap(
                myLocationButtonEnabled: false,
                markers: markers,
                // Setting the controller when the map is created
                onMapCreated: (GoogleMapController controller) {
                  googleMapController = controller;
                },
                // Initial camera position of the map
                initialCameraPosition: CameraPosition(
                  target: myCurrentLocation,
                  zoom: 14,
                ),
              ),
            ),

            // StreamBuilder<List<String>>(
            //     stream: Stream.fromIterable([items]),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData &&
            //           snapshot.data != null &&
            //           snapshot.data!.isNotEmpty) {
            //         return SizedBox(
            //           height: 330, // or any other fixed height
            //           child: ListView.builder(
            //             itemCount: snapshot.data?.length,
            //             itemBuilder: (context, index) {
            //               String item = items[index];
            //               List<String> parts = item.split("|");
            //               String nik = parts[0].split(":")[1];
            //               String ticket = parts[1].split(":")[1];
            //               String date =
            //                   parts[2].substring(parts[2].indexOf(":") + 1);
            //               DateTime parsedDate =
            //                   DateFormat('yyyy-MM-dd HH:mm:ss').parse(date);
            //               String extractedTime =
            //                   DateFormat('HH:mm:ss').format(parsedDate);
            //               String location = parts[3].split(":")[1];
            //               return Padding(
            //                 padding: const EdgeInsets.only(
            //                     bottom: 10, right: 3, left: 3),
            //                 child: Material(
            //                   color: Colors.blue[50],
            //                   borderRadius: BorderRadius.circular(20),
            //                   child: InkWell(
            //                     // onTap: () => Get.toNamed(Routes.DETAIL_PRESENSI,
            //                     //     arguments: data),
            //                     borderRadius: BorderRadius.circular(20),
            //                     child: Container(
            //                       // margin: const EdgeInsets.only(bottom: 20),
            //                       padding: const EdgeInsets.all(10),
            //                       decoration: BoxDecoration(
            //                         borderRadius: BorderRadius.circular(20),
            //                         // color: Colors.blue[50],
            //                       ),
            //                       child: Column(
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         children: [
            //                           Row(
            //                             mainAxisAlignment:
            //                                 MainAxisAlignment.spaceBetween,
            //                             children: [
            //                               Text(
            //                                 "NIK: $nik",
            //                                 style: const TextStyle(
            //                                     fontSize: 13,
            //                                     fontWeight: FontWeight.bold),
            //                               ),
            //                               Text('Jam: $extractedTime',
            //                                   style: const TextStyle(
            //                                     fontSize: 13,
            //                                   )),
            //                             ],
            //                           ),
            //                           Row(
            //                             mainAxisAlignment:
            //                                 MainAxisAlignment.spaceBetween,
            //                             children: [
            //                               Text(
            //                                 "Location: $location",
            //                                 style: const TextStyle(
            //                                     fontSize: 13,
            //                                     fontWeight: FontWeight.bold),
            //                               ),
            //                               Text('Ticket: $ticket',
            //                                   style: const TextStyle(
            //                                     fontSize: 13,
            //                                   )),
            //                             ],
            //                           ),
            //                           // Text('Location: $location',
            //                           //     style: const TextStyle(
            //                           //       fontSize: 13,
            //                           //     )),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               );
            //             },
            //           ),
            //         );
            //       } else if (snapshot.hasError) {
            //         print('hasError');
            //         return Text('Error: ${snapshot.error}');
            //       } else {
            //         print('No data');
            //         return Text('No data available');
            //       }
            //     }),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 100),
        // padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 175),
        child: FloatingActionButton.small(
          // elevation: 10,
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.my_location,
            size: 23,
          ),
          onPressed: () async {
            // Getting the current position of the user
            Position position = await currentPosition();
            // Animating the camera to the user's current position
            googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 14,
                ),
              ),
            );
            // Clearing existing markers
            markers.clear();
            // Adding a new marker at the user's current position
            markers.add(
              Marker(
                markerId: const MarkerId('currentLocation'),
                position: LatLng(position.latitude, position.longitude),
              ),
            );
            // Refreshing the state to update the UI with new markers
            setState(() async {
              // getAddressFromLongLat(position);
              List<Placemark> placemarks = await placemarkFromCoordinates(
                  position.latitude, position.longitude);
              print(placemarks);
              Placemark place = placemarks[0];

              // strAlamat =
              //     "${placemarks[0].name} , ${placemarks[0].subLocality}, ${placemarks[0].locality}";
              // strAlamat =
              //     '${place.name}, ${place.subLocality} , ${place.locality}';
              // print(strAlamat);
              strAlamat = '${place.name}, ${place.street}';
              // strAlamat = '${place.street}, ${place.subLocality}';
              locationC.text = strAlamat;
            });
          },
        ),
      ),
    );
  }
}
