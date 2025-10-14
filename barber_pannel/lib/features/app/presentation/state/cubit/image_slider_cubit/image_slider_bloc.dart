import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ImageSliderCubit extends Cubit<int> {
  final PageController pageController;
  final int imageList;
  Timer? autoScrollTimer;

  ImageSliderCubit({
    required this.imageList,
    double viewportFraction = 0.8444,
  }) : pageController = PageController(
          viewportFraction: viewportFraction,
          initialPage: 0,
        ),
        super(0) {
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(milliseconds: 500), () {
      autoScrollTimer = Timer.periodic(const Duration(seconds: 8), (_) {
        if (!pageController.hasClients || isClosed) return;
        
        int nextPage = state + 1;
        if (nextPage >= imageList) {
          nextPage = 0;
        }
        
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  void updatePage(int index) {
    if (!isClosed) {
      emit(index);
    }
  }

  void pauseAutoScroll() {
    autoScrollTimer?.cancel();
  }

  void resumeAutoScroll() {
    if (autoScrollTimer?.isActive != true) {
      _startAutoScroll();
    }
  }

  void goToPage(int page) {
    if (pageController.hasClients && !isClosed) {
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Future<void> close() {
    autoScrollTimer?.cancel();
    pageController.dispose();
    return super.close();
  }
}