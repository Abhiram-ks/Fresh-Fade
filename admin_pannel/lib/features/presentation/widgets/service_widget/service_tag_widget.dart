
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/app_colors.dart';
import '../../state/cubit/service_tags/servicetags_cubit.dart';

class ServiceTagsWidget extends StatelessWidget {
  final String text;
  final VoidCallback edit;
  final VoidCallback delete;
  const ServiceTagsWidget({
    super.key,
    required this.text,
    required this.edit,
    required this.delete,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceTagsCubitCubit(),
      child: BlocBuilder<ServiceTagsCubitCubit, ServiceTagsCubitState>(
        builder: (context, state) {
          final cubit = context.read<ServiceTagsCubitCubit>();
          bool showActions = state is ServiceTagsShowActions;
          return InkWell(
            onTap: () {
              cubit.toggleActions(showActions);
            },
            child: Container(
              decoration: BoxDecoration(
                color:
                    showActions ? AppPalette.blueColor : AppPalette.whiteColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      showActions
                          ? AppPalette.whiteColor
                          : AppPalette.blackColor,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 18,
                      color:
                          showActions
                              ? AppPalette.whiteColor
                              : AppPalette.blackColor,
                    ),
                  ),
                  if (showActions) ...[
                    IconButton(
                      onPressed: edit,
                      icon: const Icon(
                        CupertinoIcons.pencil,
                        color: AppPalette.whiteColor,
                      ),
                    ),
                    IconButton(
                      onPressed: delete,
                      icon: const Icon(
                        CupertinoIcons.clear,
                        color: AppPalette.whiteColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
