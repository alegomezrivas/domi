import 'package:domi/core/extensions/string.dart';
import 'package:domi/main.dart';
import 'package:domi/provider/wallet/wallet_provider.dart';
import 'package:domi/re_use/button_register_login.dart';
import 'package:domi/re_use/domi_web_view.dart';
import 'package:domi/re_use/indomi_text_form_field.dart';
import 'package:domi/re_use/message_strings.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/re_use/utils/domi_format.dart';
import 'package:domi/repositories/wallet_repository.dart';
import 'package:domi/screens/home/wallet/wallet_recharge_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

class WalletDomiciliary extends StatefulWidget {
  @override
  _WalletDomiciliaryState createState() => _WalletDomiciliaryState();
}

class _WalletDomiciliaryState extends State<WalletDomiciliary>
    with TickerProviderStateMixin {
  ValueNotifier<bool> _activeButton = ValueNotifier<bool>(false);
  ValueNotifier<bool> _buttonDisbursement = ValueNotifier<bool>(false);
  TextEditingController _amount = TextEditingController();
  TextEditingController _numberCel = TextEditingController();
  TextEditingController _numberID = TextEditingController();
  GlobalKey<FormState> _formState = GlobalKey<FormState>();
  ScrollController _scrollController = ScrollController();
  ButtonRegisterController _buttonRegisterController =
      ButtonRegisterController();

  int selectedAmount = 0;

  @override
  void initState() {
    _scrollController.addListener(scrollListener);
    super.initState();
    Future.microtask(() {
      context.read(walletProvider.notifier).refreshWallet();
    });
  }

  void scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      context.read(walletProvider.notifier).getTransactions();
    }
  }

  @override
  void dispose() {
    _activeButton.dispose();
    _buttonDisbursement.dispose();
    _amount.dispose();
    _numberCel.dispose();
    _numberID.dispose();
    _buttonRegisterController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: inDomiScaffoldGrey,
        body: Consumer(builder: (context, watch, child) {
          final data = watch(walletProvider).results;
          final isLoading = watch(walletProvider).loading;
          final page = watch(walletProvider).page;
          final userData = watch(authProvider).userData;
          return RefreshIndicator(
            onRefresh: () async {
              return context.read(walletProvider.notifier).refreshWallet();
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Form(
                      key: _formState,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 33,
                                  backgroundImage: (userData!
                                                  .user.person.photo !=
                                              null
                                          ? NetworkImage(
                                              userData.user.person.photo!)
                                          : AssetImage("assets/icons/im.png"))
                                      as ImageProvider,
                                ),
                                SizedBox(
                                  width: 9,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userData.user.fullName,
                                      style: TextStyle(
                                          color: inDomiBluePrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    Text(
                                      "Usuario ID ${userData.user.id.toString().padLeft(6, '0')}",
                                      style: TextStyle(
                                          color: inDomiGreyBlack, fontSize: 11),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 17,
                          ),
                          ValueListenableBuilder(
                              valueListenable: _buttonDisbursement,
                              builder: (context, value, child) {
                                return AnimatedSize(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.elasticOut,
                                  vsync: this,
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 3)
                                        ]),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 10,
                                          top: 20,
                                          left: 15,
                                          right: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Saldo:",
                                                style: TextStyle(
                                                    color: inDomiGreyBlack,
                                                    fontSize: 12),
                                              ),
                                              Spacer(),
                                              Text(
                                                watch(walletProvider)
                                                    .getBalance,
                                                style: TextStyle(
                                                    color: inDomiBluePrimary,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Desembolso:",
                                                style: TextStyle(
                                                    color: inDomiGreyBlack,
                                                    fontSize: 12),
                                              ),
                                              Spacer(),
                                              Text(
                                                watch(walletProvider)
                                                    .getDrawback,
                                                style: TextStyle(
                                                    color: inDomiBluePrimary,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          if (value == false)
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: 14,
                                                ),
                                                ButtonRegisterLogin(
                                                  height: 36,
                                                  width: double.maxFinite,
                                                  color: inDomiBluePrimary,
                                                  text: Text(
                                                    "Recarga en línea",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                  voidCallback: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                WalletRechargePage()));
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                ButtonRegisterLogin(
                                                  height: 36,
                                                  width: double.maxFinite,
                                                  color: inDomiButtonBlue,
                                                  text: Text(
                                                    "Solicitar un desembolso",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                  voidCallback: () {
                                                    if (_buttonDisbursement
                                                            .value ==
                                                        false) {
                                                      _buttonDisbursement
                                                          .value = true;
                                                    } else {
                                                      _buttonDisbursement
                                                          .value = false;
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          if (value == true)
                                            widgetDrawback(
                                                watch(walletProvider)),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          SizedBox(
                            height: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ValueListenableBuilder<bool>(
                    valueListenable: _activeButton,
                    builder: (context, value, child) {
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 17),
                          child: Column(
                            children: [
                              Container(
                                width: double.maxFinite,
                                height: 44,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_activeButton.value == false) {
                                      _activeButton.value = true;
                                    } else {
                                      _activeButton.value = false;
                                    }
                                    context
                                        .read(walletProvider.notifier)
                                        .refreshState();
                                  },
                                  child: Container(
                                    height: 44,
                                    width: double.maxFinite,
                                    child: Stack(
                                      alignment: Alignment.centerLeft,
                                      children: [
                                        Text(
                                          "Ver historial de movimientos",
                                          style: TextStyle(
                                              color: inDomiBluePrimary,
                                              fontSize: 15),
                                        ),
                                        Positioned(
                                            right: 0,
                                            child: Icon(
                                              value == false
                                                  ? Icons.keyboard_arrow_right
                                                  : Icons.keyboard_arrow_down,
                                              color: inDomiBluePrimary,
                                              size: 28,
                                            ))
                                      ],
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    primary: inDomiYellow,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(9)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 14,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                if (_activeButton.value)
                  SliverToBoxAdapter(
                    child: DataTable(
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text('Fecha'),
                        ),
                        DataColumn(
                          label: Text('Tipo'),
                        ),
                        DataColumn(
                          label: Text('Total'),
                        ),
                        DataColumn(
                          label: Text('Estado'),
                        ),
                      ],
                      columnSpacing: 10,
                      rows: List<DataRow>.generate(data.length, (int index) {
                        final color = data[index].getDetailColor();
                        return DataRow(
                          color: MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                            // All rows will have the same selected color.
                            if (states.contains(MaterialState.selected))
                              return Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.08);
                            // Even rows will have a grey color.
                            if (index.isEven) {
                              return Colors.grey.withOpacity(0.15);
                            }
                            return null; // Use default value for other states and odd rows.
                          }),
                          cells: <DataCell>[
                            DataCell(Text(
                                DomiFormat.formatDateTZString(
                                    data[index].timestamp!),
                                style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.bold))),
                            DataCell(Text(data[index].getDetail(),
                                style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.bold))),
                            DataCell(Text(
                                DomiFormat.formatCurrency(
                                    double.parse(data[index].total!)),
                                style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.bold))),
                            DataCell(Text(data[index].getStatus(),
                                style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.bold))),
                          ],
                        );
                      }),
                    ),
                  ),
                if (isLoading)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          );
        }));
  }

  Widget widgetDrawback(WalletState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Divider(
          color: Colors.black26,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "¿Cuánto deseo retirar?",
          style: TextStyle(color: inDomiBluePrimary, fontSize: 12),
        ),
        Column(
          children: [
            Row(
              children: [
                Radio<int>(
                  value: 0,
                  groupValue: selectedAmount,
                  onChanged: (value) {
                    setState(() {
                      selectedAmount = value!;
                    });
                  },
                ),
                Text(
                  "Retirar todo ${state.getBalance}",
                  style: TextStyle(color: inDomiGreyBlack, fontSize: 12),
                ),
              ],
            ),
            Row(
              children: [
                Radio<int>(
                  value: 1,
                  groupValue: selectedAmount,
                  onChanged: (value) {
                    setState(() {
                      selectedAmount = value!;
                    });
                  },
                ),
                Text(
                  "Otro monto",
                  style: TextStyle(color: inDomiGreyBlack, fontSize: 12),
                ),
                SizedBox(
                  width: 7,
                ),
                Expanded(
                  child: IndomiTextFormField(
                    enabledNumber: selectedAmount == 1,
                    hintText: "\$",
                    radius: 7,
                    height: 27,
                    color: inDomiScaffoldGrey,
                    controller: _amount,
                    edgeInsetsGeometry: EdgeInsets.only(left: 5),
                    formatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                      DecimalTextInputFormatter(decimalRange: 2)
                    ],
                    keyboardType: TextInputType.number,
                    validator: selectedAmount == 1
                        ? (value) {
                            if (value!.isEmpty) {
                              return REQUIRED_MESSAGE;
                            }
                            return null;
                          }
                        : null,
                    maxLength: 10,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          color: Colors.black26,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Cuenta Daviplata",
          style: TextStyle(color: inDomiBluePrimary, fontSize: 12),
        ),
        SizedBox(
          height: 4.5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  "Número de celular",
                  style: TextStyle(color: inDomiGreyBlack, fontSize: 12),
                ),
                SizedBox(
                  width: 7,
                ),
                Expanded(
                  child: IndomiTextFormField(
                    radius: 7,
                    height: 27,
                    color: inDomiScaffoldGrey,
                    controller: _numberCel,
                    formatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    keyboardType: TextInputType.number,
                    edgeInsetsGeometry: EdgeInsets.only(left: 5),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return REQUIRED_MESSAGE;
                      }
                      if (value.length < 10) {
                        return NOT_VALID_NUMBER_MESSAGE;
                      }
                      return null;
                    },
                    maxLength: 10,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text(
                  "Número de cédula",
                  style: TextStyle(color: inDomiGreyBlack, fontSize: 12),
                ),
                SizedBox(
                  width: 7,
                ),
                Expanded(
                  child: IndomiTextFormField(
                    radius: 7,
                    height: 27,
                    color: inDomiScaffoldGrey,
                    controller: _numberID,
                    formatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    keyboardType: TextInputType.number,
                    edgeInsetsGeometry: EdgeInsets.only(left: 5),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return REQUIRED_MESSAGE;
                      }
                      return null;
                    },
                    maxLength: 10,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ButtonRegisterLogin(
              height: 36,
              width: double.maxFinite,
              color: inDomiButtonBlue,
              controller: _buttonRegisterController,
              text: Text(
                "Solicitar un desembolso",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              voidCallback: () async {
                if (!_formState.currentState!.validate()) {
                  return;
                }
                final total = selectedAmount == 0
                    ? context.read(walletProvider).balance
                    : double.parse(_amount.text);

                if (selectedAmount == 1) {
                  if (total > context.read(walletProvider).balance) {
                    snackBarMessage(context, "No tienes suficiente saldo",
                        type: SnackBarDomiType.error);
                  }
                }

                if (total <
                    context
                        .read(authProvider)
                        .userData!
                        .params
                        .minDrawbackValue
                        .toDouble()) {
                  snackBarMessage(context,
                      "No supera el valor minimo para desembolso ${context.read(authProvider).userData!.params.minDrawbackValue.toCurrency()}",
                      type: SnackBarDomiType.error);
                  return;
                }
                try {
                  _buttonRegisterController.toggle();
                  await WalletRepository.postDrawback({
                    "total": total,
                    "phone": _numberCel.text,
                    "doc_number": _numberID.text,
                  });
                  context.read(walletProvider.notifier).drawback(total);
                  snackBarMessage(context, "Solicitud exitosa");
                  _showContainer(context);
                } catch (e) {
                  showError(context, e);
                }

                _buttonRegisterController.toggle();
              },

            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DomiWebView(
                    url:
                        context.read(authProvider).userData!.params.drawbackUrl,
                  ),
                ));
              },
              child: Text(
                "Ver políticas de desembolso",
                style: TextStyle(
                    color: inDomiBluePrimary,
                    fontSize: 12,
                    decoration: TextDecoration.underline),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () {
                _buttonDisbursement.value = false;
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "CERRAR",
                  style: TextStyle(
                      color: inDomiGreyBlack,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  void _showContainer(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            height: 190,
            width: 300,
            child: Container(
              child: Padding(
                  padding: const EdgeInsets.only(
                    top: 21,
                    left: 18,
                    right: 18,
                    bottom: 20
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "¡Su solicitud ha sido enviada!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: inDomiBluePrimary),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Revisaremos la solicitud y haremos el desembolso entre 24 y 48 hrs a su cuenta Daviplata",
                        textAlign: TextAlign.center,
                        style:
                        TextStyle(color: inDomiGreyBlack, fontSize: 11),
                      ),
                      SizedBox(height: 20,),
                      ButtonRegisterLogin(
                        text: Text("Aceptar", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white),
                        ),
                        height: 36,
                        color: inDomiButtonBlue,
                        voidCallback: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }


}
