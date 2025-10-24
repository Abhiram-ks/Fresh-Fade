import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/common/custom_snackbar.dart';
import '../../core/themes/app_colors.dart';

class LauncerService {
   /// Open email with subject and body
  static Future<bool> openEmail({required String email, String?  name,  required String subject, required String body}) async {
   try {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      query:'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent("Hello ${name ?? 'Fresh Fade : Customer'} \nI hope this message finds you well. \n\n $body")}',
    );
    await launchUrl(params);
    return true;
   } catch (e) {
    throw Exception(e);
   }
  }

  /// Open url in inAppWebView
  static Future<void> lauchingFunction({required String url, required String name, required BuildContext context}) async {
  final Uri parseURl = Uri.parse(url);

  if (!await launchUrl(
    parseURl,
    mode: LaunchMode.inAppWebView,
  )) {
    if (context.mounted) {
      CustomSnackBar.show(context, message: 'Could not launch $name at that moment', textAlign: TextAlign.center, backgroundColor: AppPalette.redColor);
    }
  }
}

}