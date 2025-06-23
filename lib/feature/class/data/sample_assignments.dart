import '../models/assignment.dart';

class SampleAssignments {
  /// Tạo danh sách assignments mẫu dựa trên classId
  static List<Assignment> createSampleAssignments(int classId) {
    final baseDate = DateTime.now();

    if (classId == 1) {
      // Assignments for Mobile Development class
      return _createMobileDevelopmentAssignments(baseDate);
    }

    // Default assignments for other classes
    return _createDefaultAssignments(classId, baseDate);
  }

  /// Tạo assignments mẫu cho lớp Mobile Development (classId = 1)
  static List<Assignment> _createMobileDevelopmentAssignments(DateTime baseDate) {
    return [
      Assignment(
        id: 1,
        title: 'Bài tập 1: Giới thiệu Flutter',
        description:
            'Tạo một ứng dụng Flutter đơn giản với màn hình chào mừng và giới thiệu bản thân.',
        dueDate: baseDate.add(const Duration(days: 7)),
        status: 'submitted',
        grade: '9.0',
        createdAt: baseDate.subtract(const Duration(days: 14)),
      ),
      Assignment(
        id: 2,
        title: 'Bài tập 2: Layout và Widget',
        description:
            'Xây dựng giao diện người dùng phức tạp sử dụng các widget layout như Column, Row, Stack.',
        dueDate: baseDate.add(const Duration(days: 14)),
        status: 'pending',
        createdAt: baseDate.subtract(const Duration(days: 7)),
      ),
      Assignment(
        id: 3,
        title: 'Bài tập 3: Quản lý State',
        description:
            'Tạo ứng dụng counter với setState và tìm hiểu về StatefulWidget.',
        dueDate: baseDate.subtract(const Duration(days: 2)),
        status: 'pending',
        createdAt: baseDate.subtract(const Duration(days: 10)),
      ),
      Assignment(
        id: 4,
        title: 'Bài tập 4: Navigation',
        description:
            'Xây dựng ứng dụng nhiều màn hình và quản lý navigation.',
        dueDate: baseDate.add(const Duration(days: 21)),
        status: 'pending',
        createdAt: baseDate.subtract(const Duration(days: 3)),
      ),
      Assignment(
        id: 5,
        title: 'Dự án cuối kỳ',
        description:
            'Xây dựng một ứng dụng hoàn chỉnh theo yêu cầu đã đề ra. Ứng dụng phải có ít nhất 5 màn hình và tích hợp API.',
        dueDate: baseDate.add(const Duration(days: 30)),
        status: 'graded',
        grade: '8.5',
        createdAt: baseDate.subtract(const Duration(days: 1)),
      ),
    ];
  }

  /// Tạo assignments mẫu mặc định cho các lớp khác
  static List<Assignment> _createDefaultAssignments(int classId, DateTime baseDate) {
    return [
      Assignment(
        id: classId * 10 + 1,
        title: 'Bài tập 1: Giới thiệu',
        description: 'Viết một bài luận ngắn về bản thân và mục tiêu học tập.',
        dueDate: baseDate.add(const Duration(days: 7)),
        status: 'submitted',
        grade: '8.5',
        createdAt: baseDate.subtract(const Duration(days: 14)),
      ),
      Assignment(
        id: classId * 10 + 2,
        title: 'Bài tập 2: Nghiên cứu',
        description:
            'Thực hiện nghiên cứu về chủ đề được giao và trình bày kết quả.',
        dueDate: baseDate.add(const Duration(days: 14)),
        status: 'pending',
        createdAt: baseDate.subtract(const Duration(days: 7)),
      ),
      Assignment(
        id: classId * 10 + 3,
        title: 'Bài tập 3: Thực hành',
        description:
            'Hoàn thành các bài tập thực hành trong sách giáo khoa chương 3.',
        dueDate: baseDate.subtract(const Duration(days: 2)),
        status: 'pending',
        createdAt: baseDate.subtract(const Duration(days: 10)),
      ),
    ];
  }

  /// Tạo assignments mẫu cho lớp học cụ thể dựa trên tên lớp
  static List<Assignment> createAssignmentsByClassName(int classId, String className) {
    final baseDate = DateTime.now();
    
    // Có thể mở rộng thêm assignments cho các lớp khác dựa trên tên
    if (className.toLowerCase().contains('flutter') || 
        className.toLowerCase().contains('mobile')) {
      return _createMobileDevelopmentAssignments(baseDate);
    }
    
    if (className.toLowerCase().contains('web')) {
      return _createWebDevelopmentAssignments(classId, baseDate);
    }
    
    if (className.toLowerCase().contains('database') || 
        className.toLowerCase().contains('db')) {
      return _createDatabaseAssignments(classId, baseDate);
    }
    
    // Mặc định trả về assignments chung
    return _createDefaultAssignments(classId, baseDate);
  }

  /// Tạo assignments mẫu cho lớp Web Development
  static List<Assignment> _createWebDevelopmentAssignments(int classId, DateTime baseDate) {
    return [
      Assignment(
        id: classId * 10 + 1,
        title: 'Bài tập 1: HTML & CSS Cơ bản',
        description: 'Tạo một trang web đơn giản sử dụng HTML và CSS.',
        dueDate: baseDate.add(const Duration(days: 7)),
        status: 'submitted',
        grade: '8.0',
        createdAt: baseDate.subtract(const Duration(days: 14)),
      ),
      Assignment(
        id: classId * 10 + 2,
        title: 'Bài tập 2: JavaScript DOM',
        description: 'Thêm tính tương tác vào trang web sử dụng JavaScript.',
        dueDate: baseDate.add(const Duration(days: 14)),
        status: 'pending',
        createdAt: baseDate.subtract(const Duration(days: 7)),
      ),
      Assignment(
        id: classId * 10 + 3,
        title: 'Bài tập 3: API Integration',
        description: 'Tích hợp API bên ngoài vào ứng dụng web.',
        dueDate: baseDate.add(const Duration(days: 21)),
        status: 'pending',
        createdAt: baseDate.subtract(const Duration(days: 3)),
      ),
    ];
  }

  /// Tạo assignments mẫu cho lớp Database
  static List<Assignment> _createDatabaseAssignments(int classId, DateTime baseDate) {
    return [
      Assignment(
        id: classId * 10 + 1,
        title: 'Bài tập 1: Thiết kế ERD',
        description: 'Thiết kế sơ đồ thực thể quan hệ cho hệ thống quản lý thư viện.',
        dueDate: baseDate.add(const Duration(days: 10)),
        status: 'submitted',
        grade: '9.5',
        createdAt: baseDate.subtract(const Duration(days: 14)),
      ),
      Assignment(
        id: classId * 10 + 2,
        title: 'Bài tập 2: SQL Queries',
        description: 'Viết các câu truy vấn SQL phức tạp với JOIN và Subquery.',
        dueDate: baseDate.add(const Duration(days: 14)),
        status: 'pending',
        createdAt: baseDate.subtract(const Duration(days: 7)),
      ),
      Assignment(
        id: classId * 10 + 3,
        title: 'Bài tập 3: Stored Procedures',
        description: 'Tạo stored procedures và functions trong database.',
        dueDate: baseDate.add(const Duration(days: 18)),
        status: 'pending',
        createdAt: baseDate.subtract(const Duration(days: 5)),
      ),
    ];
  }
}
