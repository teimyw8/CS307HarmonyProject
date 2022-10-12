import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/helpers/field_validators.dart';
import 'package:harmony_app/helpers/text_styles.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_button.dart';
import 'package:harmony_app/widgets/common_widgets/custom_text_field.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

import '../widgets/common_widgets/custom_app_loader.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AuthProvider _authProvider =
      Provider.of<AuthProvider>(Get.context!, listen: false);

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0), () {
      _authProvider.initializeForgotPasswordScreenVariables();
    });
    super.initState();
  }

  @override
  void dispose() {
    Future.delayed(Duration(seconds: 0), () {
      _authProvider.disposeForgotPasswordScreenVariables();
    });
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },

      child: Consumer<AuthProvider>(
        builder: (BuildContext context, AuthProvider myAuthProvider, Widget? child) {
        return LoadingOverlay(
          isLoading: myAuthProvider.isLoading,
          progressIndicator: const CustomAppLoader(),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: AppColors.white,
            appBar: CustomAppBar(
              isAuthAppBar: true,
              title: "Forgot Password",
              needBackArrow: true,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer<AuthProvider>(
                    builder: (BuildContext context, AuthProvider myAuthProvider,
                        Widget? child) {
                      return Form(
                        key: myAuthProvider.resetPasswordKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              "To reset password, enter your email address",
                              style: AppTextStyles.footNote(),
                            ),
                            CustomTextField(
                              hintText: "Email",
                              hintStyle: AppTextStyles.hintTextField(),
                              style: AppTextStyles.textField(),
                              inputType: TextInputType.emailAddress,
                              validator: FieldValidator.validateEmail,
                              controller: _authProvider.forgotPasswordEmailTextEditingController,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  Container(
                    width: double.infinity,
                    height: 52.h,
                    child: CustomAppButton(
                      onTap: () {
                        _authProvider.onResetPasswordClicked();
                      },
                      buttonColor: AppColors.green,
                      widget: Text(
                        "Reset",
                        style: AppTextStyles.button(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        },
      ),
    );
  }
}
