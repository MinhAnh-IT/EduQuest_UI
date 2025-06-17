import 'package:flutter/material.dart';
import '../../class/services/enrollment_service.dart';
import '../../../core/enums/status_code.dart';
import '../../class/screens/class_detail_screen.dart';
import '../../class/models/class_detail.dart';
import '../../class/models/assignment.dart';
import '../../../shared/widgets/custom_app_bar.dart';

class ClassListScreen extends StatefulWidget {
  @override
  State<ClassListScreen> createState() => _ClassListScreenState();
}

class _ClassListScreenState extends State<ClassListScreen> {
  final EnrollmentService _enrollmentService = EnrollmentService();
  final List<Map<String, String>> _allClasses = [
    {
      'name': 'Lập trình ứng dụng di động',
      'instructor': 'Nguyễn Văn An',
      'id': '1',
      'code': 'MOBILE101',
      'description': 'Khóa học lập trình ứng dụng di động sử dụng Flutter framework. Học viên sẽ được học các khái niệm cơ bản về Flutter, cách xây dựng giao diện người dùng, quản lý state, và tích hợp API.',
      'studentCount': '32',
    },
    {
      'name': 'Cấu trúc dữ liệu và giải thuật',
      'instructor': 'Trần Thị Bình',
      'id': '2',
      'code': 'CS201',
      'description': 'Học về các cấu trúc dữ liệu cơ bản và giải thuật quan trọng trong khoa học máy tính.',
      'studentCount': '28',
    },
    {
      'name': 'Cơ sở dữ liệu nâng cao',
      'instructor': 'Lê Văn Cường',
      'id': '3',
      'code': 'DB301',
      'description': 'Khóa học về thiết kế và quản lý cơ sở dữ liệu chuyên nghiệp.',
      'studentCount': '25',
    },
    {
      'name': 'Mạng máy tính',
      'instructor': 'Phạm Thị Dung',
      'id': '4',
      'code': 'NET202',
      'description': 'Tìm hiểu về giao thức mạng, bảo mật mạng và quản trị hệ thống mạng.',
      'studentCount': '30',
    },
    {
      'name': 'Trí tuệ nhân tạo',
      'instructor': 'Hoàng Văn Em',
      'id': '5',
      'code': 'AI401',
      'description': 'Giới thiệu về machine learning, deep learning và các ứng dụng AI.',
      'studentCount': '35',
    },
  ];
  List<Map<String, String>> _filteredClasses = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredClasses = _allClasses;
    _searchController.addListener(_filterClasses);
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
    return colors[index % colors.length].withOpacity(0.9);
  }
  void _navigateToClassDetail(BuildContext context, Map<String, String> classData) {
    final classDetail = ClassDetail(
      id: int.parse(classData['id'] ?? '1'),
      name: classData['name'] ?? '',
      code: classData['code'] ?? 'CLASS${classData['id']}',
      description: classData['description'] ?? 'Mô tả lớp học ${classData['name']}',
      instructorName: classData['instructor'] ?? '',
      instructorEmail: '${classData['instructor']?.toLowerCase().replaceAll(' ', '.').replaceAll('ă', 'a').replaceAll('â', 'a').replaceAll('đ', 'd').replaceAll('ê', 'e').replaceAll('ô', 'o').replaceAll('ơ', 'o').replaceAll('ư', 'u').replaceAll('ì', 'i').replaceAll('í', 'i').replaceAll('ò', 'o').replaceAll('ó', 'o').replaceAll('ù', 'u').replaceAll('ú', 'u').replaceAll('ỳ', 'y').replaceAll('ý', 'y')}@university.edu',
      studentCount: int.parse(classData['studentCount'] ?? '25'),
      createdAt: DateTime.now().subtract(Duration(days: 30 + int.parse(classData['id'] ?? '1') * 10)),
      assignments: _createSampleAssignments(int.parse(classData['id'] ?? '1')),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassDetailScreen(classDetail: classDetail),
      ),
    );
  }
  List<Assignment> _createSampleAssignments(int classId) {
    final baseDate = DateTime.now();
    
    if (classId == 1) {
      // Assignments for Mobile Development class
      return [
        Assignment(
          id: 1,
          title: 'Bài tập 1: Giới thiệu Flutter',
          description: 'Tạo một ứng dụng Flutter đơn giản với màn hình chào mừng và giới thiệu bản thân.',
          dueDate: baseDate.add(Duration(days: 7)),
          status: 'submitted',
          grade: '9.0',
          createdAt: baseDate.subtract(Duration(days: 14)),
        ),
        Assignment(
          id: 2,
          title: 'Bài tập 2: Layout và Widget',
          description: 'Xây dựng giao diện người dùng phức tạp sử dụng các widget layout như Column, Row, Stack.',
          dueDate: baseDate.add(Duration(days: 14)),
          status: 'pending',
          createdAt: baseDate.subtract(Duration(days: 7)),
        ),
        Assignment(
          id: 3,
          title: 'Bài tập 3: Quản lý State',
          description: 'Tạo ứng dụng counter với setState và tìm hiểu về StatefulWidget.',
          dueDate: baseDate.subtract(Duration(days: 2)),
          status: 'pending',
          createdAt: baseDate.subtract(Duration(days: 10)),
        ),
        Assignment(
          id: 4,
          title: 'Bài tập 4: Navigation',
          description: 'Xây dựng ứng dụng nhiều màn hình và quản lý navigation.',
          dueDate: baseDate.add(Duration(days: 21)),
          status: 'pending',
          createdAt: baseDate.subtract(Duration(days: 3)),
        ),
        Assignment(
          id: 5,
          title: 'Dự án cuối kỳ',
          description: 'Xây dựng một ứng dụng hoàn chỉnh theo yêu cầu đã đề ra. Ứng dụng phải có ít nhất 5 màn hình và tích hợp API.',
          dueDate: baseDate.add(Duration(days: 30)),
          status: 'graded',
          grade: '8.5',
          createdAt: baseDate.subtract(Duration(days: 1)),
        ),
      ];
    }
    
    // Default assignments for other classes
    return [
      Assignment(
        id: classId * 10 + 1,
        title: 'Bài tập 1: Giới thiệu',
        description: 'Viết một bài luận ngắn về bản thân và mục tiêu học tập.',
        dueDate: baseDate.add(Duration(days: 7)),
        status: 'submitted',
        grade: '8.5',
        createdAt: baseDate.subtract(Duration(days: 14)),
      ),
      Assignment(
        id: classId * 10 + 2,
        title: 'Bài tập 2: Nghiên cứu',
        description: 'Thực hiện nghiên cứu về chủ đề được giao và trình bày kết quả.',
        dueDate: baseDate.add(Duration(days: 14)),
        status: 'pending',
        createdAt: baseDate.subtract(Duration(days: 7)),
      ),
      Assignment(
        id: classId * 10 + 3,
        title: 'Bài tập 3: Thực hành',
        description: 'Hoàn thành các bài tập thực hành trong sách giáo khoa chương 3.',
        dueDate: baseDate.subtract(Duration(days: 2)),
        status: 'pending',
        createdAt: baseDate.subtract(Duration(days: 10)),
      ),
    ];
  }

  void _showLeaveClassConfirmationDialog(BuildContext context, Map<String, String> classData) {
    bool isLoading = false;
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Rời lớp học'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Bạn có chắc chắn muốn rời lớp học "${classData['name']}" không?'),
                  if (isLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Hủy'),
                  onPressed: isLoading ? null : () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
                ElevatedButton(
                  child: Text('Rời lớp'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: isLoading ? null : () async {
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      final classId = int.parse(classData['id']!);
                      final response = await _enrollmentService.leaveClass(classId);
                        if (response.status == StatusCode.ok) {
                        Navigator.of(dialogContext).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Đã rời lớp học thành công!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        this.setState(() {
                          _allClasses.removeWhere((element) => element['id'] == classData['id']);
                          _filteredClasses = _allClasses;
                        });                      } else {
                        Navigator.of(dialogContext).pop();
                        String errorMessage;                        switch (response.status) {
                          case StatusCode.authenticationRequired:
                            errorMessage = 'Bạn cần đăng nhập để rời lớp học';
                            break;
                          case StatusCode.userNotAStudent:
                            errorMessage = 'Chỉ sinh viên mới có thể rời lớp học';
                            break;
                          case StatusCode.classNotFoundById:
                            errorMessage = 'Không tìm thấy lớp học này';
                            break;
                          case StatusCode.studentNotEnrolledInClass:
                            errorMessage = 'Bạn chưa tham gia lớp học này';
                            break;
                          default:
                            errorMessage = response.message.isNotEmpty ? response.message : 'Không thể rời lớp học. Vui lòng thử lại sau.';
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(errorMessage),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      Navigator.of(dialogContext).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Đã xảy ra lỗi kết nối. Vui lòng kiểm tra mạng và thử lại.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } finally {
                      if (mounted) {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }
                  },
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
              title: Text('Tham gia lớp học'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: classCodeController,
                    decoration: InputDecoration(hintText: 'Nhập mã lớp'),
                    autofocus: true,
                    enabled: !isLoading,
                  ),
                  if (isLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Hủy'),
                  onPressed: isLoading ? null : () {
                    Navigator.of(context).pop();
                  },
                ),                ElevatedButton(
                  child: Text('Tham gia'),
                  onPressed: isLoading ? null : () async {
                    String classCode = classCodeController.text.trim();
                    if (classCode.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Vui lòng nhập mã lớp'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }
                    
                    setState(() {
                      isLoading = true;
                    });                    try {
                      final response = await _enrollmentService.joinClass(classCode);                      // Debug: In ra giá trị status để kiểm tra
                      print('Join class response status: ${response.status}');
                      print('Join class response status code: ${response.status.code}');
                      print('Join class response message: ${response.message}');
                      print('StatusCode.ok: ${StatusCode.ok}');
                      print('StatusCode.ok.code: ${StatusCode.ok.code}');
                      print('Comparison result: ${response.status == StatusCode.ok}');
                      
                      if (response.status == StatusCode.ok || response.status.code == 200 || response.status.code == 201) {
                        Navigator.of(context).pop(); // Đóng dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Tham gia lớp học thành công! Đang chờ phê duyệt từ giảng viên.'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 4),
                          ),
                        );
                        if (mounted) {
                          this.setState(() {
                            // Refresh logic here - có thể thêm lớp mới vào danh sách
                          });
                        }
                      } else {
                        Navigator.of(context).pop(); // Đóng dialog trước khi hiện thông báo lỗi
                        String errorMessage;                        switch (response.status) {
                          case StatusCode.classCodeRequired:
                            errorMessage = 'Vui lòng nhập mã lớp';
                            break;
                          case StatusCode.authenticationRequired:
                            errorMessage = 'Bạn cần đăng nhập để tham gia lớp học';
                            break;
                          case StatusCode.userNotAStudent:
                            errorMessage = 'Chỉ sinh viên mới có thể tham gia lớp học';
                            break;
                          case StatusCode.classNotFoundByCode:
                            errorMessage = 'Không tìm thấy lớp học với mã này. Vui lòng kiểm tra lại mã lớp.';
                            break;
                          case StatusCode.studentAlreadyEnrolledInClass:
                            errorMessage = 'Bạn đã tham gia lớp học này rồi';
                            break;default:
                            errorMessage = response.message.isNotEmpty ? response.message : 'Không thể tham gia lớp học. Vui lòng thử lại sau.';
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(errorMessage),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 4),
                          ),
                        );
                      }
                    } catch (e) {
                      Navigator.of(context).pop(); // Đóng dialog trước khi hiện thông báo lỗi
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Đã xảy ra lỗi kết nối. Vui lòng kiểm tra mạng và thử lại.'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 4),
                        ),
                      );
                    } finally {
                      if (mounted) {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.cyan, width: 1.5),
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
              child: _filteredClasses.isEmpty && _searchController.text.isNotEmpty
                  ? Center(
                child: Text(
                  'Không tìm thấy kết quả nào.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
                itemCount: _filteredClasses.length,
                itemBuilder: (context, index) {
                  final classData = _filteredClasses[index];
                  return Card(
                    color: _getCardColor(index),
                    margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                      leading: Icon(Icons.class_, color: Colors.white, size: 30),
                      title: Text(
                        classData['name']!,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        classData['instructor']!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, color: Colors.white),
                        onSelected: (String value) {
                          if (value == 'leave') {
                            _showLeaveClassConfirmationDialog(context, classData);
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'leave',
                            child: Text('Rời lớp học'),
                          ),
                        ],
                      ),
                      onTap: () {
                        _navigateToClassDetail(context, classData);
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
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
