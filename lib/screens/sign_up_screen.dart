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
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthProvider _authProvider =
      Provider.of<AuthProvider>(Get.context!, listen: false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(
          title: "Sign Up",
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
                    key: myAuthProvider.signUpKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          hintText: "Email",
                          hintStyle: AppTextStyles.hintTextField(),
                          style: AppTextStyles.textField(),
                          inputType: TextInputType.emailAddress,
                          validator: FieldValidator.validateEmail,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        CustomTextField(
                          hintText: "First Name",
                          hintStyle: AppTextStyles.hintTextField(),
                          style: AppTextStyles.textField(),
                          inputType: TextInputType.name,
                          validator: FieldValidator.validateEmail,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        CustomTextField(
                          hintText: "Last Name",
                          hintStyle: AppTextStyles.hintTextField(),
                          style: AppTextStyles.textField(),
                          inputType: TextInputType.name,
                          validator: FieldValidator.validateEmail,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        CustomTextField(
                          hintText: "Password",
                          isPassword: true,
                          isTextObscure: true,
                          hintStyle: AppTextStyles.hintTextField(),
                          style: AppTextStyles.textField(),
                          inputType: TextInputType.text,
                          validator: FieldValidator.validatePassword,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        CustomTextField(
                          hintText: "Re-enter Password",
                          isPassword: true,
                          isTextObscure: true,
                          hintStyle: AppTextStyles.hintTextField(),
                          style: AppTextStyles.textField(),
                          inputType: TextInputType.text,
                          validator: FieldValidator.validatePassword,
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
                    _authProvider.loginUser();
                  },
                  buttonColor: AppColors.green,
                  widget: Text(
                    "Sign Up",
                    style: AppTextStyles.button(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
