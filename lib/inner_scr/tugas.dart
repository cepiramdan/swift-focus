import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percobaan2/constants/color.dart';
import 'package:percobaan2/services/global_method.dart';
import 'package:percobaan2/widgets/comments_widget.dart';
import 'package:uuid/uuid.dart';

class TugasScreen extends StatefulWidget {
  const TugasScreen({
    required this.uploadedBy,
    required this.tugasID,
  });
  final String uploadedBy;
  final String tugasID;

  @override
  State<TugasScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<TugasScreen> {
  var _textstyle = TextStyle(
    color: Constants.black,
    fontSize: 15,
    fontWeight: FontWeight.normal,
  );
  var _titleStyle = TextStyle(
      color: Constants.black, fontWeight: FontWeight.bold, fontSize: 20);
  TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;

  String? namaPenulis;
  String? clasPenulis;
  String? userImageUrl;
  String? judulTugas;
  String? matakuliah;
  String? deskripsiTugas;
  bool? _isDone;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadlineDateTimeStamp;
  String? postedDate;
  String? deadlineDate;
  bool isDeadlineAvaileble = false;

  @override
  void initState() {
    super.initState();
    getDataTugas();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void getDataTugas() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uploadedBy)
        .get();

    if (userDoc == null) {
      return;
    } else {
      setState(() {
        namaPenulis = userDoc.get("name");
        clasPenulis = userDoc.get("clas");
        userImageUrl = userDoc.get("userImage");
      });
    }
    final DocumentSnapshot databaseTugas = await FirebaseFirestore.instance
        .collection("tugas")
        .doc(widget.tugasID)
        .get();
    if (databaseTugas == null) {
      return;
    } else {
      setState(() {
        judulTugas = databaseTugas.get("judulTugas");
        deskripsiTugas = databaseTugas.get("deskripsiTugas");
        _isDone = databaseTugas.get("isDone");
        postedDateTimeStamp = databaseTugas.get("createdAt");
        deadlineDateTimeStamp = databaseTugas.get("deadlineDateTimeStamp");
        deadlineDate = databaseTugas.get("deadlineDate");
        var postDate = postedDateTimeStamp!.toDate();
        postedDate = "${postDate.year}.${postDate.month}.${postDate.day}";
      });
      var date = deadlineDateTimeStamp!.toDate();
      isDeadlineAvaileble = date.isAfter(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Kembali",
            style: TextStyle(
              color: Constants.black,
              fontStyle: FontStyle.italic,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Text(
              judulTugas == null ? "" : judulTugas!,
              style: TextStyle(
                color: Constants.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Upload By",
                        style: TextStyle(
                            color: Constants.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Spacer(),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: Constants.orange,
                          ),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                userImageUrl == null
                                    ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTEfIcRhJbK0TqLpLpPd-kr56aTSlqsMwNJDwdEkWxX2Q&s"
                                    : userImageUrl!,
                              ),
                              fit: BoxFit.fill),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            namaPenulis == null ? "" : namaPenulis!,
                            style: _textstyle,
                          ),
                          Text(
                            clasPenulis == null ? "" : clasPenulis!,
                            style: _textstyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                  dividerWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Upload on",
                        style: _titleStyle,
                      ),
                      Text(
                        postedDate == null ? "" : postedDate!,
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.normal,
                            fontSize: 15),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Deadline Date",
                        style: _titleStyle,
                      ),
                      Text(
                        deadlineDate == null ? "" : deadlineDate!,
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.normal,
                            fontSize: 15),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      isDeadlineAvaileble
                          ? "Batas waktunya belum selesai"
                          : "Batas waktu telah berlalu",
                      style: TextStyle(
                          color:
                              isDeadlineAvaileble ? Colors.green : Colors.red,
                          fontWeight: FontWeight.normal,
                          fontSize: 15),
                    ),
                  ),
                  dividerWidget(),
                  Text(
                    "Keadaan",
                    style: _titleStyle,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          User? user = _auth.currentUser;
                          final _uid = user!.uid;
                          if (_uid == widget.uploadedBy) {
                            try {
                              FirebaseFirestore.instance
                                  .collection("tugas")
                                  .doc(widget.tugasID)
                                  .update({"isDone": true});
                            } catch (eror) {
                              GlobalMethod.showErrorDialog(
                                  error: "Tindakan tidak dapat dilakukan",
                                  ctx: context);
                            }
                          } else {
                            GlobalMethod.showErrorDialog(
                                error:
                                    " Anda tidak dapat melakukan tindakan ini",
                                ctx: context);
                          }

                          getDataTugas();
                        },
                        child: Text(
                          "Selesai",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline,
                            color: Constants.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: _isDone == true ? 1 : 0,
                        child: Icon(
                          Icons.check_box,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      TextButton(
                        onPressed: () {
                          User? user = _auth.currentUser;
                          final _uid = user!.uid;
                          if (_uid == widget.uploadedBy) {
                            try {
                              FirebaseFirestore.instance
                                  .collection("tugas")
                                  .doc(widget.tugasID)
                                  .update({"isDone": false});
                            } catch (eror) {
                              GlobalMethod.showErrorDialog(
                                  error: "Tindakan tidak dapat dilakukan",
                                  ctx: context);
                            }
                          }
                          getDataTugas();
                        },
                        child: Text(
                          "Belum Selesai",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline,
                            color: Constants.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: _isDone == false ? 1 : 0,
                        child: Icon(
                          Icons.check_box,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  dividerWidget(),
                  Text(
                    "Deskripsi Tugas",
                    style: _titleStyle,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    deskripsiTugas == null ? "" : deskripsiTugas!,
                    style: _textstyle,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AnimatedSwitcher(
                    duration: Duration(
                      milliseconds: 500,
                    ),
                    child: _isCommenting
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 3,
                                child: TextField(
                                  controller: _commentController,
                                  style: TextStyle(color: Colors.black),
                                  maxLength: 200,
                                  keyboardType: TextInputType.text,
                                  maxLines: 6,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: MaterialButton(
                                        onPressed: () async {
                                          if (_commentController.text.length <
                                              20) {
                                            GlobalMethod.showErrorDialog(
                                                error:
                                                    "Comentar kurang dari 20 huruf",
                                                ctx: context);
                                          } else {
                                            final _generatedId = Uuid().v4();
                                            await FirebaseFirestore.instance
                                                .collection("tugas")
                                                .doc(widget.tugasID)
                                                .update(
                                              {
                                                "comments":
                                                    FieldValue.arrayUnion([
                                                  {
                                                    "userId": widget.uploadedBy,
                                                    "commentsId": _generatedId,
                                                    "name": namaPenulis,
                                                    "userImageUrl":
                                                        userImageUrl,
                                                    "commentsBody":
                                                        _commentController.text,
                                                    "time": Timestamp.now(),
                                                  }
                                                ]),
                                              },
                                            );
                                            await Fluttertoast.showToast(
                                                msg:
                                                    "Comentar anda telah terkirim",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.green,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                            _commentController.clear();
                                          }
                                          setState(() {});
                                        },
                                        color: Colors.red,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          "Tambah",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(
                                          () {
                                            _isCommenting = !_isCommenting;
                                          },
                                        );
                                      },
                                      child: Text("Batal"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: MaterialButton(
                              onPressed: () {
                                setState(
                                  () {
                                    _isCommenting = !_isCommenting;
                                  },
                                );
                              },
                              color: Colors.red,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                child: Text(
                                  "Tambahkan Comment",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("tugas")
                          .doc(widget.tugasID)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          if (snapshot.data == null) {
                            Center(
                              child: Text(
                                  "Tidak dapat berkomentar pada tugas ini"),
                            );
                          }
                        }
                        return ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return CommentWidget(
                                commentId: snapshot.data!["comments"][index]
                                    ["commentsId"],
                                pengomentarId: snapshot.data!["comments"][index]
                                    ["userId"],
                                commentarBody: snapshot.data!["comments"][index]
                                    ["commentsBody"],
                                gambarPengomentar: snapshot.data!["comments"]
                                    [index]["userImageUrl"],
                                namaPengomentar: snapshot.data!["comments"]
                                    [index]["name"],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
                                thickness: 2,
                              );
                            },
                            itemCount: snapshot.data!["comments"].length);
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dividerWidget() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 2,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
