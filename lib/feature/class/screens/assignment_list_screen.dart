import 'package:flutter/material.dart';
import '../models/assignment.dart';
import 'package:intl/intl.dart';

class AssignmentListScreen extends StatelessWidget {
  final List<Assignment> assignments;
  final String className;

  const AssignmentListScreen({
    Key? key,
    required this.assignments,
    required this.className,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Danh sách bài kiểm tra '),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Ẩn mũi tên back

      ),
      body: _buildAssignmentsList(),
    );
  }

  Widget _buildAssignmentsList() {
    if (assignments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có bài tập nào',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: assignments.length,
      itemBuilder: (context, index) {
        final assignment = assignments[index];
        return _buildAssignmentCard(context, assignment);
      },
    );
  }

  Widget _buildAssignmentCard(BuildContext context, Assignment assignment) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showAssignmentDetail(context, assignment);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      assignment.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: assignment.statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: assignment.statusColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      assignment.statusText,
                      style: TextStyle(
                        fontSize: 12,
                        color: assignment.statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: assignment.isOverdue ? Colors.red : Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Hạn nộp: ${DateFormat('dd/MM/yyyy HH:mm').format(assignment.endAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: assignment.isOverdue ? Colors.red : Colors.grey[600],
                      fontWeight: assignment.isOverdue ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.help_outline,
                    size: 16,
                    color: Colors.cyan[600],
                  ),
                  const SizedBox(width: 2),
                  Text(
                   'Số câu :${assignment.questionCount}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.cyan[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAssignmentDetail(BuildContext context, Assignment assignment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        assignment.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: assignment.statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: assignment.statusColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        assignment.statusText,
                        style: TextStyle(
                          fontSize: 12,
                          color: assignment.statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  'Mô tả bài tập:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                // Text(
                //   assignment.description,
                //   style: const TextStyle(fontSize: 14),
                // ),
                const SizedBox(height: 24),

                // Due Date
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: assignment.isOverdue 
                        ? Colors.red.withValues(alpha: 0.1)
                        : Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: assignment.isOverdue 
                          ? Colors.red.withValues(alpha: 0.3)
                          : Colors.blue.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: assignment.isOverdue ? Colors.red : Colors.blue,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hạn nộp bài',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              DateFormat('dd/MM/yyyy - HH:mm').format(assignment.endAt),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: assignment.isOverdue ? Colors.red : Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Action Buttons
                if (!assignment.isSubmitted)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Chức năng nộp bài sẽ được cập nhật sau'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Bắt đầu làm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                // ... existing code ...
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: assignment.isDisabled
                            ? null
                            : assignment.isSubmitted
                            ? () {
                          //Điều hướng sang trang bình luận
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Đi tới trang bình luận (chưa code)')),
                          );
                        }
                            : () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Bạn chưa làm bài nên chưa thể thảo luận luận!')),
                          );
                        },
                        icon: const Icon(Icons.comment),
                        label: const Text('Thảo luận'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: assignment.isDisabled
                            ? null
                            : assignment.isSubmitted
                            ? () {
                          // Điều hướng sang trang xem kết quả
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Đi tới trang kết quả (chưa code)')),
                          );
                        }
                            : () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Bạn chưa làm bài kiểm tra nên không thể xem kết quả!')),
                          );
                        },
                        icon: const Icon(Icons.visibility),
                        label: const Text('Xem kết quả'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
// ... existing code ...
              ],
            ),
          ),
        ),
      ),
    );
  }
}