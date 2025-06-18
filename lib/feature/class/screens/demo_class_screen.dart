import 'package:flutter/material.dart';
import 'class_detail_screen.dart';
import '../models/class_detail.dart';
import '../models/assignment.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class Detail Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: ClassDetailScreen(
        classDetail: ClassDetail(
          id: 1,
          name: 'Lập trình ứng dụng di động',
          code: 'MOBILE101',
          description: 'Khóa học lập trình ứng dụng di động sử dụng Flutter framework. Học viên sẽ được học các khái niệm cơ bản về Flutter, cách xây dựng giao diện người dùng, quản lý state, và tích hợp API.',
          instructorName: 'Nguyễn Văn An',
          instructorEmail: 'nguyen.van.an@university.edu',
          studentCount: 32,
          createdAt: DateTime.now().subtract(const Duration(days: 45)),
          assignments: [
            Assignment(
              id: 1,
              title: 'Bài tập 1: Giới thiệu Flutter',
              description: 'Tạo một ứng dụng Flutter đơn giản với màn hình chào mừng và giới thiệu bản thân.',
              dueDate: DateTime.now().add(const Duration(days: 7)),
              status: 'submitted',
              grade: '9.0',
              createdAt: DateTime.now().subtract(const Duration(days: 14)),
            ),
            Assignment(
              id: 2,
              title: 'Bài tập 2: Layout và Widget',
              description: 'Xây dựng giao diện người dùng phức tạp sử dụng các widget layout như Column, Row, Stack.',
              dueDate: DateTime.now().add(const Duration(days: 14)),
              status: 'pending',
              createdAt: DateTime.now().subtract(const Duration(days: 7)),
            ),
            Assignment(
              id: 3,
              title: 'Bài tập 3: Quản lý State',
              description: 'Tạo ứng dụng counter với setState và tìm hiểu về StatefulWidget.',
              dueDate: DateTime.now().subtract(const Duration(days: 2)),
              status: 'pending',
              createdAt: DateTime.now().subtract(const Duration(days: 10)),
            ),
            Assignment(
              id: 4,
              title: 'Bài tập 4: Navigation',
              description: 'Xây dựng ứng dụng nhiều màn hình và quản lý navigation.',
              dueDate: DateTime.now().add(const Duration(days: 21)),
              status: 'pending',
              createdAt: DateTime.now().subtract(const Duration(days: 3)),
            ),
            Assignment(
              id: 5,
              title: 'Dự án cuối kỳ',
              description: 'Xây dựng một ứng dụng hoàn chỉnh theo yêu cầu đã đề ra. Ứng dụng phải có ít nhất 5 màn hình và tích hợp API.',
              dueDate: DateTime.now().add(const Duration(days: 30)),
              status: 'graded',
              grade: '8.5',
              createdAt: DateTime.now().subtract(const Duration(days: 1)),
            ),
          ],
        ),
      ),
    );
  }
}
