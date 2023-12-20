import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percobaan2/constants/color.dart';
import 'package:percobaan2/services/global_method.dart';
import 'package:percobaan2/widgets/drawer_widget.dart';
import 'package:uuid/uuid.dart';

class UploadTugas extends StatefulWidget {
  const UploadTugas({super.key});

  @override
  State<UploadTugas> createState() => _UploadTugasState();
}

class _UploadTugasState extends State<UploadTugas> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _matakuliahController =
      TextEditingController(text: "Pilih Matakuliah");
  TextEditingController _judulTugasController = TextEditingController();
  TextEditingController _descritionController = TextEditingController();
  TextEditingController _deadlineController =
      TextEditingController(text: "Masukan Deadline");
  final _formKey = GlobalKey<FormState>();
  DateTime? picked;
  Timestamp? deadlineDateTimeStamp;
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _matakuliahController.dispose();
    _judulTugasController.dispose();
    _descritionController.dispose();
    _deadlineController.dispose();
  }

  void _uploadTugas() async {
    final TugasID = Uuid().v4();
    User? user = _auth.currentUser;
    final _uid = user!.uid;

    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      if (_deadlineController.text == "Masukan Deadline" ||
          _matakuliahController.text == "Pilih Matakuliah") {
        GlobalMethod.showErrorDialog(
            error: "Silakan isi semua elemen", ctx: context);
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseFirestore.instance.collection("tugas").doc(TugasID).set({
          "tugasid": TugasID,
          "uploadedBy": _uid,
          "judulTugas": _judulTugasController.text,
          "deskripsiTugas": _descritionController.text,
          "deadlineDate": _deadlineController.text,
          "deadlineDateTimeStamp": deadlineDateTimeStamp,
          "matakuliahTugas": _matakuliahController.text,
          "comments": [],
          "isDone": false,
          "createdAt": Timestamp.now(),
        });

        Fluttertoast.showToast(
            msg: "Tugas Telah Diunggah",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);

        _resetForm();
      } catch (error) {
        print("Error: $error");

        GlobalMethod.showErrorDialog(
            error: "Terjadi kesalahan saat mengunggah tugas", ctx: context);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print("Gagal");
    }
  }

  void _resetForm() {
    _judulTugasController.clear();
    _descritionController.clear();
    setState(() {
      _matakuliahController.text = "Pilih Matakuliah";
      _deadlineController.text = "Masukan Deadline";
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      drawer: DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(7),
        child: Card(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Form Tugas",
                      style: TextStyle(
                        color: Constants.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _texTiles(label: "Matakuliah"),
                        _textFormFileds(
                            valueKey: "Matakuliah",
                            controller: _matakuliahController,
                            enabled: false,
                            fct: () {
                              _showmatakuliahDialog(size: size);
                            },
                            maxLength: 100),
                        //judul tugas
                        _texTiles(label: "Judul Tugas"),
                        _textFormFileds(
                            valueKey: "JudulTugas",
                            controller: _judulTugasController,
                            enabled: true,
                            fct: () {},
                            maxLength: 100),
                        //description
                        _texTiles(label: "Description Tugas"),
                        _textFormFileds(
                            valueKey: "DescriptionTugas",
                            controller: _descritionController,
                            enabled: true,
                            fct: () {},
                            maxLength: 1000),
                        //Deadline Tugas
                        _texTiles(label: "Deadline Tugas"),
                        _textFormFileds(
                            valueKey: "DeadlineTugas",
                            controller: _deadlineController,
                            enabled: false,
                            fct: () {
                              _pickDateDialog();
                            },
                            maxLength: 100),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : MaterialButton(
                            onPressed: _uploadTugas,
                            color: Colors.red,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Upload Tugas",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.upload_file,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textFormFileds(
      {required String valueKey,
      required TextEditingController controller,
      required bool enabled,
      required Function fct,
      required int maxLength}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return "Value is missing";
            }
            return null;
          },
          controller: controller,
          enabled: enabled,
          key: ValueKey(valueKey),
          style: TextStyle(
            color: Constants.black,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
          maxLines: valueKey == "Description Tugas" ? 3 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Constants.black),
            ),
            errorBorder:
                UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          ),
        ),
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
                fontSize: 20,
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
                      setState(
                        () {
                          _matakuliahController.text =
                              Constants.matakuliahList[index];
                        },
                      );
                      Navigator.pop(context);
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
                                fontSize: 18,
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
                child: Text("Tutup"),
              ),
            ],
          );
        });
  }

  void _pickDateDialog() async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        Duration(days: 0),
      ),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _deadlineController.text =
            '${picked!.year}-${picked!.month}-${picked!.day}';
        deadlineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            picked!.microsecondsSinceEpoch);
      });
    }
  }

  Widget _texTiles({required String label}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        label,
        style: TextStyle(
          color: Constants.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
