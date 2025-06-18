import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_quest/feature/auth/providers/auth_provider.dart';
import 'package:edu_quest/shared/theme/app_theme.dart';
import 'package:edu_quest/shared/widgets/otp_input.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final Map<String, dynamic> registrationData;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.registrationData,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  final _otpController = TextEditingController();
  bool _isResending = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _sendOTP();
    _animationController.forward();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.resendOTP(widget.email);
  }

  Future<void> _verifyOTP() async {
    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đủ 6 số')),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success =
        await authProvider.verifyOTP(widget.email, _otpController.text);

    if (success && mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/student-details',
        arguments: widget.registrationData,
      );
    }
  }

  Future<void> _resendOTP() async {
    setState(() {
      _isResending = true;
    });

    await _sendOTP();

    setState(() {
      _isResending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
          ),
        ),
        child: SafeArea(
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              return FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const Icon(Icons.mark_email_read_outlined,
                        size: 80, color: Colors.white),
                    const SizedBox(height: 24),
                    const Text(
                      'Xác thực email của bạn',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Chúng tôi đã gửi mã OTP đến\n${widget.email}',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 32),
                            OtpInput(
                              controller: _otpController,
                              onCompleted: (pin) => _verifyOTP(),
                            ),
                            if (authProvider.error != null) ...[
                              const SizedBox(height: 16),
                              Text(
                                authProvider.error!,
                                style:
                                    const TextStyle(color: AppTheme.errorColor),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _verifyOTP,
                                child: const Text('Xác nhận'),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton.icon(
                              onPressed: _isResending ? null : _resendOTP,
                              icon: _isResending
                                  ? Container(
                                      width: 20,
                                      height: 20,
                                      margin: const EdgeInsets.only(right: 8),
                                      child: const CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  : const Icon(Icons.refresh),
                              label: Text(_isResending
                                  ? 'Đang gửi lại...'
                                  : 'Gửi lại mã'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
