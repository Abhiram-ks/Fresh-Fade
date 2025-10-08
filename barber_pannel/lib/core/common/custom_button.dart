import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import '../themes/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color bgColor;
  final Color textColor;
  final double borderRadius;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final FontWeight fontWeight;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.bgColor = AppPalette.buttonColor,
    this.textColor = AppPalette.whiteColor,
    this.borderRadius = 9,
    this.borderColor,
    this.padding = const EdgeInsets.symmetric(vertical: 14),
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: BlocBuilder<ProgresserCubit, ProgresserState>(
        builder: (context, state) {
          final bool isLoading = state is ButtonProgressStart;

          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor,
              padding: padding,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                side:
                    borderColor != null
                        ? BorderSide(color: borderColor!)
                        : BorderSide.none,
              ),
            ),
            onPressed: isLoading ? null : onPressed,
            child: Center(
              child:
                  isLoading
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppPalette.whiteColor,
                              strokeWidth: 2.5,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Please wait...',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppPalette.whiteColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                      : Text(
                        text,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: textColor,
                          fontWeight: fontWeight,
                        ),
                      ),
            ),
          );
        },
      ),
    );
  }
}
