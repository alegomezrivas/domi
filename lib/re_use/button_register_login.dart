import 'package:domi/re_use/theme.dart';
import 'package:flutter/material.dart';

class ButtonRegisterLogin extends StatefulWidget {
  final Color color;
  final double radius;
  final double width;
  final double height;
  final Text? text;
  final VoidCallback? voidCallback;
  final ButtonRegisterController? controller;

  ButtonRegisterLogin(
      {this.color = inDomiBluePrimary,
      this.radius = 19,
      this.width = 273,
      this.height = 38,
      this.text,
      this.voidCallback,
      this.controller});

  @override
  _ButtonRegisterLoginState createState() => _ButtonRegisterLoginState();
}

class _ButtonRegisterLoginState extends State<ButtonRegisterLogin> {
  @override
  void initState() {
    if (widget.controller != null) {
      widget.controller!.addListener(() {
        setState(() {});
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.radius)),
            primary: widget.color,
            elevation: 0,
          ),

          onPressed: widget.controller?.isLoading ?? false ? null : widget.voidCallback,
          child: widget.controller?.isLoading ?? false
              ? Container(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : widget.text),
    );
  }
}

class ButtonRegisterController extends ChangeNotifier {
  bool isLoading = false;

  void toggle() {
    this.isLoading = !this.isLoading;
    notifyListeners();
  }
}
