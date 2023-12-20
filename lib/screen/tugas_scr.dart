import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percobaan2/constants/color.dart';
import 'package:percobaan2/widgets/drawer_widget.dart';
import 'package:percobaan2/widgets/tugas_widget.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 1,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Tugas",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showmatakuliahDialog(size: size);
            },
            icon: Icon(Icons.filter_list_outlined, color: Colors.black),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("tugas").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext, int Index) {
                    return TaskWidget(
                      judulTugas: snapshot.data!.docs[Index]["judulTugas"],
                      descriptionTugas: snapshot.data!.docs[Index]
                          ["deskripsiTugas"],
                      tugasid: snapshot.data!.docs[Index]["tugasid"],
                      uploadedBy: snapshot.data!.docs[Index]["uploadedBy"],
                      isDone: snapshot.data!.docs[Index]["isDone"],
                    );
                  });
            } else {
              return Center(
                child: Text("Tidak ada tugas tersedia"),
              );
            }
          }
          return Center(
            child: Text(
              "Terjadi kesalahan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          );
        },
      ),
    );
  }

  _showmatakuliahDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              "MataKuliah",
              style: TextStyle(
                fontSize: 25,
                color: Constants.black,
              ),
              textAlign: TextAlign.center,
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Constants.matakuliahList.length,
                itemBuilder: (ctxx, index) {
                  return InkWell(
                    onTap: () {
                      print(
                          "matakuliahList[index],${Constants.matakuliahList[index]}");
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.red,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Constants.matakuliahList[index],
                            style: TextStyle(
                                color: Constants.black,
                                fontSize: 20,
                                fontStyle: FontStyle.italic),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Text(
                  "Tutup",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text("Batal"),
              ),
            ],
          );
        });
  }
}
