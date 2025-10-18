
import 'package:client_pannel/core/themes/app_colors.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/image_picker_bloc/image_picker_bloc.dart';
import 'package:client_pannel/features/auth/presentations/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';


class EmojiPickerCubit extends Cubit<bool> {
  EmojiPickerCubit() : super(false);

  void toggleEmoji() => emit(!state);
  void hideEmoji() => emit(false);
}

class ChatWindowTextFiled extends StatefulWidget {
  const ChatWindowTextFiled({
    super.key,
    required this.controller,
    required this.sendButton,
    this.icon,
    this.isICon = true,
  });

  final TextEditingController controller;
  final VoidCallback sendButton;
  final bool isICon;
  final IconData? icon;

  @override
  State<ChatWindowTextFiled> createState() => _ChatWindowTextFiledState();
}

class _ChatWindowTextFiledState extends State<ChatWindowTextFiled> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        context.read<EmojiPickerCubit>().hideEmoji();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          color: AppPalette.whiteColor,
          child: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      prefixIcon: widget.isICon
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
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: widget.sendButton,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppPalette.buttonColor,
                      shape: BoxShape.circle,
                    ),
                    child: BlocBuilder<ProgresserCubit, ProgresserState>(
                      builder: (context, state) {
                        if (state is MessageSendLoading) {
                          return const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: AppPalette.whiteColor,
                              strokeWidth: 2.5,
                            ),
                          );
                        }
                        return const Icon(Icons.send, color: AppPalette.whiteColor, size: 20);
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
      textEditingController: widget.controller,
      onEmojiSelected: (category, emoji) {
        final text = widget.controller.text;
        final selection = widget.controller.selection;
        final newText = text.replaceRange(
          selection.start,
          selection.end,
          emoji.emoji,
        );
        final emojiLength = emoji.emoji.length;
        widget.controller.text = newText;
        widget.controller.selection = selection.copyWith(
          baseOffset: selection.start + emojiLength,
          extentOffset: selection.start + emojiLength,
        );
      },
      onBackspacePressed: () {
        final text = widget.controller.text;
        final selection = widget.controller.selection;

        if (selection.start == 0 && selection.end == 0) {
          return;
        }

        int start = selection.start;
        int end = selection.end;

        if (start == end) {
          final characters = text.characters;
          final before = characters.take(start - 1).toString();
          final after = characters.skip(end).toString();
          widget.controller.text = before + after;
          final newOffset = start - 1;
          widget.controller.selection = TextSelection.fromPosition(TextPosition(offset: newOffset));
        } else {
          final before = text.substring(0, start);
          final after = text.substring(end);
          widget.controller.text = before + after;
          widget.controller.selection = TextSelection.fromPosition(TextPosition(offset: start));
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
