import 'package:domi/re_use/theme.dart';
import 'package:flutter/material.dart';

class DomiSliverAppBar extends StatelessWidget {
  final String? text;
  DomiSliverAppBar(this.text);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(
          Icons.arrow_back,
          color: inDomiBluePrimary,
          size: 24,
        ),
      ),
      forceElevated: true,
      expandedHeight: 100,
      floating: true,
      pinned: true,
      elevation: 5,
      backgroundColor: inDomiYellow,
      flexibleSpace: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            decoration: BoxDecoration(
            ),
            child: Image.asset(
              "assets/icons/Grupo 224@2x.png",
              fit: BoxFit.cover,
            ),
            width: double.maxFinite,
            height: double.maxFinite,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              text!,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: inDomiBluePrimary),
            ),
          )
        ],
      ),
    );
  }
}
