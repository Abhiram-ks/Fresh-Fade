
import '../security/sensitive_keys.dart';

class CloudinaryConfig {
  static late String cloudName;
  static late String apiKey;
  static late String apiSecret;

  static void initialize() {
      cloudName = SensitiveKeys.cloudinaryCloudName;
      apiKey = SensitiveKeys.cloudinaryApiKey;
      apiSecret = SensitiveKeys.cloudinaryApiSecret; 
    

    if (cloudName.isEmpty || apiKey.isEmpty || apiSecret.isEmpty) {
      throw Exception("Cloudinary credentials are missing.");
    }
  }
}
