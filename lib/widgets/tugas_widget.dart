import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percobaan2/inner_scr/tugas.dart';
import 'package:percobaan2/services/global_method.dart';

class TaskWidget extends StatefulWidget {
  final String judulTugas;
  final String descriptionTugas;
  final String tugasid;
  final String uploadedBy;
  final bool isDone;

  const TaskWidget({
    required this.judulTugas,
    required this.descriptionTugas,
    required this.tugasid,
    required this.uploadedBy,
    required this.isDone,
  });

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TugasScreen(
                tugasID: widget.tugasid,
                uploadedBy: widget.uploadedBy,
              ),
            ),
          );
        },
        onLongPress: _deleteDialog,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20,
            child: Image.network(widget.isDone
                ? "https://baak.stkipkusumanegara.ac.id/wp-content/uploads/2022/11/423-4236368_icon-ceklis-png-transparent-png.png"
                : "https://alfamart.co.id/frontend/img/corporate/gcg/organ/komisaris/img-persyaratan-2.png"),
          ),
        ),
        title: Text(
          widget.judulTugas,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.linear_scale_outlined,
              color: Colors.black,
            ),
            Text(
              widget.descriptionTugas,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.red,
        ),
      ),
    );
  }

  _deleteDialog() {
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  if (widget.uploadedBy == _uid) {
                    await FirebaseFirestore.instance
                        .collection("tugas")
                        .doc(widget.tugasid)
                        .delete();
                    await Fluttertoast.showToast(
                        msg: "Tugas Telah Dihapus",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    Navigator.canPop(ctx) ? Navigator.pop(ctx) : null;
                  } else {
                    //jika bukan pengguna akun maka tidak pada menghapus tugas
                    GlobalMethod.showErrorDialog(
                        error: "Anda tidak dapat menghapus tugas ini",
                        ctx: ctx);
                  }
                } catch (eror) {
                  GlobalMethod.showErrorDialog(
                      error: "Tugas ini tidak dapat dihapus", ctx: context);
                } finally {}
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  Text(
                    "Hapus",
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
