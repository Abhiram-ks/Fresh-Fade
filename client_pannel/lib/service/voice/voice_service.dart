import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceService {
  final stt.SpeechToText speechToText;
  Function(String)? onTextRecognized;
  Function(String)? onError;
  
  VoiceService(this.speechToText);
  
  /// Starts listening for speech input
  /// Returns true if listening started successfully
  /// The speech_to_text package handles microphone permission automatically
  /// It will show the default Android permission dialog if permission is not granted
  Future<bool> startListening() async {
    try {
      // Check if already initialized
      if (!speechToText.isAvailable) {
        // Initialize speech recognition with permission handling
        // This will automatically request microphone permission using default Android dialog
        final isAvailable = await speechToText.initialize(
          onStatus: (status) {
            debugPrint('Speech recognition status: $status');
            if (status == 'done' || status == 'notListening') {
              stopListening();
            }
          },
          onError: (error) {
            debugPrint("Speech recognition error: $error");
            final errorMsg = _getErrorMessage(error.errorMsg);
            onError?.call(errorMsg);
          },
        );
        
        if (!isAvailable) {
          // Permission was denied or speech recognition is not available
          onError?.call('permission_denied');
          return false;
        }
      }
      
      // Start listening for speech
      await speechToText.listen(
        onResult: (result) {
          final recognizedWords = result.recognizedWords;
          if (recognizedWords.isNotEmpty && onTextRecognized != null) {
            onTextRecognized!(recognizedWords);
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        cancelOnError: true,
      );
      
      return true;
    } catch (e) {
      debugPrint("Error starting speech recognition: $e");
      onError?.call('Failed to start voice recognition. Please try again.');
      return false;
    }
  }
  
  Future<void> stopListening() async {
    await speechToText.stop();
  }
  
  /// Convert error messages to user-friendly text
  String _getErrorMessage(String errorMsg) {
    if (errorMsg.toLowerCase().contains('permission')) {
      return 'Microphone permission is required for voice search';
    } else if (errorMsg.toLowerCase().contains('network')) {
      return 'Network error. Please check your internet connection';
    } else if (errorMsg.toLowerCase().contains('not available')) {
      return 'Speech recognition is not available on this device';
    } else {
      return 'Voice recognition error. Please try again';
    }
  }
}