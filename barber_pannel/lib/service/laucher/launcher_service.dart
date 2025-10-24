import 'package:url_launcher/url_launcher.dart';

class LauncerService {
   /// Open email with subject and body
  static Future<bool> openEmail({required String email, String?  name,  required String subject, required String body}) async {
   try {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      query:'subject=${Uri.encodeComponent("To connect with")}&body=${Uri.encodeComponent("Hello ${name ?? 'Fresh Fade : Customer'} \nI hope this message finds you well. \n\n $body")}',
    );
    await launchUrl(params);
    return true;
   } catch (e) {
    throw Exception(e);
   }
  }
}