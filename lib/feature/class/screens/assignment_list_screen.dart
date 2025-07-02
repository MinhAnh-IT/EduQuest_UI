import 'package:edu_quest/feature/quiz/screens/exam_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/assignment.dart';
import '../providers/exercise_provider.dart';
import 'package:intl/intl.dart';

class AssignmentListScreen extends StatefulWidget {
  final int classId;
  final String className;

  const AssignmentListScreen({
    Key? key,
    required this.classId,
    required this.className,
  }) : super(key: key);

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      Provider.of<ExerciseProvider>(context, listen: false)
          .fetchAssignments(widget.classId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Consumer<ExerciseProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text('Lỗi: ${provider.error}'));
          }
          return _buildAssignmentsList(context, provider.assignments);
        },
      ),
    );
  }

  Widget _buildAssignmentsList(
      BuildContext context, List<Assignment> assignments) {
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
                      // ignore: deprecated_member_use
                      color: assignment.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        // ignore: deprecated_member_use
                        color: assignment.statusColor.withOpacity(0.3),
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
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.orange[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Ngày bắt đầu: ${DateFormat('dd/MM/yyyy HH:mm').format(assignment.startAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
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
                      color:
                          assignment.isOverdue ? Colors.red : Colors.grey[600],
                      fontWeight: assignment.isOverdue
                          ? FontWeight.w500
                          : FontWeight.normal,
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
              Row(
                children: [
                  Icon(
                    Icons.timer,
                    size: 16,
                    color: Colors.purple[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Thời gian: ${assignment.durationMinutes} phút',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.purple[700],
                      fontWeight: FontWeight.w500,
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

  void _showAssignmentDetail(
      BuildContext context, Assignment assignment) async {
    await showModalBottomSheet(
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
                        // ignore: deprecated_member_use
                        color: assignment.statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          // ignore: deprecated_member_use
                          color: assignment.statusColor.withOpacity(0.3),
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

                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey[300]!,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ngày bắt đầu
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.orange, size: 18),
                          const SizedBox(width: 8),
                          const Text(
                            'Ngày bắt đầu: ',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy - HH:mm').format(assignment.startAt),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Hạn nộp bài
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: assignment.isOverdue ? Colors.red : Colors.blue,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Hạn nộp: ',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy - HH:mm').format(assignment.endAt),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: assignment.isOverdue ? Colors.red : Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Thời gian làm bài
                      Row(
                        children: [
                          const Icon(Icons.timer, color: Colors.purple, size: 18),
                          const SizedBox(width: 8),
                          const Text(
                            'Thời gian làm bài: ',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          Text(
                            '${assignment.durationMinutes} phút',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Số câu hỏi
                      Row(
                        children: [
                          const Icon(Icons.help_outline, color: Colors.cyan, size: 18),
                          const SizedBox(width: 8),
                          const Text(
                            'Số câu hỏi: ',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          Text(
                            '${assignment.questionCount}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.cyan,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                if (assignment.isNotStartedYet)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'Chưa tới ngày kiểm tra',
                        style: TextStyle(
                          color: Colors.yellow[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

// Thông báo quá hạn
                if (assignment.isOverdue && !assignment.isSubmitted)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Bài kiểm tra đã quá hạn nộp',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (!assignment.isNotStartedYet) ...[
                  // Nút bắt đầu làm bài
                  if (!assignment.isSubmitted && !assignment.isOverdue)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExamScreen(exerciseId: assignment.id),
                            ),
                          );
                          if (result == true) {
                            Provider.of<ExerciseProvider>(context, listen: false)
                                .fetchAssignments(assignment.classId);
                          }
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

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: assignment.isDisabled
                              ? null
                              : (assignment.isSubmitted || assignment.isExpired)
                              ? () {
                            Navigator.pushNamed(
                              context, '/discussion-list',
                              arguments: {
                                'exerciseId': assignment.id,
                              },
                            );
                          }
                              : null,
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
                              : (assignment.isSubmitted || assignment.isExpired)
                              ? () {
                            Navigator.pushNamed(
                              context, '/result',
                              arguments: {
                                'exerciseId': assignment.id,
                              },
                            );
                          }
                              : null,
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
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
