import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class DomiFormat {
  static NumberFormat nfCurrency =
      NumberFormat.simpleCurrency(decimalDigits: 2, name: "COP");
  static NumberFormat nfCurrencyNoDigits =
      NumberFormat.simpleCurrency(decimalDigits: 0, name: "COP");
  static final dfz = DateFormat("yyyy-MM-ddTHH:mm:ssZ");
  static final df = DateFormat("yyyy-MM-dd HH:mm");
  static final NumberFormat nfCompact = NumberFormat.compact();

  static String formatCompat(dynamic value) {
    return nfCompact.format(value ?? 0);
  }

  static String formatCurrency(dynamic value) {
    return nfCurrency.format(value);
  }

  static String formatCurrencyCustom(dynamic value, {int decimals = 0}) {
    if (decimals == 0) {
      return nfCurrencyNoDigits.format(value);
    }
    return NumberFormat.simpleCurrency(decimalDigits: decimals).format(value);
  }

  static String formatDateTZString(String value) {
    try {
      return df.format(dfz.parse(value, true).toLocal());
    } catch (e) {
      return value;
    }
  }

  static DateTime formatDateTZ(String value) {
    try {
      return dfz.parse(value, true).toLocal();
    } catch (e) {
      return DateTime.now();
    }
  }

  static String timeAgoFormat(String value) {
    try {
      return timeago.format(formatDateTZ(value), locale: 'es');
    } catch (e) {
      return "";
    }
  }
}
