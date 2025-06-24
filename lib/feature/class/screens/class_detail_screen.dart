import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/class_detail.dart';
import '../providers/class_provider.dart';
import 'assignment_list_screen.dart';
import 'member_list_screen.dart';
import '../../../shared/widgets/custom_app_bar.dart';

class ClassDetailScreen extends StatefulWidget {
  final int classId;
  final ClassDetail? initialClassDetail; // Optional initial data

  const ClassDetailScreen({
    Key? key,
    required this.classId,
    this.initialClassDetail,
  }) : super(key: key);

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Load class data using provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final classProvider = context.read<ClassProvider>();
      
      // Reset provider state first
      classProvider.reset();
        // Use initial data if provided
      if (widget.initialClassDetail != null) {
        // Set initial data to provider and then load students and assignments
        classProvider.setInitialClassDetail(widget.initialClassDetail!);
        classProvider.loadStudents(widget.classId);
        classProvider.loadAssignments(widget.classId);
      } else {
        // Load class detail, students and assignments from API
        classProvider.loadClassData(widget.classId);
      }
    });
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassProvider>(
      builder: (context, classProvider, child) {        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: CustomAppBar(
            title: classProvider.classDetail?.name ?? 'Chi tiết lớp học',
            actions: [
              if (!classProvider.isLoadingClassDetail && classProvider.classDetail != null)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => classProvider.loadClassData(widget.classId),
                ),
            ],            bottom: classProvider.isLoadingClassDetail || classProvider.classDetail == null ? null : TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,              tabs: const [
                Tab(icon: Icon(Icons.info), text: 'Thông tin'),
                Tab(icon: Icon(Icons.assignment), text: 'Bài kiểm tra'),
                Tab(icon: Icon(Icons.people), text: 'Học sinh'),
              ],
            ),
          ),
          body: _buildBody(classProvider),
        );
      },
    );
  }

  Widget _buildBody(ClassProvider classProvider) {
    if (classProvider.isLoadingClassDetail) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.cyan),
            SizedBox(height: 16),
            Text('Đang tải thông tin lớp học...'),
          ],
        ),
      );
    }

    if (classProvider.classDetailError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Không thể tải thông tin lớp học',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              classProvider.classDetailError!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),            
            ElevatedButton(
              onPressed: () {
                classProvider.loadClassData(widget.classId);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
              child: const Text('Thử lại', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (classProvider.classDetail == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Không tìm thấy thông tin lớp học'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                classProvider.loadClassData(widget.classId);
              },
              child: const Text('Tải lại'),
            ),
          ],        ),
      );
    }    
    return TabBarView(
      controller: _tabController,
      children: [
        _buildInfoTab(classProvider),
        _buildAssignmentsTab(classProvider),
        _buildMembersTab(classProvider),
      ],
    );
  }
  
  Widget _buildInfoTab(ClassProvider classProvider) {
    final classDetail = classProvider.classDetail!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Class Header Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [Colors.cyan[400]!, Colors.cyan[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classDetail.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mã lớp: ${classDetail.code}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${classDetail.studentCount} học sinh',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Instructor Info Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.cyan[600]),
                      const SizedBox(width: 8),
                      const Text(
                        'Giáo viên',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    classDetail.instructorName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),                  Text(
                    classDetail.instructorEmail,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.assignment, color: Colors.cyan[600]),
                      const SizedBox(width: 8),
                      const Text(
                        'Thống kê bài tập',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),                  const SizedBox(height: 16),
                  Row(
                    children: [                      Expanded(
                        child: _buildQuickStatCard(
                          'Tổng bài tập',
                          _getAssignmentStats(classProvider)['total'].toString(),
                          Icons.assignment_outlined,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickStatCard(
                          'Đã làm',
                          _getAssignmentStats(classProvider)['completed'].toString(),
                          Icons.assignment_turned_in,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickStatCard(
                          'Chưa làm',
                          _getAssignmentStats(classProvider)['pending'].toString(),
                          Icons.assignment_late_outlined,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildQuickStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: color,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }  
  
  Widget _buildAssignmentsTab(ClassProvider classProvider) {
    return AssignmentListScreen(
      classId: widget.classId,
      className: classProvider.classDetail?.name ?? 'Tất cả bài tập',
    );
  }

  Widget _buildMembersTab(ClassProvider classProvider) {
    return MemberListScreen(
      classId: widget.classId,
      className: classProvider.classDetail?.name ?? 'Danh sách học sinh',
    );
  }

  Map<String, int> _getAssignmentStats(ClassProvider classProvider) {
    final assignments = classProvider.assignments;

    int total = assignments.length;
    int completed = assignments.where((assignment) => assignment.isSubmitted).length;
    int pending = total - completed;

    return {
      'total': total,
      'completed': completed,
      'pending': pending,
    };
  }
}