import 'package:cosmetic_survey/src/core/constants/firebase_providers.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/current_user_details.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class Utils {
  static Future<bool> askPermissionCamera() async {
    var permission = await Permission.camera.request();

    if (permission.isGranted) {
      return true;
    }
    return false;
  }

  static Future<bool> isPermissionCameraDenied() async {
    if (await Permission.camera.isDenied) {
      return true;
    }
    return false;
  }

  static Future<bool> askPermissionStorage() async {
    var permission = await Permission.storage.request();

    if (permission.isGranted) {
      return true;
    }
    return false;
  }

  static Future<bool> isPermissionCameraStorage() async {
    if (await Permission.storage.isDenied) {
      return true;
    }
    return false;
  }

  static bool isFirebaseUser() {
    CurrentUserDetails currentUserDetails = CurrentUserDetails();

    if (currentUserDetails.getCurrentUserProvider() ==
        FirebaseProvider.GOOGLE) {
      return true;
    }
    return false;
  }

  static String formatDate({required DateTime date}) {
    return DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br')
        .format(date)
        .toString();
  }

  static String formatDateDDMMYYYY({required DateTime date}) {
    return DateFormat(DateFormat.YEAR_NUM_MONTH_DAY, 'pt_Br')
        .format(date)
        .toString();
  }

  String getCurrentDateMonthWeekdayDay() {
    return DateFormat(DateFormat.MONTH_WEEKDAY_DAY, 'pt_Br')
        .format(DateTime.now().toLocal())
        .toString();
  }

  String getCurrentDateYearNumMonthDay() {
    return DateFormat(DateFormat.YEAR_NUM_MONTH_DAY, 'pt_Br')
        .format(DateTime.now().toLocal())
        .toString();
  }

  String formatToBrazilianCurrency(double value) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '');

    return formatter.format(value).trim();
  }

  double formatValue(String price) {
    if (!price.contains('.')) {
      return double.parse(price.replaceAll(",", "."));
    } else {
      var formattedValue = price.replaceAll(",", ".").replaceAll(".", "");

      return double.parse(formattedValue) / 100;
    }
  }

  double formatStringValue(String value) {
    return double.parse(
      value.toString().replaceAll(',', '').replaceAll('.', ''),
    );
  }

  double fixDecimalValue(double value) {
    return (value * 100).floorToDouble() / 100;
  }

  double roundToTwoDecimalPlaces(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  List<double> getOrderInstallmentValue(String valueToPay, int installments) {
    var formattedTotalValue = formatValue(valueToPay);

    int totalValueInCents = (formattedTotalValue * 100).round();
    int installmentValueInCents = totalValueInCents ~/ installments;

    var installmentValues = <double>[];

    for (int i = 1; i <= installments; i++) {
      if (i == installments) {
        int lastInstallmentValueInCents =
            totalValueInCents - (installmentValueInCents * (installments - 1));
        double lastInstallmentValue = lastInstallmentValueInCents / 100;
        installmentValues.add(lastInstallmentValue);
      } else {
        double installmentValue = installmentValueInCents / 100;
        installmentValues.add(installmentValue);
      }
    }

    return installmentValues;
  }

  DateTime getBeginningOfTheDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 0, 0, 0, 0, 0);
  }

  DateTime getEndOfTheDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999, 999);
  }

  DateTime parseTextFromDate(String date) {
    return DateFormat("dd/MM/yyyy").parse(date);
  }
}
