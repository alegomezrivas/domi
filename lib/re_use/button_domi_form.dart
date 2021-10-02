import 'package:domi/re_use/theme.dart';
import 'package:flutter/material.dart';

class ButtonDomiForm extends StatelessWidget {
  final String? text;
  final VoidCallback? voidCallback;
  final double? elevate;
  final bool valid;

  ButtonDomiForm(
      {this.text, this.voidCallback, this.elevate = 2, this.valid = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: voidCallback,
        style: ElevatedButton.styleFrom(
          elevation: elevate,
          primary: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(9)),
        ),
        child: Row(
          children: [
            Text(
              text!,
              style: TextStyle(color: inDomiGreyBlack, fontSize: 15),
            ),
            Spacer(),
            if (!valid)
              Icon(
                Icons.arrow_forward_ios_outlined,
                color: inDomiGreyBlack,
                size: 18,
              ),
            if (valid)
              Icon(
                Icons.check_circle_outline,
                color: inDomiBluePrimary,
                size: 23,
              )
          ],
        ),
      ),
    );
  }
}
