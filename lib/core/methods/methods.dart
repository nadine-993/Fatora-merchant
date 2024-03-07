import 'package:intl/intl.dart';

class Methods {

  static String getDate(String? date) {
    var myFormat = DateFormat('dd/MM/yyyy');
    DateTime datetime = DateTime.parse(date!);
    String formattedDate = myFormat.format(datetime).toString();
    return formattedDate;
  }

  static String capitalizeFirst(String str) {
    return '${str[0].toUpperCase()}${str.substring(1)}';
  }

  static String getTime(String? date) {
    DateTime datetime = DateTime.parse(date!);
    String formattedDate = DateFormat.jm().format(datetime);
    return formattedDate;
  }

  static String formatMoney(double amount) {
    final formatter = NumberFormat.currency(locale: 'ar_SY', symbol: '', decimalDigits: 0);
    return formatter.format(amount);
  }
}