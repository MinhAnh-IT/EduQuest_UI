import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  bool _isLoading = false;
  bool _otpSent = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));
      
      setState(() {
        _isLoading = false;
        _otpSent = true;
      });
    }
  }

  void _goToOTPScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPVerificationScreen(username: _usernameController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.forgotPasswordTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.text,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: _otpSent ? _buildOTPSentView() : _buildResetPasswordForm(),
        ),
      ),
    );
  }

  Widget _buildResetPasswordForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          _buildHeader(),
          SizedBox(height: 50),
          CustomTextField(
            controller: _usernameController,
            labelText: 'Username',
            hintText: 'Enter your username',
            prefixIcon: Icons.person_outline,
            keyboardType: TextInputType.text,
            validator: Validators.validateUsername,
          ),
          SizedBox(height: 30),
          CustomButton(
            onPressed: _resetPassword,
            text: AppStrings.sendOTP,
            isLoading: _isLoading,
          ),
          SizedBox(height: 30),
          _buildLoginLink(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.lock_reset_outlined,
            size: 80,
            color: AppColors.primary,
          ),
          SizedBox(height: 20),
          Text(
            AppStrings.forgotPasswordTitle,
            style: AppStyles.headingStyle,
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              AppStrings.enterUsername,
              textAlign: TextAlign.center,
              style: AppStyles.bodyStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.rememberPassword,
          style: TextStyle(color: AppColors.textLight),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            AppStrings.backToLogin,
            style: AppStyles.linkStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildOTPSentView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 50),
        _buildSuccessIcon(),
        SizedBox(height: 30),
        _buildSuccessMessage(),
        SizedBox(height: 40),
        CustomButton(
          onPressed: _goToOTPScreen,
          text: 'Enter OTP',
        ),
      ],
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green[50],
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.sms_outlined,
        size: 60,
        color: AppColors.success,
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Column(
      children: [
        Text(
          'OTP Sent!',
          style: AppStyles.headingStyle,
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'An OTP has been sent to verify your username.',
            textAlign: TextAlign.center,
            style: AppStyles.bodyStyle,
          ),
        ),
      ],
    );
  }
}
