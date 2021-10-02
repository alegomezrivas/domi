import 'package:domi/re_use/domi_button_continue.dart';
import 'package:domi/re_use/indomi_text_form_field.dart';
import 'package:domi/re_use/message_strings.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/repositories/wallet_repository.dart';
import 'package:domi/screens/home/wallet/epayco_webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class WalletRechargePage extends StatefulWidget {
  const WalletRechargePage({Key? key}) : super(key: key);

  @override
  _WalletRechargePageState createState() => _WalletRechargePageState();
}

class _WalletRechargePageState extends State<WalletRechargePage> {
  TextEditingController _controller = TextEditingController();
  final _parser = NumberFormat.simpleCurrency(decimalDigits: 0);
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller.text = "10.000";
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: inDomiScaffoldGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Digite el valor a recargar\nCOP",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,),
                SizedBox(height: 15),
                IndomiTextFormField(
                  textAlign: TextAlign.center,
                  width: MediaQuery.of(context).size.width,
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  formatters: [
                    ThousandsSeparatorInputFormatter()
                  ],
                  maxLength: 13,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return REQUIRED_MESSAGE;
                    }

                    if (double.parse(value.replaceAll(".", "")) < 10000) {
                      return MIN_RECHARGE_VALUE_MESSAGE;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                DomiContinueButton(
                    voidCallback: _createRecharge, text: "Rercargar")
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createRecharge() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      final transaction = await WalletRepository.createRecharge(double.parse(_controller.text.replaceAll(".", "")));
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => EpaycoWebView(transaction)));
    } catch (e) {
      showError(context, e);
    }
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = '.'; // Change this to '.' for other locales

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Short-circuit if the new value is empty
    if (newValue.text.length == 0) {
      return newValue.copyWith(text: '');
    }

    // Handle "deletion" of separator character
    String oldValueText = oldValue.text.replaceAll(separator, '');
    String newValueText = newValue.text.replaceAll(separator, '');

    if (oldValue.text.endsWith(separator) &&
        oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    // Only process if the old value and new value are different
    if (oldValueText != newValueText) {
      int selectionIndex =
          newValue.text.length - newValue.selection.extentOffset;
      final chars = newValueText.split('');

      String newString = '';
      for (int i = chars.length - 1; i >= 0; i--) {
        if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1)
          newString = separator + newString;
        newString = chars[i] + newString;
      }

      return TextEditingValue(
        text: newString.toString(),
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndex,
        ),
      );
    }

    // If the new value and old value are the same, just return as-is
    return newValue;
  }
}
