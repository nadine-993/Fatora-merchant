import 'package:url_launcher/url_launcher.dart';

class Launchers {
  static Future<void> launchWebUrl(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  static Future<void> sendViaWhatsapp(String text) async {
    final url = 'whatsapp://send?text=$text';
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
}