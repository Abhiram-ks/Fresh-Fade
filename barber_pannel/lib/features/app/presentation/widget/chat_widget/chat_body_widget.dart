import 'package:barber_pannel/core/common/custom_testfiled.dart';
import 'package:barber_pannel/core/debouncer/debouncer.dart';
import 'package:barber_pannel/core/routes/routes.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/core/validation/validation_helper.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_chat_user_lebel_bloc/fetch_chat_user_lebel_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../domain/entity/user_entity.dart';
import 'chat_tail_widget.dart';

class ChatScreenBodyWidget extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;

  const ChatScreenBodyWidget(
      {super.key, required this.screenWidth, required this.screenHeight});

  @override
  State<ChatScreenBodyWidget> createState() => _ChatScreenBodyWidgetState();
}

class _ChatScreenBodyWidgetState extends State<ChatScreenBodyWidget> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
 final TextEditingController _searchController = TextEditingController();
  late final Debouncer _debouncer;
  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(milliseconds: 300);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal:widget.screenWidth > 600 ? widget.screenWidth *0.3 : widget.screenWidth * .04),
        child: Column(
          children: [
            TextFormFieldWidget(
              label: '',
              hintText: 'Search shop...',
              prefixIcon: Icons.search,
              controller: _searchController,
              validate: ValidatorHelper.serching,
              borderClr:Color.fromARGB(255, 249, 249, 249),
              fillClr: Color.fromARGB(255, 240, 240, 240),
              suffixIconData: Icons.clear,
              suffixIconColor: AppPalette.greyColor,
              suffixIconAction: () {
              _searchController.clear();
              context.read<FetchChatUserlebelBloc>().add(FetchChatLebelUserRequst());
              },
              onChanged: (value) {
                _debouncer.run(() {
                  if (value.trim().isEmpty) {
                    context.read<FetchChatUserlebelBloc>().add(FetchChatLebelUserRequst());
                  } else {
                    context.read<FetchChatUserlebelBloc>().add(FetchChatLebelUserSearch(value.trim()));
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            BlocBuilder<FetchChatUserlebelBloc, FetchChatUserlebelState>(
              builder: (context, state) {
                if (state is FetchChatUserlebelLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300] ?? AppPalette.greyColor,
                    highlightColor: AppPalette.whiteColor,
                    child: ListView.builder(
                      itemCount: 15,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatTile(
                          imageUrl: '',
                          shopName: 'Venture Name Loading...',
                          userId: '',
                        );
                      },
                    ),
                  );
                } else if (state is FetchChatUserlebelEmpty ||
                    state is FetchChatUserlebelFailure) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppPalette.buttonColor.withAlpha((0.3 * 255).round()),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "⚿ It looks like your chat box is empty! Start a conversation with a client — your chats will appear here. All conversations are private and secure.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppPalette.blackColor),
                        ),
                      )),
                    ],
                  );
                } else if (state is FetchChatUserlebelSuccess) {
                  final chatList = state.users;

                  return RefreshIndicator(
                    color: AppPalette.buttonColor,
                    backgroundColor: AppPalette.whiteColor,
                    onRefresh: () async {
                      context.read<FetchChatUserlebelBloc>().add(FetchChatLebelUserRequst());
                    },
                    child: ListView.builder(
                      itemCount: chatList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final UserEntity user = chatList[index];
                        return InkWell(
                          focusColor: AppPalette.buttonColor,
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.chatWindows, arguments: {
                              'userId': user.id,
                              'barberId': state.barberId,
                            });
                          },
                          child: ChatTile(
                            imageUrl: user.photoUrl ,
                            shopName: user.name ,
                            userId: user.id,
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

