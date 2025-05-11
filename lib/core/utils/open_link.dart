import 'package:url_launcher/url_launcher.dart';

Future<void> openLink(String href) async {
  final Uri url = Uri.parse(href);

  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
