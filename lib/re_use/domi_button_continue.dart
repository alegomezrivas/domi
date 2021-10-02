import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DomiContinueButton extends StatefulWidget {
  final String text;
  final AsyncCallback? voidCallback;
  final double width;
  final double height;
  final bool disabled;

  DomiContinueButton(
      {this.text = "Continuar",
      @required this.voidCallback,
      this.width = double.maxFinite,
      this.height = 44,
      this.disabled = false});

  @override
  _DomiContinueButtonState createState() => _DomiContinueButtonState();
}

class _DomiContinueButtonState extends State<DomiContinueButton> {
  ValueNotifier<bool> _loading = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _loading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: _loading,
        builder: (context, value, child) {
          return Container(
            height: widget.height,
            width: widget.width,
            child: ElevatedButton(
              onPressed: value || widget.disabled
                  ? null
                  : () async {
                      try {
                        _loading.value = true;
                        await widget.voidCallback!();
                      } catch (e) {

                      }
                      _loading.value = false;
                    },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: inDomiButtonBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(9)),
              ),
              child: value
                  ? CircularProgressIndicator(strokeWidth: 2)
                  : Text(
                      widget.text,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
            ),
          );
        });
  }
}
