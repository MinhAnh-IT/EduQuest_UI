import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:register_login/feature/auth/providers/auth_provider.dart';
import 'package:register_login/shared/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:register_login/shared/utils/constants.dart';

import '../../../../shared/utils/validators.dart';

class StudentDetailsScreen extends StatefulWidget {
  const StudentDetailsScreen({super.key});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _studentCodeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _studentCodeController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt(StorageConstants.tempUserId);

        if (userId == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Có lỗi xảy ra, vui lòng thử lại')),
            );
          }
          return;
        }

        final studentDetails = {
          'studentCode': _studentCodeController.text,
        };

        final authProvider = context.read<AuthProvider>();
        authProvider.clearError();
        final success = await authProvider.updateStudentDetails(userId, studentDetails);

        if (success) {
          // Xử lý thành công
          await prefs.remove(StorageConstants.tempUserId);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Hoàn tất đăng ký thành công!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushReplacementNamed(context, '/login');
          }
        } else {
          // Xử lý thất bại
          if (mounted) {
            String errorMsg = authProvider.error ?? 'Cập nhật thông tin thất bại';
            if (errorMsg.contains('already exists') || errorMsg.contains('Student code')) {
              errorMsg = 'Mã số sinh viên đã tồn tại!';
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMsg),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        // Xử lý lỗi
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Thông tin sinh viên'),
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
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Hoàn tất đăng ký',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Vui lòng nhập mã số sinh viên của bạn',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 30),
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _studentCodeController,
                          decoration: const InputDecoration(
                            labelText: 'Mã số sinh viên',
                            prefixIcon: Icon(Icons.numbers),
                            errorStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                            helperText: 'Mã số sinh viên phải từ 8 đến 20 số',
                            helperStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          keyboardType: TextInputType.number, // Chỉ hiện bàn phím số
                          validator: (value) => Validators.validateStudentCode(value),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleSubmit,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text('Hoàn tất đăng ký'),
                          ),
                        ),
                      ],
                    ),
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