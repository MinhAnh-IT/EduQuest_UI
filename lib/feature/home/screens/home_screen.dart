import 'package:flutter/material.dart';
import '../../../shared/widgets/bottom_navigation_bar.dart'; // Import the new widget
import 'profile_screen.dart'; // Import the new ProfileScreen
import '../../class/services/enrollment_service.dart'; // Import enrollment service
import '../../../core/enums/status_code.dart'; // Import status codes
import '../../class/screens/class_detail_screen.dart'; // Import class detail screen
import '../../class/models/class_detail.dart'; // Import class detail model
import '../../class/models/assignment.dart'; // Import assignment model

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final EnrollmentService _enrollmentService = EnrollmentService();

  final List<Widget> _pages = [
    HomeTab(),
    ProfileScreen(), // Use ProfileScreen
  ];

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
                ),
                ElevatedButton(
                  child: Text('Tham gia'),
                  onPressed: isLoading ? null : () async {
                    String classCode = classCodeController.text.trim();
                    if (classCode.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Vui lòng nhập mã lớp')),
                      );
                      return;
                    }
                    
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      final response = await _enrollmentService.joinClass(classCode);
                      
                      if (response.status == StatusCode.JOIN_CLASS_SUCCESS) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(response.message),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // Refresh the class list if needed
                        if (mounted) {
                          setState(() {
                            // You can add logic to refresh the class list here
                          });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(response.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Đã xảy ra lỗi: $e'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showJoinClassDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan, // Or your preferred color
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Standard position
      bottomNavigationBar: BottomNavigationBarWidget( // Use the new widget
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
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final EnrollmentService _enrollmentService = EnrollmentService();
  final List<Map<String, String>> _allClasses = [
    {
      'name': 'C5 HK2B NH24-25 Mần...',
      'instructor': 'Anh Nguyen Dinh',
      'id': '1', // Add class ID for API calls
    },
    {
      'name': 'Lý Thuyết: PTTRKHT Sáng 3',
      'instructor': 'Nguyen Tien Trung',
      'id': '2',
    },
    {
      'name': '2A_24_25_CSDLNC_CHI...',
      'instructor': 'Nguyen Van Danh',
      'id': '3',
    },
    {
      'name': '22DTHC6-22DTHC5 - C...',
      'instructor': 'Pham Buu Tai',
      'id': '4',
    },
    {
      'name': '[WIN-SÁNG-THỨ 6] - N...',
      'instructor': 'Hung Tran',
      'id': '5',
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
        _searchController.clear(); // Clears text and triggers _filterClasses
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
    // Create sample data for class detail
    final classDetail = ClassDetail(
      id: int.parse(classData['id'] ?? '1'),
      name: classData['name'] ?? '',
      code: 'CLASS${classData['id']}',
      description: 'Mô tả lớp học ${classData['name']}. Đây là một lớp học tuyệt vời với nhiều bài tập và hoạt động thú vị.',
      instructorName: classData['instructor'] ?? '',
      instructorEmail: '${classData['instructor']?.toLowerCase().replaceAll(' ', '.')}@university.edu',
      studentCount: 25 + int.parse(classData['id'] ?? '1') * 5,
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
                      
                      if (response.status == StatusCode.LEAVE_CLASS_SUCCESS) {
                        Navigator.of(dialogContext).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(response.message),
                            backgroundColor: Colors.green,
                          ),
                        );                        // Remove the class from the list
                        this.setState(() {
                          _allClasses.removeWhere((element) => element['id'] == classData['id']);
                          _filteredClasses = _allClasses;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(response.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Đã xảy ra lỗi: $e'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('EduQuest'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        elevation: 0,
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
              top: !_isSearching, // Only apply top SafeArea padding if search bar is not visible
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
                      ),                      onTap: () {
                        // Navigate to class detail screen
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
    );
  }
}