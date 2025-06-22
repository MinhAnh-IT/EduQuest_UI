import 'package:flutter/material.dart';
import '../models/class_detail.dart';


class ClassDetailScreen extends StatelessWidget {
  final ClassDetail classDetail;

  const ClassDetailScreen({super.key, required this.classDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(classDetail.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Giảng viên: ${classDetail.instructorName}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Email: ${classDetail.instructorEmail}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Danh sách bài tập:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...classDetail.assignments.map((assignment) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        assignment.title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(assignment.description),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Chip(
                            label: Text(assignment.statusText),
                            backgroundColor:
                                assignment.statusColor.withOpacity(0.15),
                            labelStyle:
                                TextStyle(color: assignment.statusColor),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              if (assignment.isSubmitted) {
                                Navigator.pushNamed(
                                  context,
                                  '/result',
                                  arguments: {'exerciseId': assignment.id},
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Chức năng làm bài chưa có")),
                                );
                              }
                            },
                            child: Text(assignment.isSubmitted
                                ? "Xem kết quả"
                                : "Làm bài"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }).toList()
          ],
        ),
      ),
    );
  }
}
