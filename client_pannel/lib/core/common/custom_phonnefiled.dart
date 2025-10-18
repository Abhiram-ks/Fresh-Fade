import 'package:client_pannel/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/app/presentations/state/cubit/icon_cubit/icon_cubit.dart';
import '../constant/constant.dart';

class TextfiledPhone extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final Color iconColor;

  const TextfiledPhone({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    required this.validator,
    required this.controller,
    this.enabled = true,
    this.iconColor = AppPalette.hintColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IconCubit(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 5),
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          BlocSelector<IconCubit, IconState, ColorUpdated?>(
            selector: (state) {
              if (state is ColorUpdated) {
                return state;
              }
              return null;
            },
            builder: (context, state) {
              Color suffixColor = state?.color ?? iconColor;

              return TextFormField(
                controller: controller,
                validator: validator,
                obscureText: false,
                style: const TextStyle(fontSize: 16),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                enabled: enabled,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  context.read<IconCubit>().updateIcon(value.length == 10);
                },
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(color: AppPalette.hintColor),
                  prefixIcon: Icon(prefixIcon, color: AppPalette.blackColor),
                  suffixIcon: Icon(Icons.check_circle, color: suffixColor),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppPalette.hintColor,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppPalette.buttonColor,
                      width: 1,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppPalette.redColor,
                      width: 1,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppPalette.redColor,
                      width: 1,
                    ),
                  ),
                ),
              );
            },
          ),
          ConstantWidgets.hight10(context),
        ],
      ),
    );
  }
}
