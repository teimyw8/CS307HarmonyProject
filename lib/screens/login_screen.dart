import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/helpers/field_validators.dart';
import 'package:harmony_app/helpers/text_styles.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_button.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_loader.dart';
import 'package:harmony_app/widgets/common_widgets/custom_text_field.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthProvider _authProvider =
      Provider.of<AuthProvider>(Get.context!, listen: false);

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0), () {
      _authProvider.initializeLoginScreenVariables();
    });
    super.initState();
  }

  @override
  void dispose() {
    Future.delayed(Duration(seconds: 0), () {
      _authProvider.disposeLoginScreenVariables();
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
        builder:
            (BuildContext context, AuthProvider myAuthProvider, Widget? child) {
          return LoadingOverlay(
            isLoading: myAuthProvider.isLoading,
            progressIndicator: const CustomAppLoader(),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: AppColors.white,
              body: Stack(
                children: [
                  Scaffold(
                    backgroundColor: AppColors.white,
                    body: Align(
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                            horizontal: 60.w, vertical: 20.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Harmony",
                              style: AppTextStyles.largeTitle(),
                            ),
                            SizedBox(
                              height: 50.h,
                            ),
                            Form(
                              key: myAuthProvider.loginKey,
                              child: Column(
                                children: [
                                  CustomTextField(
                                    hintText: "Email",
                                    controller: myAuthProvider
                                        .loginEmailTextEditingController,
                                    hintStyle: AppTextStyles.hintTextField(),
                                    style: AppTextStyles.textField(),
                                    inputType: TextInputType.emailAddress,
                                    validator: FieldValidator.validateEmail,
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  CustomTextField(
                                    hintText: "Password",
                                    controller: myAuthProvider
                                        .loginPasswordTextEditingController,
                                    isPassword: true,
                                    isTextObscure: true,
                                    hintStyle: AppTextStyles.hintTextField(),
                                    style: AppTextStyles.textField(),
                                    inputType: TextInputType.text,
                                    validator: FieldValidator.validateRegularField,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _authProvider.onForgotPasswordTextClicked();
                                  },
                                  child: Text(
                                    "Forgot password?",
                                    style: AppTextStyles.subNote(),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 50.h,
                            ),
                            Container(
                              width: double.infinity,
                              height: 52.h,
                              child: CustomAppButton(
                                onTap: () {
                                  _authProvider.loginUser();
                                },
                                buttonColor: AppColors.green,
                                widget: Text(
                                  "Log In",
                                  style: AppTextStyles.button(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "New to Harmony? ",
                            style: AppTextStyles.footNote()
                                .copyWith(color: AppColors.black),
                          ),
                          GestureDetector(
                              onTap: () {
                                _authProvider.onSignUpTextClicked();
                              },
                              child: Text(
                                "Sign Up",
                                style: AppTextStyles.footNote(),
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
