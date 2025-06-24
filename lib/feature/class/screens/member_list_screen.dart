import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/class_provider.dart';
import '../models/student.dart';

class MemberListScreen extends StatefulWidget {
  final int classId;
  final String className;
  final int studentCount;

  const MemberListScreen({
    Key? key,
    required this.classId,
    required this.className,
    required this.studentCount,
  }) : super(key: key);

  @override
  State<MemberListScreen> createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {
  @override
  void initState() {
    super.initState();
    // Load students using provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClassProvider>().loadStudents(widget.classId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Thành viên - ${widget.className}'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ClassProvider>().refreshStudents(widget.classId);
            },
          ),
        ],
      ),
      body: Consumer<ClassProvider>(
        builder: (context, classProvider, child) {
          return _buildBody(classProvider);
        },
      ),
    );
  }

  Widget _buildBody(ClassProvider classProvider) {
    if (classProvider.isLoadingStudents) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
        ),
      );
    }

    if (classProvider.studentsError != null) {
      return _buildErrorState(classProvider);
    }

    if (classProvider.students.isEmpty) {
      return _buildEmptyState(classProvider);
    }

    return _buildStudentsList(classProvider);
  }
  
  Widget _buildErrorState(ClassProvider classProvider) {
    return Center(
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
              onPressed: () {
                classProvider.refreshStudents(widget.classId);
              },
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
    );
  }
  Widget _buildEmptyState(ClassProvider classProvider) {
    return Center(
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
              onPressed: () {
                classProvider.refreshStudents(widget.classId);
              },
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
    );
  }
  Widget _buildStudentsList(ClassProvider classProvider) {
    return RefreshIndicator(
      onRefresh: () => classProvider.refreshStudents(widget.classId),
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
                  '${classProvider.studentsCount} học sinh',
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
        contentPadding: const EdgeInsets.all(16),        leading: CircleAvatar(
          backgroundColor: Colors.cyan[100],
          backgroundImage: student.avatarUrl != null && student.avatarUrl!.isNotEmpty
              ? NetworkImage(student.avatarUrl!)
              : null,
          child: student.avatarUrl == null || student.avatarUrl!.isEmpty
              ? Text(
                  student.studentName.isNotEmpty 
                      ? student.studentName[0].toUpperCase()
                      : 'S',
                  style: TextStyle(
                    color: Colors.cyan[700],
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
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
}
