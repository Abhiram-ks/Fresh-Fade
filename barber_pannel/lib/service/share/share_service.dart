import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';


abstract class ShareService {
  Future<bool> sharePost({required String text, required String ventureName, required String location, required String? imageUrl});
}

class ShareServiceImpl implements ShareService {

  @override
  Future<bool> sharePost(
    {required String text, 
    required String ventureName, 
    required String location, 
    required String? imageUrl}) async {
    final shareText = 'Check out $ventureName at $location.';
    final shareTextContent = "Here's a style you don't want to miss 💈 $text";

    try {
      final shareParams = await _prepareShareParams(
        text: shareTextContent,
        title: shareText,
        imageUrl: imageUrl,
      );

      final result = await SharePlus.instance.share(shareParams);

      if (result.status == ShareResultStatus.success) {
        return true;
      } else if (result.status == ShareResultStatus.dismissed) {
        return false;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Failed to share post: ${e.toString()}');
    }
  }
}

  Future<ShareParams> _prepareShareParams({
    required String text,
    required String title,
    String? imageUrl,
  }) async {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      final response = await http.get(Uri.parse(imageUrl));
      final bytes = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/shared_image.jpg');
      await file.writeAsBytes(bytes);

      return ShareParams(
        text: text,
        title: title,
        files: [XFile(file.path)],
      );
    } else {
      return ShareParams(text: text, title: title);
    }
  }

