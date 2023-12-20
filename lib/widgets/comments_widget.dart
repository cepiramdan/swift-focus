import 'package:flutter/material.dart';
import 'package:percobaan2/inner_scr/profil.dart';

class CommentWidget extends StatefulWidget {
  final String commentId;
  final String pengomentarId;
  final String namaPengomentar;
  final String commentarBody;
  final String gambarPengomentar;

  const CommentWidget({
    required this.commentId,
    required this.pengomentarId,
    required this.namaPengomentar,
    required this.commentarBody,
    required this.gambarPengomentar,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  List<Color> _Colors = [
    Colors.blue,
    Colors.black12,
    Colors.grey,
    Colors.brown,
    Colors.orangeAccent,
  ];

  @override
  Widget build(BuildContext context) {
    _Colors.shuffle();
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilScreen(
              userID: widget.pengomentarId,
            ),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 5,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: _Colors[0],
                ),
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(widget.gambarPengomentar),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.namaPengomentar,
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  widget.commentarBody,
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
