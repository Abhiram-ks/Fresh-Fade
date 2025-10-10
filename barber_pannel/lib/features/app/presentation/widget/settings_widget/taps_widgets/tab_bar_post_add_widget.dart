import 'package:barber_pannel/core/common/custom_testfiled.dart';
import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/core/validation/validation_helper.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabbarAddPost extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final ScrollController scrollController;
  const TabbarAddPost({
    required this.scrollController,
    required this.screenWidth,
    required this.screenHeight,
    super.key,
  });

  @override
  State<TabbarAddPost> createState() => _TabbarAddPostState();
}

class _TabbarAddPostState extends State<TabbarAddPost> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.screenWidth > 600 ? widget.screenWidth *.15 :  widget.screenWidth * .05),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
            children: [
              ConstantWidgets.hight30(context),
              InkWell(
                onTap: () {
                  //context.read<ImagePickerBloc>().add(PickImageAction());
                },
                child: DottedBorder(
                  color: AppPalette.greyColor,
                  strokeWidth: 1,
                  dashPattern: [4, 4],
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  child: SizedBox(
                      width: widget.screenWidth * 0.9,
                      height: widget.screenHeight * 0.23,
                      child:
                       SizedBox(
                          width: widget.screenWidth * 0.89,
                          height: widget.screenHeight * 0.22,
                          child: Center(
                            child: Text("Add Post"),
                          )
                          // BlocBuilder<ImagePickerBloc, ImagePickerState>(
                          //   builder: (context, state) {
                          //     if (state is ImagePickerLoading) {
                          //       return const CupertinoActivityIndicator(
                          //         radius: 16.0,
                          //       );
                          //     } else if (state is ImagePickerSuccess) {
                          //        return buildImagePreview(state: state,screenWidth: widget.screenWidth * 0.89,screenHeight:widget.screenHeight * 0.22,radius: 12);
                          //     } else if (state is ImagePickerError) {
                          //       return Column(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           crossAxisAlignment: CrossAxisAlignment.center,
                          //           children: [
                          //             Icon(
                          //               CupertinoIcons.photo,
                          //               size: 35,
                          //               color: AppPalette.redClr,
                          //             ),
                          //             Text(state.errorMessage)
                          //           ]);
                          //     }
                          //     return Column(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: [
                          //         Icon(
                          //           CupertinoIcons.cloud_upload,
                          //           size: 35,
                          //           color: AppPalette.buttonClr,
                          //         ),
                          //         Text('Upload an Image')
                          //       ],
                          //     );
                          //   },
                          // )
                          // )
                          ),
                  )
                ),
              ),
              ConstantWidgets.hight20(context),
              Focus(
                  onFocusChange: (hasFocus) {
                    widget.scrollController.animateTo(widget.screenHeight * 0.3,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
                  child: TextFormFieldWidget(
                      label: 'Description *',
                      hintText: 'Write a valuable description that reflects professionalism and creates a strong, engaging post with impactful words.',
                      prefixIcon: Icons.add_photo_alternate_outlined,
                      controller: _descriptionController,
                      minLines: 5,
                      maxLines: 5,
                      validate: ValidatorHelper.validateText)),
              ConstantWidgets.hight10(context),
                // BlocListener<UploadPostBloc, UploadPostState>(
                //   listener: (context, state) {
                //    handlePostStateHelper(context, state, _descriptionController);
                //   },
                //   child: ActionButton(
                //       screenWidth: widget.screenWidth,
                //       onTap: () {
                //         final imageState = context.read<ImagePickerBloc>().state;
                //         if (imageState is ImagePickerSuccess) {
                //           if(_descriptionController.text.isNotEmpty){
                //           context.read<UploadPostBloc>().add(
                //             UploadPostEventRequst(
                //               barberId: widget.barberId, 
                //               imageUrl: imageState.imagePath ?? '', 
                //               imageBytes: kIsWeb ? imageState.imageBytes : null,
                //               description: _descriptionController.text)
                //           );
                //           } else {
                //             CustomeSnackBar.show(context: context, title: 'Missing Description',
                //           description: 'Enter a description before uploading the post. Try again!.',titleClr: AppPalette.redClr);
                //           }
                //         } else {
                //          CustomeSnackBar.show(
                //          context: context,
                //          title: 'Image Required',
                //          description: 'Please select an image and complete all required fields before uploading your post.',
                //          titleClr: AppPalette.redClr,
                //           );
        
                //         }
                //       },
                //       label: 'Upload',
                //       screenHight: widget.screenHeight),
                // )
            ],
          ),
      ),
    );
  }
}
