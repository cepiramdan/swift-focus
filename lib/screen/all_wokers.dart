import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:percobaan2/widgets/all_workers_widget.dart';
import 'package:percobaan2/widgets/drawer_widget.dart';

class AllWorkersScreen extends StatefulWidget {
  const AllWorkersScreen({super.key});

  @override
  State<AllWorkersScreen> createState() => _AllWorkersScreenState();
}

class _AllWorkersScreenState extends State<AllWorkersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: DrawerWidget(),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            "Semua Mahasiswa",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext, int Index) {
                      return AllWokersWidget(
                        userID: snapshot.data!.docs[Index]["id"],
                        userName: snapshot.data!.docs[Index]["name"],
                        userEmail: snapshot.data!.docs[Index]["email"],
                        phoneNumber: snapshot.data!.docs[Index]["phoneNumber"],
                        clas: snapshot.data!.docs[Index]["clas"],
                        userImageUrl: snapshot.data!.docs[Index]["userImage"],
                      );
                    });
              } else {
                return Center(
                  child: Text("there is no users"),
                );
              }
            }
            return Center(
              child: Text(
                "something went wrong",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            );
          },
        ));
  }
}
