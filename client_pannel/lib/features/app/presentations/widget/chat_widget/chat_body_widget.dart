import 'package:client_pannel/core/common/custom_testfiled.dart';
import 'package:client_pannel/features/app/presentations/widget/chat_widget/chat_tail_build_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constant/constant.dart';
import '../../../../../core/debouncer/debouncer.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/validation/validator_helper.dart';
import '../../state/bloc/fetch_bloc/fetch_chat_barber_leble_bloc/fetch_chat_barber_lebel_bloc.dart';

class ChatScreenBodyWidget extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;

  const ChatScreenBodyWidget(
      {super.key, required this.screenWidth, required this.screenHeight});

  @override
  State<ChatScreenBodyWidget> createState() => _ChatScreenBodyWidgetState();
}

class _ChatScreenBodyWidgetState extends State<ChatScreenBodyWidget> {
  late final Debouncer _debouncer;
  final TextEditingController _searchController = TextEditingController();

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

  void _handleSearch(String query) {
    if (query.isEmpty) {
      // Reset to show all chats
      context.read<FetchChatBarberlebelBloc>().add(FetchChatLebelBarberRequst());
    } else {
      // Trigger search with query
      context.read<FetchChatBarberlebelBloc>().add(
        FetchChatLebelBarberSearch(query),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * .04, vertical: widget.screenHeight * .02),
        child: Column(
          children: [
            TextFormFieldWidget(
              hintText: 'Search shop...',
              prefixIcon: Icons.search,
              controller: _searchController,
              validate: ValidatorHelper.serching,
              fillClr: const Color.fromARGB(255, 238, 239, 241),
              borderClr: const Color.fromARGB(255, 238, 239, 241),
              suffixIconData: Icons.clear,
              suffixIconColor: AppPalette.greyColor,
              suffixIconAction: () {
                _searchController.clear();
                _handleSearch(''); 
              },
              onChanged: (value) {
                _debouncer.run(() { 
                  _handleSearch(value);
                });
              },
            ),
            ConstantWidgets.hight10(context),
           chatTailBuilderWidget(context,widget.screenWidth, widget.screenHeight),
          ],
        ),
      ),
    );
  }

}