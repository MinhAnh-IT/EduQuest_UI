import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/assignment.dart';
import '../models/class_detail.dart';
import '../models/student.dart';
import '../providers/class_provider.dart';
import '../providers/exercise_provider.dart';
import 'assignment_list_screen.dart';

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
  late TabController _tabController;

  @override
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
        // Set initial data to provider and then load students
        classProvider.setInitialClassDetail(widget.initialClassDetail!);
        classProvider.loadStudents(widget.classId);
      } else {
        // Load both class detail and students from API
        classProvider.loadClassData(widget.classId);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }@override
  Widget build(BuildContext context) {
    return Consumer<ClassProvider>(
      builder: (context, classProvider, child) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: Text(classProvider.classDetail?.name ?? 'Chi tiết lớp học'),
            backgroundColor: Colors.cyan,
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              if (!classProvider.isLoadingClassDetail && classProvider.classDetail != null)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => classProvider.loadClassData(widget.classId),
                ),
            ],
            bottom: classProvider.isLoadingClassDetail || classProvider.classDetail == null ? null : TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(icon: Icon(Icons.info), text: 'Thông tin'),
                Tab(icon: Icon(Icons.assignment), text: 'Bài kiểm tra'),
                Tab(icon: Icon(Icons.people), text: 'Thành viên'),
              ],
            ),
          ),
          body: _buildBody(classProvider),
        );
      },
    );
  }  Widget _buildBody(ClassProvider classProvider) {
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
            const SizedBox(height: 24),            ElevatedButton(
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
          ],
        ),
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
  }Widget _buildInfoTab(ClassProvider classProvider) {
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
                  const SizedBox(height: 4),
                  Text(
                    classDetail.instructorEmail,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Statistics Card
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
                      Icon(Icons.analytics, color: Colors.cyan[600]),
                      const SizedBox(width: 8),
                      const Text(
                        'Thống kê bài tập',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        'Tổng số',
                        classDetail.assignments.length.toString(),
                        Colors.blue,
                        Icons.assignment,
                      ),
                      _buildStatItem(
                        'Chưa nộp',
                        classDetail.pendingAssignmentsCount.toString(),
                        Colors.orange,
                        Icons.pending,
                      ),
                      _buildStatItem(
                        'Quá hạn',
                        classDetail.overdueAssignmentsCount.toString(),
                        Colors.red,
                        Icons.warning,
                      ),
                      _buildStatItem(
                        'Đã nộp',
                        classDetail.submittedAssignmentsCount.toString(),
                        Colors.green,
                        Icons.check_circle,
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
  Widget _buildAssignmentsTab(ClassProvider classProvider) {
    return Consumer<ExerciseProvider>(
      builder: (context, exerciseProvider, child) {
        if (exerciseProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (exerciseProvider.error != null) {
          return Center(child: Text('Error: ${exerciseProvider.error}'));
        }

        // Lấy classId hiện tại
        final int? classId = classProvider.classDetail?.id;

        // Lọc assignments theo classId và ép kiểu về List<Assignment>
        final classAssignments = classId == null
            ? <Assignment>[]
            : exerciseProvider.assignments
            .where((a) => a.classId == classId)
            .toList()
            .cast<Assignment>();

        if (classAssignments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('Chưa có bài tập nào', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600])),
                const SizedBox(height: 8),
                Text('Bài tập sẽ được hiển thị ở đây khi có', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
              ],
            ),
          );
        }

        return AssignmentListScreen(
          assignments: classAssignments,
          className: classProvider.classDetail?.name ?? 'Tất cả bài tập',
        );
      },
    );
  }
  Widget _buildMembersTab(ClassProvider classProvider) {
    return Column(
      children: [
        if (classProvider.isLoadingStudents)
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
              ),
            ),
          )
        else if (classProvider.studentsError != null)
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Lỗi khi tải danh sách thành viên',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      classProvider.studentsError ?? 'Đã xảy ra lỗi không xác định',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => classProvider.loadStudents(widget.classId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            ),
          )
        else if (classProvider.students.isEmpty)
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Chưa có học sinh nào',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lớp học này chưa có học sinh nào tham gia',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => classProvider.loadStudents(widget.classId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Làm mới'),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => classProvider.loadStudents(widget.classId),
              color: Colors.cyan,
              child: Column(
                children: [
                  // Header with student count
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Icon(
                          Icons.people,
                          color: Colors.cyan[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${classProvider.students.length} học sinh',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Students list
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: classProvider.students.length,
                      itemBuilder: (context, index) {
                        final student = classProvider.students[index];
                        return _buildStudentCard(student);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
  Widget _buildStudentCard(Student student) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.cyan[100],
          backgroundImage: student.avatarUrl != null && student.avatarUrl!.isNotEmpty
              ? NetworkImage(student.avatarUrl!)
              : null,
          child: student.avatarUrl != null && student.avatarUrl!.isNotEmpty
              ? null
              : Text(
                  student.studentName.isNotEmpty 
                      ? student.studentName[0].toUpperCase()
                      : 'S',
                  style: TextStyle(
                    color: Colors.cyan[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        title: Text(
          student.studentName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'MSSV: ${student.studentCode}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              student.studentEmail,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: student.statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: student.statusColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            student.statusText,
            style: TextStyle(
              color: student.statusColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String count, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          count,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

enum ConvertStatus {
  SUBMITTED('Đã nộp'),
  IN_PROGRESS('Đang xử lý');

  final String message;
  const ConvertStatus(this.message);

  static String? getMessage(String name) {
    try {
      return ConvertStatus.values
          .firstWhere((e) => e.name == name)
          .message;
    } catch (e) {
      return null;
    }
  }
}