
import 'package:client_pannel/core/di/di.dart';
import 'package:client_pannel/features/app/presentations/state/cubit/last_message_cubit/last_message_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/images/app_images.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../screen/settings/settings_screen.dart';
import '../../state/cubit/message_badget_cubit.dart/message_badge_cubit.dart';

class ChatTile extends StatelessWidget {
  final String imageUrl;
  final String shopName;
  final String barberId;

  const ChatTile({
    super.key,
    required this.imageUrl,
    required this.shopName,
    required this.barberId,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final avatarSize = screenWidth * 0.13;
    final horizontalSpacing = screenWidth * 0.04;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = sl<MessageBadgeCubit>();
            cubit.numberOfBadges(barberId: barberId);
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) {
            final cubit = sl<LastMessageCubit>();
            cubit.lastMessage(barberId: barberId);
            return cubit;
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(avatarSize / 2),
              child: SizedBox(
                width: avatarSize,
                height: avatarSize,
                child: imageshow(
                  imageUrl: imageUrl,
                  imageAsset: AppImages.barberEmpty,
                ),
              ),
            ),
            SizedBox(width: horizontalSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shopName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.045,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  BlocBuilder<LastMessageCubit, LastMessageState>(
                    builder: (context, state) {
                      if (state is LastMessageLoading) {
                        return Text(
                          'Loading...',
                          style: TextStyle(
                            color: AppPalette.greyColor,
                            fontSize: screenWidth * 0.035,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      } else if (state is LastMessageSuccess) {
                        final message = state.message;
                        String lastMessage = message.message;

                        if (message.delete) {
                          lastMessage = 'This message was deleted';
                        }
                        return Text(
                          lastMessage,
                          style: TextStyle(
                            color: AppPalette.greyColor,
                            fontSize: screenWidth * 0.035,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      }
                      return Text(
                        'Tap to view chats',
                        style: TextStyle(
                          color: AppPalette.greyColor,
                          fontSize: screenWidth * 0.035,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: horizontalSpacing),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BlocBuilder<LastMessageCubit, LastMessageState>(
                  builder: (context, state) {
                    if (state is LastMessageSuccess) {
                      final DateTime createdAt = state.message.createdAt;
                      final DateTime now = DateTime.now();
                      final bool isLessThan24Hours =  now.difference(createdAt).inHours < 24;

                      final formattedTime = isLessThan24Hours
                          ? DateFormat('hh:mm a')
                              .format(createdAt) 
                          : DateFormat('dd MMM yyyy')
                              .format(createdAt);
                      return Text(
                        formattedTime,
                        style: TextStyle(
                          color: AppPalette.greyColor,
                          fontSize: screenWidth * 0.03,
                        ),
                      );
                    }
                    return Text(
                      '1 Jan 2000',
                      style: TextStyle(
                        color: AppPalette.greyColor,
                        fontSize: screenWidth * 0.03,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 6),
                BlocBuilder<MessageBadgeCubit, MessageBadgeState>(
                  builder: (context, state) {
                    if (state is MessageBadgeSuccess) {
                      final int badges = state.badges;
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: avatarSize * 0.12,
                          vertical: avatarSize * 0.05,
                        ),
                        decoration: const BoxDecoration(
                          color: AppPalette.orengeColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          badges.toString(),
                          style: TextStyle(
                            color: AppPalette.whiteColor,
                            fontSize: screenWidth * 0.03,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
