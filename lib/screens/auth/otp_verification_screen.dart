import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import 'reset_password_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String username;

  const OTPVerificationScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _controllers = 
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = 
      List.generate(6, (index) => FocusNode());
  
  bool _isLoading = false;
  int _countdown = 60;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((node) => node.dispose());
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _canResend = false;
    _countdown = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  Future<void> _resendOTP() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('OTP has been resent!'),
        backgroundColor: AppColors.success,
      ),
    );

    _startCountdown();
  }

  Future<void> _verifyOTP() async {
    final otp = _controllers.map((c) => c.text).join();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter the complete OTP'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate OTP verification
    await Future.delayed(Duration(seconds: 2));

    setState(() => _isLoading = false);

    // Navigate to reset password screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResetPasswordScreen(username: widget.username),
      ),
    );
  }

  void _onOTPDigitChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    if (index == 5 && value.isNotEmpty) {
      final otp = _controllers.map((c) => c.text).join();
      if (otp.length == 6) _verifyOTP();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.otpVerificationTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.text,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              _buildHeader(),
              SizedBox(height: 50),
              _buildOTPFields(),
              SizedBox(height: 40),
              _buildVerifyButton(),
              SizedBox(height: 30),
              _buildResendOption(),
              SizedBox(height: 20),
              _buildChangeUsernameLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.security_outlined,
            size: 80,
            color: AppColors.primary,
          ),
          SizedBox(height: 20),
          Text(
            AppStrings.enterVerificationCode,
            style: AppStyles.headingStyle,
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  AppStrings.enterOTPMessage,
                  textAlign: TextAlign.center,
                  style: AppStyles.bodyStyle,
                ),
                SizedBox(height: 4),
                Text(
                  widget.username,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOTPFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        6,
        (index) => SizedBox(
          width: 45,
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            onChanged: (value) => _onOTPDigitChanged(value, index),
            style: TextStyle(fontSize: 24),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 12),
              fillColor: Colors.white,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return CustomButton(
      onPressed: _verifyOTP,
      text: AppStrings.verifyOTP,
      isLoading: _isLoading,
    );
  }

  Widget _buildResendOption() {
    return Column(
      children: [
        Text(
          AppStrings.didntReceiveCode,
          style: AppStyles.bodyStyle,
        ),
        if (_canResend)
          TextButton(
            onPressed: _resendOTP,
            child: Text(
              AppStrings.resendOTP,
              style: AppStyles.linkStyle,
            ),
          )
        else
          Text(
            '${AppStrings.resendCodeTimer}$_countdown',
            style: TextStyle(
              color: AppColors.textLight,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  Widget _buildChangeUsernameLink() {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text(
        AppStrings.changeUsername,
        style: AppStyles.linkStyle,
      ),
    );
  }
}
