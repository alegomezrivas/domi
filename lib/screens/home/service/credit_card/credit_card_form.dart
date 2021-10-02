import 'package:domi/core/enum/service_enums.dart';
import 'package:domi/provider/service/create_service_provider.dart';
import 'package:domi/provider/service/credit_card_povider.dart';
import 'package:domi/re_use/domi_button_continue.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/repositories/wallet_repository.dart';
import 'package:domi/screens/home/service/credit_card/input_formatters.dart';
import 'package:domi/screens/home/service/credit_card/payment_card.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreditCardForm extends StatefulWidget {
  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = new GlobalKey<FormState>();
  var numberController = new TextEditingController();
  var _paymentCard = PaymentCard();
  var _autoValidateMode = AutovalidateMode.disabled;

  var _card = new PaymentCard();
  Map<String, dynamic> _data = {};

  @override
  void dispose() {
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: inDomiScaffoldGrey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5, top: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: inDomiBluePrimary,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Container(
                          width: 88,
                          height: 30,
                          child: Image(
                            image: AssetImage("assets/icons/Grupo 8@3x.png"),
                            height: 52,
                            width: 52,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9)),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(19),
                      CardNumberInputFormatter()
                    ],
                    controller: numberController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9)),
                      isDense: true,
                      suffixIcon: _paymentCard.type != null
                          ? CardUtils.getCardIcon(_paymentCard.type!)
                          : null,
                      hintText: 'Número de la tarjeta de credito',
                      labelText: 'Número de la tarjeta de credito',
                    ),
                    onSaved: (String? value) {
                      _paymentCard.number = CardUtils.getCleanedNumber(value!);
                      _paymentCard.type =
                          CardUtils.getCardTypeFrmNumber(_paymentCard.number!);
                    },
                    onChanged: (value) {
                      _paymentCard.number = CardUtils.getCleanedNumber(value);
                      _paymentCard.type =
                          CardUtils.getCardTypeFrmNumber(_paymentCard.number!);
                      setState(() {});
                    },
                    validator: CardUtils.validateCardNum,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                SizedBox(
                  height: 14.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9)),
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9)),
                            isDense: true,
                            hintText: 'Codigo de seguridad',
                            labelText: 'CVC',
                          ),
                          validator: CardUtils.validateCVV,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            _paymentCard.cvv = int.parse(value!);
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9)),
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                            CardMonthInputFormatter()
                          ],
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9)),
                            hintText: 'MM/YY',
                            labelText: 'Fecha de expiración',
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: CardUtils.validateDate,
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            List<int> expiryDate =
                                CardUtils.getExpiryDate(value!);
                            _paymentCard.month = expiryDate[0];
                            _paymentCard.year = expiryDate[1];
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 14.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9)),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9)),
                            isDense: true,
                            hintText: 'Nombre',
                            labelText: 'Nombre',
                          ),
                          maxLength: 30,
                          buildCounter: (context,
                                  {int? currentLength,
                                  bool? isFocused,
                                  maxLength}) =>
                              null,
                          validator: (value) {
                            if (value == "") {
                              return "*Este campo no puede estar vacio";
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onSaved: (newValue) => _data["first_name"] = newValue,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9)),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9)),
                            isDense: true,
                            hintText: 'Apellido',
                            labelText: 'Apellido',
                          ),
                          maxLength: 30,
                          buildCounter: (context,
                                  {int? currentLength,
                                  bool? isFocused,
                                  maxLength}) =>
                              null,
                          validator: (value) {
                            if (value == "") {
                              return "*Este campo no puede estar vacio";
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onSaved: (newValue) => _data["last_name"] = newValue,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 14.0,
                ),
                Container(
                  height: 53,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9)),
                  child: DropdownButtonFormField(
                      value: "CC",
                      decoration: InputDecoration(
                          hintText: "Tipo de documento",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9)),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 15)),
                      dropdownColor: Colors.white,
                      onChanged: (value) {
                        _data["doc_type"] = value;
                      },
                      onSaved: (newValue) => _data["doc_type"] = newValue,
                      items: [
                        DropdownMenuItem<String>(
                          child: Row(
                            children: [
                              Text(
                                "CC",
                                style: TextStyle(
                                    fontSize: 14, color: inDomiGreyBlack),
                              ),
                            ],
                          ),
                          value: "CC",
                        ),
                        DropdownMenuItem<String>(
                          child: Row(
                            children: [
                              Text(
                                "NIT",
                                style: TextStyle(
                                    fontSize: 14, color: inDomiGreyBlack),
                              ),
                            ],
                          ),
                          value: "NIT",
                        ),
                        DropdownMenuItem<String>(
                          child: Row(
                            children: [
                              Text(
                                "TI",
                                style: TextStyle(
                                    fontSize: 14, color: inDomiGreyBlack),
                              ),
                            ],
                          ),
                          value: "TI",
                        ),
                      ]),
                ),
                SizedBox(
                  height: 14.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9)),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9)),
                      isDense: true,
                      hintText: 'Documento',
                      labelText: 'Número de documento',
                    ),
                    maxLength: 20,
                    buildCounter: (context,
                            {int? currentLength, bool? isFocused, maxLength}) =>
                        null,
                    validator: (value) {
                      if (value == "") {
                        return "*Este campo no puede estar vacio";
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSaved: (newValue) => _data["doc_number"] = newValue,
                  ),
                ),
                SizedBox(
                  height: 14.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9)),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9)),
                      isDense: true,
                      hintText: 'Correo electronico',
                      labelText: 'Correo electronico',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 100,
                    buildCounter: (context,
                            {int? currentLength, bool? isFocused, maxLength}) =>
                        null,
                    validator: (value) {
                      if (value == "") {
                        return "*Este campo no puede estar vacio";
                      }

                      if (!EmailValidator.validate(value!)) {
                        return "*Digite un email valido";
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSaved: (newValue) => _data["email"] = newValue,
                  ),
                ),
                SizedBox(
                  height: 14.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9)),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9)),
                      isDense: true,
                      hintText: 'Direccion',
                      labelText: 'Ingrese direccion',
                    ),
                    maxLength: 100,
                    buildCounter: (context,
                            {int? currentLength, bool? isFocused, maxLength}) =>
                        null,
                    validator: (value) {
                      if (value == "") {
                        return "*Este campo no puede estar vacio";
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSaved: (newValue) => _data["address"] = newValue,
                  ),
                ),
                SizedBox(
                  height: 14.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9)),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9)),
                      isDense: true,
                      hintText: 'Número de celular',
                      labelText: 'Número de celular',
                    ),
                    maxLength: 15,
                    buildCounter: (context,
                            {int? currentLength, bool? isFocused, maxLength}) =>
                        null,
                    validator: (value) {
                      if (value == "") {
                        return "*Este campo no puede estar vacio";
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSaved: (newValue) => _data["phone"] = newValue,
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                DomiContinueButton(
                  voidCallback: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _data["mask"] = _paymentCard.number;
                      _data["cvc"] = _paymentCard.cvv.toString();
                      _data["exp_month"] = _paymentCard.month.toString();
                      _data["exp_year"] =
                          CardUtils.convertYearTo4Digits(_paymentCard.year!)
                              .toString();
                      print(_data);
                      try {
                        final response =
                            await WalletRepository.createCreditCard(_data);
                        context
                            .read(creditCardProvider.notifier)
                            .setCreditCard(response);
                        context
                            .read(createServiceProvider.notifier)
                            .changePayMethod(PayMethod.card,
                                selectedCard: response);
                        Navigator.of(context).pop();
                      } catch (e) {
                        showError(context, e);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreditCardValidator {
  /// Set RegEx For All Cards
  static const String _VISA = "^4[0-9]{12}(?:[0-9]{3})?\$";
  static const String _MASTERCARD =
      "^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}\$";
  static const String _DISCOVER = "^6(?:011|5[0-9]{2})[0-9]{12}\$";
  static const String _AMEX = "^3[47][0-9]{13}\$";
  static const String _DINERS = "^3(?:0[0-5]|[68][0-9])[0-9]{11}\$";
  static const String _JCB = "^(?:2131|2100|1800|3\\d{4})\\d{11}\$";

  /// Set Map Key
  static const String cardType = "CardType";
  static const String isValidCard = "IsValidCard";

  /// Add RegEx Cards Into List
  static const List<String> regexList = [
    _VISA,
    _MASTERCARD,
    _DISCOVER,
    _AMEX,
    _DINERS,
    _JCB
  ];

  /// Set Card Types List
  static const List<String> _cardTypesList = [
    "VISA",
    "MASTERCARD",
    "DISCOVER",
    "AMEX",
    "DINERS",
    "JCB"
  ];

  /// Combined RegEx
  static RegExp _regex = new RegExp("^(?:(?<visa>4[0-9]{12}(?:[0-9]{3})?)|" +
      "(?<mastercard>5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}|" +
      "(?<discover>6(?:011|5[0-9]{2})[0-9]{12})|" +
      "(?<amex>3[47][0-9]{13})|" +
      "(?<diners>3(?:0[0-5]|[68][0-9])[0-9]{11})|" +
      "(?<jcb>(?:2131|2100|1800|3\\d{4})\\d{11}))\$");

  // Get Card Data - Card Type and isValid Number as Map
  static Map<String, dynamic> getCard(String cardNumber) {
    String _cardType = _getCardType(cardNumber);
    bool isValid = _isCardValid(_cardType, cardNumber);

    Map<String, dynamic> cardData = new Map();
    cardData.putIfAbsent(cardType, () => _cardType);
    cardData.putIfAbsent(isValidCard, () => isValid);
    return cardData;
  }

  // Get Card Type Based On RegEx
  static String _getCardType(String cardNumber) {
    if (_regex.hasMatch(cardNumber)) {
      for (int i = 0; i < regexList.length; i++) {
        RegExp regExp = new RegExp(regexList[i]);
        if (regExp.hasMatch(cardNumber)) {
          return _cardTypesList[i];
        }
      }
    }
    return "UNKNOWN";
  }

  // Check Card Number Validity - Luhn Algorithm
  static bool _isCardValid(String cardType, String ccNumber) {
    if (cardType == "UNKNOWN" || cardType.trim().length == 0) return false;

    int sum = 0;
    bool alternate = false;
    for (int i = ccNumber.length - 1; i >= 0; i--) {
      int n = int.parse(ccNumber.substring(i, i + 1));
      if (alternate) {
        n *= 2;
        if (n > 9) {
          n = (n % 10) + 1;
        }
      }
      sum += n;
      alternate = !alternate;
    }
    return (sum % 10 == 0);
  }
}
