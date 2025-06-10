import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/utils/constants.dart';
import '../../../../shared/utils/validators.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../providers/auth_provider.dart';
import '../../../../core/enums/status_code.dart'; // Import StatusCode

class ResetPasswordScreen extends StatefulWidget {
  final String username;
  final String otp;

  const ResetPasswordScreen({
    Key? key, 
    required this.username,
    required this.otp,
  }) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final response = await Provider.of<AuthProvider>(context, listen: false)
            .resetPassword(
              widget.username, 
              _passwordController.text
            );

        if (!mounted) return;
        
        switch (response.status) {
          case StatusCode.OK: // Assuming 200 OK for password reset
          case StatusCode.PASSWORD_RESET_SUCCESS:
            _showSuccessDialog();
            break;
          case StatusCode.OTP_VERIFICATION_NEEDED: // Handle if OTP wasn't verified or expired
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(response.message), // Use message from response
                backgroundColor: Colors.red,
              ),
            );
            // Optionally, navigate back to OTP screen or show a specific message
            // For example, navigate back to login or OTP screen if appropriate
            // Navigator.popUntil(context, (route) => route.isFirst); 
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(response.message), // Show the message from the response
                backgroundColor: Colors.red,
              ),
            );
        }
      } catch (e) {
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reset password: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.resetPasswordTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.text,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                _buildHeader(),
                SizedBox(height: 50),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Mật khẩu mới',
                  hintText: 'Nhập mật khẩu mới',
                  prefixIcon: Icons.lock_outlined,
                  obscureText: !_showPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                  validator: Validators.validatePassword,
                ),
                SizedBox(height: 20),
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Xác nhận lại mật khẩu',
                  hintText: 'Nhập lại mật khẩu mới của bạn',
                  prefixIcon: Icons.lock_outlined,
                  obscureText: !_showConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
                      });
                    },
                  ),
                  validator: (value) => Validators.validateConfirmPassword(value, _passwordController.text),
                ),
                SizedBox(height: 20),
                _buildPasswordRequirements(),
                SizedBox(height: 40),
                CustomButton(
                  onPressed: _resetPassword,
                  text: AppStrings.resetPasswordTitle,
                  isLoading: _isLoading,
                ),
              ],
            ),
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
            Icons.lock_outline,
            size: 80,
            color: AppColors.primary,
          ),
          SizedBox(height: 20),
          Text(
            AppStrings.createNewPassword,
            style: AppStyles.headingStyle,
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              AppStrings.newPasswordHint,
              textAlign: TextAlign.center,
              style: AppStyles.bodyStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.passwordRequirements,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          SizedBox(height: 12),
          _buildRequirementItem(
            'At least 8 characters',
            _passwordController.text.length >= 8,
          ),
          _buildRequirementItem(
            'Contains uppercase letter',
            _passwordController.text.contains(RegExp(r'[A-Z]')),
          ),
          _buildRequirementItem(
            'Contains number',
            _passwordController.text.contains(RegExp(r'[0-9]')),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text, bool isMet) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.check_circle_outline,
            color: isMet ? AppColors.success : Colors.grey[400],
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isMet ? AppColors.text : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: AppColors.success,
            ),
            SizedBox(width: 8),
            Text('Success'),
          ],
        ),
        content: Text('Your password has been reset successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: Text('Back to Login'),
          ),
        ],
      ),
    );
  }
}

