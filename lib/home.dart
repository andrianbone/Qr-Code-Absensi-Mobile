import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:absensi_mobile_apps/first_screen.dart';
import 'package:absensi_mobile_apps/second_screen.dart';
import 'package:absensi_mobile_apps/update_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HOME',
          style: TextStyle(
            color: Colors.white,
            // fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
      ),
      body: GridView.builder(
        itemCount: 3,
        // padding: const EdgeInsets.all(20),
        padding: const EdgeInsets.only(top: 235, left: 15, right: 15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          // crossAxisCount: 2,
          // mainAxisSpacing: 20,
          // crossAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          late String title;
          late IconData icon;
          late VoidCallback onTap;

          switch (index) {
            case 0:
              title = "Absen IN";
              icon = Icons.login_outlined;
              onTap = () {
                Get.to(const FirstScreen());
              };
              break;
            case 1:
              title = "Absen OUT";
              icon = Icons.logout_outlined;
              onTap = () {
                Get.to(const SecondScreen());
              };
              break;
            case 2:
              title = "Update Data";
              icon = Icons.update_sharp;
              onTap = () {
                Get.to(const UpdateScreen());
              };
              break;
            // case 3:
            //   title = "List Data";
            //   icon = Icons.document_scanner_outlined;
            //   onTap = () {
            //     Get.to(const AllPresensiView());
            //   };
            //   break;
          }

          return Material(
            color: Colors.blue[400],
            borderRadius: BorderRadius.circular(9),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(
                      icon,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     // Map<String, dynamic> hasil = await authC.logout();
      //     // if (hasil["error"] == false) {
      //     //   Get.offAllNamed(Routes.login);
      //     // } else {
      //     //   Get.snackbar("Error", hasil["error"]);
      //     // }
      //   },
      //   child: Icon(Icons.logout),
      // ),
    );
  }
}
