import 'package:flutter/material.dart';
import '../../../shared/widgets/bottom_navigation_bar.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../class/services/enrollment_service.dart';
import '../../../core/enums/status_code.dart';
import '../../class/screens/class_detail_screen.dart';
import 'package:edu_quest/feature/profile/screens/profile_screen.dart';

// import 'package:edu_quest/shared/theme/bottom_nav_bar_screen.dart'; // XÓA DÒNG NÀY nếu không cần
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeTab(),
    const ProfileScreen(), // Use ProfileScreen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final EnrollmentService _enrollmentService = EnrollmentService();
  List<Map<String, String>> _allClasses = [];
  List<Map<String, String>> _filteredClasses = [];
  bool _isSearching = false;
  bool _isLoading = false;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterClasses);
    _fetchMyClasses();
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterClasses);
    _searchController.dispose();
    super.dispose();
  }

  void _filterClasses() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredClasses = _allClasses;
      } else {
        _filteredClasses = _allClasses.where((classData) {
          final nameLower = classData['name']!.toLowerCase();
          final instructorLower = classData['instructor']!.toLowerCase();
          return nameLower.contains(query) || instructorLower.contains(query);
        }).toList();
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  Color _getCardColor(int index) {
    const List<Color> colors = [
      Color(0xFF4285F4), // Blue
      Color(0xFF34A853), // Green
      Color(0xFFFBBC05), // Yellow
      Color(0xFFEA4335), // Red
      Color(0xFF6D4C41), // Brown
    ];
    return colors[index % colors.length].withValues(alpha: 0.9);
  }

  void _handleClassTap(BuildContext context, Map<String, String> classData) {
    final status = classData['status']?.toUpperCase() ?? '';

    if (status == 'PENDING') {
      // Hiển thị thông báo cho lớp đang chờ duyệt
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Lớp học này đang chờ giáo viên phê duyệt. Bạn chưa thể truy cập chi tiết lớp.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      // Chuyển đến chi tiết lớp cho các lớp đã được duyệt
      _navigateToClassDetail(context, classData);
    }
  }
  void _navigateToClassDetail(      BuildContext context, Map<String, String> classData) {
    final classId = int.parse(classData['id'] ?? '1');
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassDetailScreen(
          classId: classId,
        ),
      ),
    );
  }
  
  void _showLeaveClassConfirmationDialog(
      BuildContext context, Map<String, String> classData) {
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Rời lớp học'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'Bạn có chắc chắn muốn rời lớp học "${classData['name']}" không?'),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          Navigator.of(dialogContext).pop();
                        },
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });

                          final navigator = Navigator.of(dialogContext);
                          final scaffoldMessenger =
                              ScaffoldMessenger.of(context);

                          try {
                            final classId = int.parse(classData['id']!);

                            final response =
                                await _enrollmentService.leaveClass(classId);

                            if (response.status == StatusCode.ok) {
                              navigator.pop();
                              if (mounted) {
                                scaffoldMessenger.showSnackBar(
                                  const SnackBar(
                                    content: Text('Đã rời lớp học thành công!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                              // Refresh the list from API
                              _fetchMyClasses();
                            } else {
                              navigator.pop();
                              String errorMessage;
                              switch (response.status) {
                                case StatusCode.authenticationRequired:
                                  errorMessage =
                                      'Bạn cần đăng nhập để rời lớp học';
                                  break;
                                case StatusCode.userNotAStudent:
                                  errorMessage =
                                      'Chỉ sinh viên mới có thể rời lớp học';
                                  break;
                                case StatusCode.classNotFoundById:
                                  errorMessage = 'Không tìm thấy lớp học này';
                                  break;
                                case StatusCode.studentNotEnrolledInClass:
                                  errorMessage =
                                      'Bạn chưa tham gia lớp học này';
                                  break;
                                default:
                                  errorMessage = response.message.isNotEmpty
                                      ? response.message
                                      : 'Không thể rời lớp học. Vui lòng thử lại sau.';
                              }
                              if (mounted) {
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text(errorMessage),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            navigator.pop();
                            if (mounted) {
                              scaffoldMessenger.showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Đã xảy ra lỗi kết nối. Vui lòng kiểm tra mạng và thử lại.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } finally {
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                  child: const Text('Rời lớp'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showJoinClassDialog(BuildContext context) {
    final TextEditingController classCodeController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Tham gia lớp học'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: classCodeController,
                    decoration: const InputDecoration(hintText: 'Nhập mã lớp'),
                    autofocus: true,
                    enabled: !isLoading,
                  ),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          String classCode = classCodeController.text.trim();

                          if (classCode.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Vui lòng nhập mã lớp'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }

                          setState(() {
                            isLoading = true;
                          });

                          final navigator = Navigator.of(context);
                          final scaffoldMessenger =
                              ScaffoldMessenger.of(context);

                          try {
                            final response =
                                await _enrollmentService.joinClass(classCode);

                            if (response.status == StatusCode.ok ||
                                response.status.code == 200 ||
                                response.status.code == 201) {
                              navigator.pop(); // Đóng dialog
                              if (mounted) {
                                scaffoldMessenger.showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Tham gia lớp học thành công! Đang chờ phê duyệt từ giảng viên.'),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                              // Refresh the list from API
                              _fetchMyClasses();
                            } else {
                              navigator
                                  .pop(); // Đóng dialog trước khi hiện thông báo lỗi
                              String errorMessage;
                              switch (response.status) {
                                case StatusCode.classCodeRequired:
                                  errorMessage = 'Vui lòng nhập mã lớp';
                                  break;
                                case StatusCode.authenticationRequired:
                                  errorMessage =
                                      'Bạn cần đăng nhập để tham gia lớp học';
                                  break;
                                case StatusCode.userNotAStudent:
                                  errorMessage =
                                      'Chỉ sinh viên mới có thể tham gia lớp học';
                                  break;
                                case StatusCode.classNotFoundByCode:
                                  errorMessage =
                                      'Không tìm thấy lớp học với mã này. Vui lòng kiểm tra lại mã lớp.';
                                  break;
                                case StatusCode.studentAlreadyEnrolledInClass:
                                  errorMessage =
                                      'Bạn đã tham gia lớp học này rồi';
                                  break;
                                default:
                                  errorMessage = response.message.isNotEmpty
                                      ? response.message
                                      : 'Không thể tham gia lớp học. Vui lòng thử lại sau.';
                              }
                              if (mounted) {
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text(errorMessage),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 4),
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            navigator
                                .pop(); // Đóng dialog trước khi hiện thông báo lỗi
                            if (mounted) {
                              scaffoldMessenger.showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Đã xảy ra lỗi kết nối. Vui lòng kiểm tra mạng và thử lại.'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 4),
                                ),
                              );
                            }
                          } finally {
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                  child: const Text('Tham gia'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _fetchMyClasses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _enrollmentService.getMyClasses();

      if (response.status == StatusCode.ok && response.data != null) {
        // Chuyển đổi từ danh sách Enrollment thành định dạng Map để sử dụng lại UI hiện tại
        final List<Map<String, String>> classes =
            response.data!.map((enrollment) {
          return {
            'name': enrollment.className,
            'instructor': enrollment.instructorName,
            'id': enrollment.classId.toString(),
            'code': 'CLASS${enrollment.classId}',
            'description': 'Trạng thái: ${enrollment.status}',
            'studentCount': '0',
            'enrollmentId': enrollment.enrollmentId.toString(),
            'status': enrollment.status,
          };
        }).toList();

        setState(() {
          _allClasses = classes;
          _filteredClasses = classes;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể tải danh sách lớp học: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Danh sách lớp học',
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm lớp học...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey[600]),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        const BorderSide(color: Colors.cyan, width: 1.5),
                  ),
                ),
              ),
            ),
          Expanded(
            child: SafeArea(
              top: !_isSearching,
              bottom: true,
              left: true,
              right: true,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Không thể tải danh sách lớp học',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _errorMessage!,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700]),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _fetchMyClasses,
                                child: const Text('Thử lại'),
                              ),
                            ],
                          ),
                        )
                      : _filteredClasses.isEmpty &&
                              _searchController.text.isNotEmpty
                          ? const Center(
                              child: Text(
                                'Không tìm thấy kết quả nào.',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            )
                          : _filteredClasses.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Bạn chưa tham gia lớp học nào',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () =>
                                            _showJoinClassDialog(context),
                                        child: const Text('Tham gia lớp học'),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.only(
                                      top: 8, left: 8, right: 8, bottom: 8),
                                  itemCount: _filteredClasses.length,
                                  itemBuilder: (context, index) {
                                    final classData = _filteredClasses[index];
                                    final status =
                                        classData['status']?.toUpperCase() ??
                                            '';

                                    return Card(
                                      color: _getCardColor(index),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 8),
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 20.0,
                                                horizontal: 16.0),
                                        leading: Icon(
                                          status == 'PENDING'
                                              ? Icons.hourglass_empty
                                              : Icons.class_,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                        title: Text(
                                          classData['name'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              classData['instructor'] ??
                                                  'Giảng viên',
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withValues(alpha: 0.85),
                                                fontSize: 14,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            if (status == 'PENDING')
                                              const Text(
                                                'Đang chờ phê duyệt',
                                                style: TextStyle(
                                                  color: Colors.yellowAccent,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                          ],
                                        ),
                                        trailing: PopupMenuButton<String>(
                                          icon: const Icon(Icons.more_vert,
                                              color: Colors.white),
                                          onSelected: (String value) {
                                            if (value == 'leave') {
                                              _showLeaveClassConfirmationDialog(
                                                  context, classData);
                                            }
                                          },
                                          itemBuilder: (BuildContext context) =>
                                              <PopupMenuEntry<String>>[
                                            const PopupMenuItem<String>(
                                              value: 'leave',
                                              child: Text('Rời lớp học'),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          _handleClassTap(context, classData);
                                        },
                                      ),
                                    );
                                  },
                                ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showJoinClassDialog(context);
        },
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
