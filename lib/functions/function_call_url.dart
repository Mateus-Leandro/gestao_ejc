import 'package:url_launcher/url_launcher.dart';

class FunctionCallUrl {
  Future<String?> callUrl(String url) async {
    Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return null;
    } else {
      return 'Não foi possível abrir o link: $url';
    }
  }
}
