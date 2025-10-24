
import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import '../../features/app/presentation/state/bloc/image_picker_bloc/image_picker_bloc.dart';
import '../../features/auth/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';


class EmojiPickerCubit extends Cubit<bool> {
  EmojiPickerCubit() : super(false);

  void toggleEmoji() => emit(!state);
  void hideEmoji() => emit(false);
}

class ChatWindowTextFiled extends StatelessWidget {
  const ChatWindowTextFiled({
    super.key,
    required TextEditingController controller,
    required this.sendButton,
    this.icon,
    this.isICon = true,
  }) : _controller = controller;

  final TextEditingController _controller;
  final VoidCallback sendButton;
  final bool isICon;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        context.read<EmojiPickerCubit>().hideEmoji();
      }
    });

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: AppPalette.whiteColor,
            boxShadow: [
              BoxShadow(
                color: AppPalette.blackColor.withValues(alpha: 0.1),
                offset: const Offset(0, -2),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      prefixIcon: isICon
                          ? IconButton(
                              icon: const Icon(Icons.attach_file),
                              onPressed: () {
                                context.read<ImagePickerBloc>().add(PickImageAction());
                              },
                            )
                          : IconButton(
                              icon: const Icon(CupertinoIcons.smiley_fill),
                              onPressed: () {
                                FocusScope.of(context).unfocus(); 
                                context.read<EmojiPickerCubit>().toggleEmoji(); 
                              },
                            ),
                    ),
                    textInputAction: TextInputAction.send,
                  ),
                ),
                ConstantWidgets.width20(context),
                GestureDetector(
                  onTap: sendButton,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppPalette.buttonColor,
                      shape: BoxShape.circle,
                    ),
                    child: BlocBuilder<ProgresserCubit, ProgresserState>(
                      builder: (context, state) {
                        if (state is MessageSendLoading) {
                          return SizedBox(
                            height: 17,
                            width: 17,
                            child: CircularProgressIndicator(
                              backgroundColor: AppPalette.hintColor,
                              color: AppPalette.whiteColor,
                              strokeWidth: 2.5,
                            ),
                          );
                        }
                        return Icon(Icons.send, color: AppPalette.whiteColor);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        BlocBuilder<EmojiPickerCubit, bool>(
          builder: (context, showEmoji) {
            return Offstage(
  offstage: !showEmoji,
  child: ConstrainedBox(
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.4,
    ),
    child: EmojiPicker(
      textEditingController: _controller,
      onEmojiSelected: (category, emoji) {
        final text = _controller.text;
        final selection = _controller.selection;
        final newText = text.replaceRange(
          selection.start,
          selection.end,
          emoji.emoji,
        );
        final emojiLength = emoji.emoji.length;
        _controller.text = newText;
        _controller.selection = selection.copyWith(
          baseOffset: selection.start + emojiLength,
          extentOffset: selection.start + emojiLength,
        );
      },
      onBackspacePressed: () {
        final text = _controller.text;
        final selection = _controller.selection;

        if (selection.start == 0 && selection.end == 0) {
          return;
        }

        int start = selection.start;
        int end = selection.end;

        if (start == end) {
          final characters = text.characters;
          final before = characters.take(start - 1).toString();
          final after = characters.skip(end).toString();
          _controller.text = before + after;
          final newOffset = start - 1;
          _controller.selection = TextSelection.fromPosition(TextPosition(offset: newOffset));
        } else {
          final before = text.substring(0, start);
          final after = text.substring(end);
          _controller.text = before + after;
          _controller.selection = TextSelection.fromPosition(TextPosition(offset: start));
        }
      },
      config: Config(
        emojiViewConfig: const EmojiViewConfig(emojiSizeMax: 32),
        checkPlatformCompatibility: true,
        viewOrderConfig: const ViewOrderConfig(
          top: EmojiPickerItem.categoryBar,
          middle: EmojiPickerItem.emojiView,
          bottom: EmojiPickerItem.searchBar,
        ),
        categoryViewConfig: const CategoryViewConfig(
          iconColorSelected: AppPalette.orengeColor,
          indicatorColor: AppPalette.buttonColor,
        ),
        bottomActionBarConfig: const BottomActionBarConfig(
          backgroundColor: AppPalette.buttonColor,
          buttonColor: AppPalette.buttonColor,
          buttonIconColor: AppPalette.whiteColor,
          showBackspaceButton: true,
        ),
        searchViewConfig: const SearchViewConfig(
          hintText: 'Search emoji...',
        ),
        skinToneConfig: const SkinToneConfig(
          dialogBackgroundColor: AppPalette.buttonColor,
          indicatorColor: AppPalette.buttonColor,
        ),
      ),
    ),
  ),
);
          },
        ),
      ],
    );
  }
}
