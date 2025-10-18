import 'package:client_pannel/core/common/custom_testfiled.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/constant.dart';
import '../../../../../core/debouncer/debouncer.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/validation/validator_helper.dart';

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
    _debouncer = Debouncer(milliseconds: 50);
//    context.read<FetchChatBarberlebelBloc>().add(FetchChatLebelBarberRequst());
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
              fillClr: AppPalette.whiteColor,
              suffixIconData: Icons.clear,
              suffixIconColor: AppPalette.greyColor,
              suffixIconAction: () {
                _searchController.clear();
              },
              onChanged: (value) {
                _debouncer.run(() {
                });
              },
            ),
            ConstantWidgets.hight10(context),
           // chatTailBuilderWidget(context,widget.screenWidth, widget.screenHeight),
          ],
        ),
      ),
    );
  }

}