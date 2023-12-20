import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percobaan2/user_state.dart';
import 'package:percobaan2/widgets/drawer_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilScreen extends StatefulWidget {
  final String userID;
  const ProfilScreen({required this.userID});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var _titletextStyle = TextStyle(
    fontSize: 22,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );
  var contenttextStyle = TextStyle(
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  bool _isLoading = false;
  String phoneNumber = "";
  String email = "";
  String? name;
  String clas = '';
  String imageUrl = "";
  String joinedAt = "";
  bool _isSameUser = false;

  Future<void> getUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userID)
          .get();

      if (userDoc.exists) {
        setState(() {
          email = userDoc.get("email");
          name = userDoc.get("name");
          clas = userDoc.get("clas");
          phoneNumber = userDoc.get("phoneNumber");
          imageUrl = userDoc.get("userImage");
          Timestamp joinedAtimeStamp = userDoc.get("createdAt");
          var joinedDate = joinedAtimeStamp.toDate();
          joinedAt = "${joinedDate.year}.${joinedDate.month}.${joinedDate.day}";
        });

        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userID;
        });
      }
    } catch (error) {
      print("Error: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 0),
                child: Stack(
                  children: [
                    Card(
                      margin: EdgeInsets.all(30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 80,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                name == null ? "nama" : name!,
                                style: _titletextStyle,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "$clas since join $joinedAt",
                                style: contenttextStyle,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Contact Info",
                              style: _titletextStyle,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child:
                                  userInfo(title: "Email : ", content: email),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: userInfo(
                                  title: "Phone : ", content: phoneNumber),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _isSameUser
                                ? Container()
                                : Divider(
                                    thickness: 2,
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            _isSameUser
                                ? Container()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _contactBy(
                                        color: Colors.green,
                                        function: _openWhatsAppChat,
                                        icon: Icons.message_outlined,
                                      ),
                                      _contactBy(
                                        color: Colors.red,
                                        function: _mailTo,
                                        icon: Icons.mail_outline,
                                      ),
                                      _contactBy(
                                        color: Colors.purple,
                                        function: _callPhoneNumber,
                                        icon: Icons.call_outlined,
                                      ),
                                    ],
                                  ),
                            SizedBox(
                              height: 25,
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            !_isSameUser
                                ? Container()
                                : Center(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 50),
                                      child: MaterialButton(
                                        onPressed: () {
                                          _auth.signOut();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => UserState(),
                                            ),
                                          );
                                        },
                                        color: Colors.red,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(13),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.logout,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                "Logout",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                              SizedBox(
                                                width: 10,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: size.width * 0.26,
                          height: size.width * 0.26,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 8,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            image: DecorationImage(
                              image: NetworkImage(
                                imageUrl == null
                                    ? "https://assets-a1.kompasiana.com/items/album/2021/03/24/blank-profile-picture-973460-1280-605aadc08ede4874e1153a12.png?t=o&v=780"
                                    : imageUrl,
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _openWhatsAppChat() async {
    var url = "http://wa.me/$phoneNumber?text=Haii";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Error launching WhatsApp");
      throw "Error launching WhatsApp";
    }
  }

  void _mailTo() async {
    var mailUrl = "mailto:$email";
    if (await canLaunch(mailUrl)) {
      await launch(mailUrl);
    } else {
      print("Error launching email");
      throw "Error launching email";
    }
  }

  void _callPhoneNumber() async {
    var url = "tel://$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Error launching phone call");
      throw "Error launching phone call";
    }
  }

  Widget _contactBy({
    required Color color,
    required Function function,
    required IconData icon,
  }) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: color,
      child: CircleAvatar(
        radius: 23,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(
            icon,
            color: color,
          ),
          onPressed: () {
            function();
          },
        ),
      ),
    );
  }

  Widget userInfo({required String title, required String content}) {
    return Row(
      children: [
        Text(
          title,
          style: contenttextStyle,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            content,
            style: contenttextStyle,
          ),
        ),
      ],
    );
  }
}
