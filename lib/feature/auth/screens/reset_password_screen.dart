import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/validators.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../providers/auth_provider.dart';

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
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final success = await authProvider.resetPassword(
            widget.username, _passwordController.text);

        if (!mounted) return;

        if (success) {
          _showSuccessDialog();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.error ?? 'Đặt lại mật khẩu thất bại'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể đặt lại mật khẩu: ${e.toString()}'),
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
        title: const Text(AppStrings.resetPasswordTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.text,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 50),
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
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Xác nhận lại mật khẩu',
                  hintText: 'Nhập lại mật khẩu mới của bạn',
                  prefixIcon: Icons.lock_outlined,
                  obscureText: !_showConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
                      });
                    },
                  ),
                  validator: (value) => Validators.validateConfirmPassword(
                      value, _passwordController.text),
                ),
                const SizedBox(height: 40),
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
      child: const Column(
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.check_circle,
              color: AppColors.success,
            ),
            SizedBox(width: 8),
            Text('Thành công'),
          ],
        ),
        content: const Text('Mật khẩu của bạn đã được đặt lại thành công.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text('Quay lại đăng nhập'),
          ),
        ],
      ),
    );
  }
}
