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
static Future<void> launchingFunction({
  required String url,
  required String name,
  required BuildContext context,
}) async {
  final String trimmed = url.trim();

  Uri? parsed = Uri.tryParse(
    (trimmed.startsWith('http://') || trimmed.startsWith('https://'))
        ? trimmed
        : 'https://$trimmed',
  );
  if (parsed == null || (parsed.scheme != 'http' && parsed.scheme != 'https')) {
    if (context.mounted) {
      CustomSnackBar.show(
        context,
        message: 'Invalid $name link',
        textAlign: TextAlign.center,
        backgroundColor: AppPalette.redColor,
      );
    }
    return;
  }

  if (parsed.host.contains('play.google.com') &&
      parsed.path.contains('/store/apps/details')) {
    final appId = parsed.queryParameters['id'];
    if (appId != null && appId.isNotEmpty) {
      final market = Uri.parse('market://details?id=$appId');
      final openedMarket = await launchUrl(market, mode: LaunchMode.externalApplication);
      if (openedMarket) return;
    }
  }

  bool ok = await launchUrl(parsed, mode: LaunchMode.inAppWebView);
  if (!ok) {
    ok = await launchUrl(parsed, mode: LaunchMode.externalApplication);
  }

  if (!ok && context.mounted) {
    CustomSnackBar.show(
      context,
      message: 'Could not launch $name at the moment',
      textAlign: TextAlign.center,
      backgroundColor: AppPalette.redColor,
    );
  }
 }
}