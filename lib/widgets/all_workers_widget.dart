import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../inner_scr/profil.dart';

class AllWokersWidget extends StatefulWidget {
  final String userID;
  final String userName;
  final String userEmail;
  final String clas;
  final String phoneNumber;
  final String userImageUrl;

  const AllWokersWidget({
    required this.userID,
    required this.userName,
    required this.userEmail,
    required this.clas,
    required this.phoneNumber,
    required this.userImageUrl,
  });

  @override
  State<AllWokersWidget> createState() => _AllWokersWidgetState();
}

class _AllWokersWidgetState extends State<AllWokersWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilScreen(
                userID: widget.userID,
              ),
            ),
          );
        },
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
            child: Image.network(widget.userImageUrl == null
                ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIn8p3HlaqV4pp3rN1PCF9DE4IXpp7IK2Pga6YwowRrMk_K5gYu_i4CQllj347sH8mKAE&usqp=CAU"
                : widget.userImageUrl),
          ),
        ),
        title: Text(
          widget.userName,
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
              "${widget.clas}/${widget.phoneNumber}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.email_outlined,
            size: 30,
            color: Colors.red,
          ),
          onPressed: _mailTo,
        ),
      ),
    );
  }

  void _mailTo() async {
    var mailUrl = "mailto:${widget.userEmail}";
    print("widget.userEmail ${widget.userEmail}");
    if (await canLaunch(mailUrl)) {
      await launch(mailUrl);
    } else {
      print("eror ");
      throw "eror";
    }
  }
}
