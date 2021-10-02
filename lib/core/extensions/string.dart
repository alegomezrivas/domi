
import 'package:decimal/decimal.dart';
import 'package:domi/re_use/utils/domi_format.dart';

extension StringChecker on String? {
  bool isNotEmptyOrNull() {
    if(this == null){
      return false;
    }

    if(this!.isEmpty){
      return false;
    }
    return true;
  }

  Decimal toDecimal() {
    return Decimal.parse(this ?? "0");
  }

  double toDouble() {
    return double.parse(this ?? "0");
  }

  String toCurrency({int decimalPlaces = 0}){
    return DomiFormat.formatCurrencyCustom(this.toDouble(), decimals: decimalPlaces);
  }
}