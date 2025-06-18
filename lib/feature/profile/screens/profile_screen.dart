import 'package:flutter/material.dart';
import '../../auth/screens/login_screen.dart';
import '../../auth/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue[100],
              child: const Icon(Icons.person, size: 60, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            const Text(
              'Người dùng',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'admin@example.com',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            _buildProfileOption(
              icon: Icons.edit,
              title: 'Chỉnh sửa hồ sơ',
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.security,
              title: 'Bảo mật',
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.help,
              title: 'Trợ giúp',
              onTap: () {},
            ),
            const Spacer(),
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
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
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
                ElevatedButton(                  onPressed: isLoading ? null : () async {
                    setState(() {
                      isLoading = true;
                    });
                    
                    final navigator = Navigator.of(context);
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    
                    try {
                      final response = await _authService.logout();
                      final success = response['code'] == 200;
                      
                      // Navigate to login screen regardless of API response
                      // since we want to log out the user from the app
                      if (mounted) {
                        navigator.pop(); // Close dialog
                        navigator.pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                        
                        // Show success/error message
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
                      // Even if API fails, we still want to log out locally
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
