import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percobaan2/constants/color.dart';
import 'package:percobaan2/services/global_method.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late TextEditingController _fullNameTextController =
      TextEditingController(text: "");
  late TextEditingController _emailTextController =
      TextEditingController(text: "");
  late TextEditingController _passTextController =
      TextEditingController(text: "");
  late TextEditingController _postitionCPTextController =
      TextEditingController(text: "");
  late TextEditingController _phoneNumbeController =
      TextEditingController(text: "");

  FocusNode _emailFocusNode = FocusNode();

  FocusNode _passFocusNode = FocusNode();

  FocusNode _potitionCPFocusNode = FocusNode();

  FocusNode _phoneNumberFocusNode = FocusNode();

  bool _obscureText = true;
  final _signUpFormKey = GlobalKey<FormState>();

  File? imageFile;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? imageUrl;

  @override
  void dispose() {
    _animationController.dispose();
    _fullNameTextController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();

    _postitionCPTextController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _potitionCPFocusNode.dispose();
    _phoneNumbeController.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 20));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
    super.initState();
  }

  void _submitFormOnSignUp() async {
    final isValid = _signUpFormKey.currentState!.validate();
    if (isValid) {
      if (imageFile == null) {
        GlobalMethod.showErrorDialog(
            error: "Silakan Pilih Gambar", ctx: context);
        return;
      }

      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.createUserWithEmailAndPassword(
            email: _emailTextController.text.trim().toLowerCase(),
            password: _passTextController.text.trim());

        //menyimpan data regis user
        final User? user = _auth.currentUser;
        final _uid = user!.uid;
        final ref = FirebaseStorage.instance
            .ref()
            .child("userImage")
            .child(_uid + ".jpg");
        await ref.putFile(imageFile!);
        imageUrl = await ref.getDownloadURL();
        FirebaseFirestore.instance.collection("users").doc(_uid).set({
          "id": _uid,
          "name": _fullNameTextController.text,
          "email": _emailTextController.text,
          "userImage": imageUrl,
          "phoneNumber": _phoneNumbeController.text,
          "clas": _postitionCPTextController.text,
          "createdAt": Timestamp.now(),
        });

        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (errorr) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: errorr.toString(), ctx: context);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl:
                "https://cdn.pixabay.com/photo/2015/09/09/19/29/bookshelves-932780_1280.jpg",
            placeholder: (context, url) => Image.asset(
              "assets/walpaper.jpg",
              fit: BoxFit.fill,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                Text(
                  "SignUp",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28),
                ),
                SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already have an account',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      TextSpan(text: " "),
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.canPop(context)
                              ? Navigator.pop(context)
                              : null,
                        text: 'Login',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Form(
                  key: _signUpFormKey,
                  child: Column(
                    children: [
                      //nama lengkap
                      Row(
                        children: [
                          Flexible(
                            flex: 2,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_emailFocusNode),
                              keyboardType: TextInputType.name,
                              controller: _fullNameTextController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "form Ini Tidak Ada";
                                } else {
                                  return null;
                                }
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Nama Lengkap",
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: size.width * 0.20,
                                  height: size.width * 0.20,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.white),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: imageFile == null
                                        ? Image.network(
                                            "https://static.vecteezy.com/system/resources/thumbnails/002/318/271/small/user-profile-icon-free-vector.jpg",
                                            fit: BoxFit.fill,
                                          )
                                        : Image.file(
                                            imageFile!,
                                            fit: BoxFit.fill,
                                          ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    _showImageDialog();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 2, color: Colors.white),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        imageFile == null
                                            ? Icons.add_a_photo
                                            : Icons.edit_outlined,
                                        color: Colors.black,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      //email
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_passFocusNode),
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailTextController,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains("@")) {
                            return "Silakan Masukkan Alamat Email Yang Valid";
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      //pass
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_phoneNumberFocusNode),
                        focusNode: _passFocusNode,
                        obscureText: _obscureText,
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passTextController,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 6) {
                            return "Silakan Masukkan Password Yang Benar";
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white),
                          ),
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        focusNode: _phoneNumberFocusNode,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_potitionCPFocusNode),
                        keyboardType: TextInputType.phone,
                        controller: _phoneNumbeController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "form Ini Tidak Ada";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (v) {
                          // print("Phone Number ${_phoneNumbeController.text}");
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Phone Number",
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //posisi dicompany
                      GestureDetector(
                        onTap: () {
                          _showmatakuliahDialog(size: size);
                        },
                        child: TextFormField(
                          enabled: false,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () => _submitFormOnSignUp(),
                          focusNode: _potitionCPFocusNode,
                          keyboardType: TextInputType.name,
                          controller: _postitionCPTextController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "form Ini Tidak Ada";
                            } else {
                              return null;
                            }
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Pilih Kelas",
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                _isLoading
                    ? Center(
                        child: Container(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : MaterialButton(
                        onPressed: _submitFormOnSignUp,
                        color: Colors.red,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "SignUp",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.person_add,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Please chose an option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  _getFromCamera();
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.camera,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "Camera",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  _getFromGallery();
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.image,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "Galery",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    setState(
      () {
        imageFile = File(pickedFile!.path);
      },
    );
    Navigator.pop(context);
  }

  void _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );

    setState(
      () {
        imageFile = File(pickedFile!.path);
      },
    );

    Navigator.pop(context);
  }

  void _showmatakuliahDialog({required Size size}) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            "Pilih Kelas",
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
              itemCount: Constants.kelas.length,
              itemBuilder: (ctxx, index) {
                return InkWell(
                  onTap: () {
                    setState(
                      () {
                        _postitionCPTextController.text =
                            Constants.kelas[index];
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
                          Constants.kelas[index],
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
      },
    );
  }
}
