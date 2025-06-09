import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../providers/auth_provider.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

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
    print('Starting password reset process');
    if (!_formKey.currentState!.validate()) {
      print('Form validation failed');
      return;
    }

    setState(() {
      _isLoading = true;
      print('Set loading state to true');
    });

    try {
      print('Calling requestPasswordReset with username: ${_usernameController.text}');
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await authProvider.requestPasswordReset(_usernameController.text);
      print('Got response from API: ${response.status}, ${response.message}');

      if (!mounted) {
        print('Widget not mounted after API call');
        return;
      }

      // API response status is '200' (String) not 'SUCCESS' (String)
      // Convert to string and check for '200' or 'SUCCESS' for flexibility
      final String apiStatus = response.status.toString().toUpperCase();

      switch (apiStatus) {
        case '200': // Check for '200' which is returned by the API
        case 'SUCCESS': // Keep 'SUCCESS' for potential future API changes
          print('API call successful, navigating to OTP screen');
          setState(() => _otpSent = true);
          // _goToOTPScreen(); // Navigation is handled by the _otpSent state change in build()
          break;
        case 'USER_NOT_FOUND':
          print('API returned user not found');
          _showError('User not found');
          break;
        case 'EMAIL_SEND_FAILED':
          print('API returned email send failed');
          _showError('Failed to send OTP email');
          break;
        default:
          print('API returned unexpected status: ${response.status}');
          _showError(response.message);
      }
    } catch (e, stackTrace) {
      print('Error occurred during password reset: $e');
      print('Stack trace: $stackTrace');
      if (!mounted) return;
      _showError('Network error occurred. Please check your connection and try again.');
    } finally {
      print('Cleaning up after password reset attempt');
      if (mounted) {
        setState(() {
          _isLoading = false;
          print('Set loading state to false');
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(AppStrings.forgotPasswordTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey[800],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
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
          const SizedBox(height: 20),
          _buildHeader(),
          const SizedBox(height: 50),
          CustomTextField(
            controller: _usernameController,
            labelText: 'Username',
            hintText: 'Enter your username',
            prefixIcon: Icons.person_outline,
            keyboardType: TextInputType.text,
            validator: Validators.validateUsername,
          ),
          const SizedBox(height: 30),
          CustomButton(
            onPressed: _isLoading ? null : _resetPassword,
            text: AppStrings.sendOTP,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 30),
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
            color: Colors.blue,
          ),
          const SizedBox(height: 20),
          const Text(
            AppStrings.forgotPasswordTitle,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              AppStrings.enterUsername,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
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
          style: TextStyle(color: Colors.grey[600]),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            AppStrings.backToLogin,
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOTPSentView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 50),
        _buildSuccessIcon(),
        const SizedBox(height: 30),
        _buildSuccessMessage(),
        const SizedBox(height: 40),
        CustomButton(
          onPressed: _goToOTPScreen,
          text: 'Enter OTP',
        ),
      ],
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green[50],
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.sms_outlined,
        size: 60,
        color: Colors.green,
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Column(
      children: [
        const Text(
          'OTP Sent!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'An OTP has been sent to verify your username.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
