import 'package:url_launcher/url_launcher.dart';

class FunctionCallEmailApp {
  Future<void> open(
      {required String email, String? subject, String? body}) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Não foi possível abrir o email';
    }
  }
}
