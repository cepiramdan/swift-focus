import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percobaan2/constants/color.dart';
import 'package:percobaan2/inner_scr/profil.dart';
import 'package:percobaan2/inner_scr/upload_tugas.dart';
import 'package:percobaan2/screen/all_wokers.dart';
import 'package:percobaan2/screen/tugas_scr.dart';

import '../user_state.dart';

class DrawerWidget extends StatefulWidget {
  DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.cyan),
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Image.network(
                      "https://upload.wikimedia.org/wikipedia/commons/9/9e/People_P_icon_blue.png"),
                ),
                SizedBox(height: 20),
                Flexible(
                  child: Text(
                    "Tugas Mahasiswa",
                    style: TextStyle(
                        color: Constants.orange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          _lisTites(
              label: "Semua Tugas",
              fct: () {
                _navigateKeLayarTugas(context);
              },
              icon: Icons.file_copy_outlined),
          _lisTites(
              label: "Akun Saya",
              fct: () {
                _navigateProfilScreen(context);
              },
              icon: Icons.person_2_outlined),
          _lisTites(
              label: "Semua Mahasiswa",
              fct: () {
                _navigatePekerja(context);
              },
              icon: Icons.work_history_outlined),
          _lisTites(
              label: "Tambahkan Tugas",
              fct: () {
                _navigateMenambahkanTugas(context);
              },
              icon: Icons.task_alt_outlined),
          Divider(thickness: 2),
          _lisTites(
              label: "Keluar",
              fct: () {
                _loguot(context);
              },
              icon: Icons.logout),
        ],
      ),
    );
  }

  void _navigateProfilScreen(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final String uid = user!.uid;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilScreen(
          userID: uid,
        ),
      ),
    );
  }

  void _navigatePekerja(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AllWorkersScreen(),
      ),
    );
  }

  void _navigateKeLayarTugas(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TasksScreen(),
      ),
    );
  }

  void _navigateMenambahkanTugas(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadTugas(),
      ),
    );
  }

  void _loguot(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWmtGjmydxcKj3x8z_6TbmWIsHD-Tx6FvEHKzahyTTGa2XIj9qT1sPSyEQj2Wm16ZBApk&usqp=CAU",
                  height: 20,
                  width: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Keluar"),
              ),
            ],
          ),
          content: Text(
            "Apakah Kamu Yakin Ingin Keluar",
            style: TextStyle(
                color: Constants.black,
                fontSize: 20,
                fontStyle: FontStyle.italic),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                _auth.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserState(),
                  ),
                );
              },
              child: Text(
                "Oke",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _lisTites(
      {required String label, required Function fct, required IconData icon}) {
    return ListTile(
      onTap: () {
        fct();
      },
      leading: Icon(
        icon,
        color: Constants.black,
      ),
      title: Text(
        label,
        style: TextStyle(
            color: Constants.black, fontSize: 20, fontStyle: FontStyle.normal),
      ),
    );
  }
}
