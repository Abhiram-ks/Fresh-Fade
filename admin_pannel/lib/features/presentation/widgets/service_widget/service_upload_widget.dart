
import 'package:admin_pannel/core/common/custom_button.dart';
import 'package:admin_pannel/core/common/custom_testfiled.dart';
import 'package:admin_pannel/features/presentation/state/bloc/fetch_service_bloc/fetch_service_bloc.dart';
import 'package:admin_pannel/features/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/custom_snackbar.dart';
import '../../../../core/constant/constant.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/validation/validation_helper.dart';
import '../../state/bloc/service_manage_bloc/service_manage_bloc.dart';
import 'service_builder_widget.dart';

class UploadServicesWidget extends StatefulWidget {
  final double screenHight;
  final double screenWidth;
  const UploadServicesWidget({
    super.key,
    required this.screenHight,
    required this.screenWidth,
  });

  @override
  State<UploadServicesWidget> createState() => _UploadServicesWidgetState();
}

class _UploadServicesWidgetState extends State<UploadServicesWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchingServiceBloc>().add(FetchServiceDataEvent());
    });
  }

  final TextEditingController _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        ConstantWidgets.hight20(context),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormFieldWidget(
                label: 'Upload new service',
                hintText: 'Enter new service data',
                prefixIcon: CupertinoIcons.cloud_upload,
                controller: _textController,
                validate: ValidatorHelper.validateText,
              ),
              CustomButton(
                onPressed: () async {
                  final buttonCubit = context.read<ProgresserCubit>();
                  if (_formKey.currentState!.validate()) {
                    buttonCubit.startLoading();
                    context.read<ServiceMangementBloc>().add(
                      UploadNewServiceEvent(
                        serviceName: _textController.text.trim(),
                      ),
                    );
                    await Future.delayed(const Duration(milliseconds: 1800));
                    buttonCubit.stopLoading();
                    _textController.clear();
                  } else {
                    CustomSnackBar.show(
                      message:
                          'Service data not found. Oops! Please enter the required service details.',
                      backgroundColor: AppPalette.redColor,
                      context,
                      textAlign: TextAlign.center,
                    );
                  }
                },
                text: 'Upload',
              ),
              ConstantWidgets.hight30(context),
              ServiceBuilderWidget(widget: widget),
            ],
          ),
        ),
      ],
    );
  }
}