// ... existing code ...
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_quest/feature/Profile/providers/profile_provider.dart';
import 'package:edu_quest/feature/Profile/screens/profile_edit_screen.dart';
import 'package:edu_quest/shared/theme/app_theme.dart';
import 'package:edu_quest/feature/auth/services/auth_service.dart';
import 'package:edu_quest/feature/auth/screens/login_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadProfile();
    });
  }

  // ... existing import ...
// ... existing class ProfileScreen ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ cá nhân'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (profileProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Có lỗi xảy ra: ${profileProvider.error}',
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => profileProvider.loadProfile(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }
          final profile = profileProvider.profile;
          if (profile == null) {
            return const Center(child: Text('Không tìm thấy thông tin hồ sơ'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.primaryColor,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: profile.avatarUrl != null
                          ? Image.network(
                        'http://192.168.1.15:8080${profile.avatarUrl}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.person, size: 60, color: Colors.grey),
                        ),
                      )
                          : Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.person, size: 60, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                // Name (giữ lại)
                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                // Card thông tin chi tiết
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    child: Column(
                      children: [
                        _buildInfoRow('Họ và tên', profile.name),
                        const Divider(height: 28),
                        _buildInfoRow('Email', profile.email ?? 'Chưa cập nhật'),
                        if (profile.studentCode != null) ...[
                          const Divider(height: 28),
                          _buildInfoRow('Mã số sinh viên', profile.studentCode!),
                        ],
                        const Divider(height: 28),
                        _buildInfoRow('Vai trò', _getRoleText(profile.role)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Nút chỉnh sửa
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileEditScreen()),
                      ).then((_) => profileProvider.loadProfile());
                    },
                    icon: const Icon(Icons.edit, size: 20),
                    label: const Text(
                      'Chỉnh sửa hồ sơ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showLogoutDialog(context);
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Đăng xuất'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getRoleText(dynamic role) {
    switch (role.toString()) {
      case 'UserRole.STUDENT':
        return 'Sinh viên';
      case 'UserRole.INSTRUCTOR':
        return 'Giảng viên';
      default:
        return 'Không xác định';
    }
  }
  void _showLogoutDialog(BuildContext context) {
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Đăng xuất'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Bạn có chắc chắn muốn đăng xuất không?'),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: isLoading ? null : () async {
                    setState(() {
                      isLoading = true;
                    });

                    final navigator = Navigator.of(context);
                    final scaffoldMessenger = ScaffoldMessenger.of(context);

                    try {
                      final response = await _authService.logout();
                      final success = response['code'] == 200;

                      if (mounted) {
                        navigator.pop(); // Close dialog
                        navigator.pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                              (route) => false,
                        );

                        if (success) {
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                              content: Text('Đăng xuất thành công'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                              content: Text('Đã đăng xuất khỏi ứng dụng'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (mounted) {
                        navigator.pop(); // Close dialog
                        navigator.pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                              (route) => false,
                        );

                        scaffoldMessenger.showSnackBar(
                          const SnackBar(
                            content: Text('Đã đăng xuất khỏi ứng dụng'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Đăng xuất'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}