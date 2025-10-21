import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/constant/constant.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../state/bloc/fetch_bloc/fetch_chat_barber_leble_bloc/fetch_chat_barber_lebel_bloc.dart';
import 'chat_tail_custom_widget.dart';

BlocBuilder<FetchChatBarberlebelBloc, FetchChatBarberlebelState>
    chatTailBuilderWidget(
        BuildContext context, double screenWidth, double screenHeight) {
  return BlocBuilder<FetchChatBarberlebelBloc, FetchChatBarberlebelState>(

    builder: (context, state) {
     if (state is FetchChatBarberlebelEmpty) {
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
                '⚿ Looks like your chatBox is empty! Start a conversation with a barber — your chats will show up here.All chats are private and secure.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppPalette.blackColor),
              ),
            )),
          ],
        );
      }
      else if (state is FetchChatBarberlebelSuccess) {
        final chatList = state.barbers;

        return RefreshIndicator(
          color: AppPalette.buttonColor,
          backgroundColor: AppPalette.whiteColor,
          onRefresh: () async {
            
            context.read<FetchChatBarberlebelBloc>().add(FetchChatLebelBarberRequst());
          },
          child: ListView.builder(
            itemCount: chatList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final barber = chatList[index];
              return InkWell(
                onTap: ()  {

                  Navigator.pushNamed(context, AppRoutes.chatWindow, arguments: {
                    'barberId': barber.uid,
                    'userId': state.userId,
                  });
                },
                child: ChatTile(
                  imageUrl: barber.image ?? '',
                  shopName: barber.ventureName,
                  barberId: barber.uid,
                ),
              );
            },
          ),
        );
      }
      else if (state is FetchChatBarberlebelFailure){
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConstantWidgets.hight10(context),
            Icon(CupertinoIcons.chat_bubble_2, color: AppPalette.blackColor, size: 50,),
            Text("Unable to complete the request.", style: TextStyle(fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
            Text('Please try again later.', style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),
            IconButton(onPressed: () {
               context.read<FetchChatBarberlebelBloc>().add(FetchChatLebelBarberRequst());
            }, icon: Icon(Icons.refresh_rounded))
          ],
        ),
      );
      }
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
                barberId: '',
              );
            },
          ),
        );
    },
  );
}
