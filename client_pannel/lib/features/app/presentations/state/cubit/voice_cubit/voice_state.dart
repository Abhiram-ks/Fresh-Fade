part of 'voice_cubit.dart';

class VoiceSearchState {
  final bool isListening;
  final String recognizedText;
  final String? errorMessage;

  VoiceSearchState({
    this.isListening = false, 
    this.recognizedText = '',
    this.errorMessage,
  });

  VoiceSearchState copyWith({
    bool? isListening, 
    String? recognizedText,
    String? errorMessage,
  }) {
    return VoiceSearchState(
      isListening: isListening ?? this.isListening,
      recognizedText: recognizedText ?? this.recognizedText,
      errorMessage: errorMessage,
    );
  }

  bool get isEmpty => !isListening && recognizedText.isEmpty;
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
}
