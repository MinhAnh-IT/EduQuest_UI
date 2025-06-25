import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../feature/auth/providers/auth_provider.dart';
import '../../../../shared/widgets/otp_input.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String username;

  final Map<String, dynamic> registrationData;
  final bool autoSendOtp;

  const OtpVerificationScreen({
    super.key,
    required this.username,
    required this.registrationData,
    this.autoSendOtp = false,
  });
  static OtpVerificationScreen fromRouteSettings(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>;
    return OtpVerificationScreen(
      username: args['username'],
      registrationData: args['registrationData'] ?? {},
      autoSendOtp: args['autoSendOtp'] ?? false,
    );
  }

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
    if (widget.autoSendOtp) {
      _resendOTP();
    }
    _animationController.forward();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _verifyOTP() async {

    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Vui lòng nhập đủ 6 số',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }

    try {
      final authProvider = context.read<AuthProvider>();
      authProvider.clearError();
      final success = await authProvider.verifyOTP(widget.username, _otpController.text);

      if (success) {
        Navigator.pushNamed(
          context,
          '/student-details',
          arguments: widget.registrationData,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Xác minh OTP thất bại. Vui lòng thử lại!',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red, // <-- ĐẶT MÀU NỀN SNACKBAR LÀ MÀU ĐỎ
          content: Text(
            'Lỗi: ${e.toString().replaceAll('Exception: ', '')}. Vui lòng thử lại sau!', // Thêm replaceAll để làm sạch thông báo lỗi Exception:
            style: const TextStyle(color: Colors.white), // <-- ĐẶT MÀU CHỮ LÀ MÀU TRẮNG
          ),
        ),
      );
      print('Error during OTP verification: $e'); // Log lỗi để debug
    }
  }

  Future<void> _resendOTP() async {
    setState(() {
      _isResending = true;
    });
    try {
      final authProvider = context.read<AuthProvider>();
      await authProvider.resendOTP(widget.username);  // Dùng username để resend
    } finally {
      setState(() {
        _isResending = false;
      });
    }
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
                        'Chúng tôi đã gửi mã OTP đến\n${widget.username}',
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
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
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
