import 'package:bloc/bloc.dart';

import '../../../../../../service/voice/voice_service.dart';
import '../../../screen/search/search_screen.dart';

part 'voice_state.dart';

class VoiceSearchCubit extends Cubit<VoiceSearchState> {
  VoiceSearchCubit() : super(VoiceSearchState());
  
  Future<void> startVoiceSearch(VoiceService voiceService) async {
    print('🎤 Starting voice search...');
    emit(state.copyWith(isListening: true, recognizedText: '', errorMessage: ''));
    
    // Set up error handler
    voiceService.onError = (errorMsg) {
      print('❌ Voice error: $errorMsg');
      emit(state.copyWith(
        isListening: false, 
        errorMessage: errorMsg,
      ));
    };
    
    // Set up text recognition handler
    voiceService.onTextRecognized = (text) {
      print('🗣️ Recognized text: "$text"');
      emit(state.copyWith(recognizedText: text, errorMessage: ''));
      GlobalSearchController.searchController.text = text;
    };
    
    // Start listening
    final result = await voiceService.startListening();
    
    if (!result) {
      print('❌ Failed to start voice recognition');
      emit(state.copyWith(
        isListening: false,
        errorMessage: 'Failed to start voice recognition',
      ));
    } else {
      print('✅ Voice recognition started successfully');
    }
  }
  
  void stopVoiceSearch() {
    print('🛑 Stopping voice search. Final text: "${state.recognizedText}"');
    emit(state.copyWith(isListening: false, errorMessage: ''));
  }
  
  void clearError() {
    emit(state.copyWith(errorMessage: ''));
  }
}
