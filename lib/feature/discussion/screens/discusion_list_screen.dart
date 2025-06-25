import 'package:edu_quest/feature/discussion/providers/discussion_provider.dart';
import 'package:edu_quest/shared/utils/accessTokenUtill.dart';
import 'package:edu_quest/shared/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_quest/feature/discussion/screens/discussion_comment_screen.dart';

import 'package:intl/intl.dart';

class DiscussionListScreen extends StatefulWidget {
  final int exerciseId;
  const DiscussionListScreen({Key? key, required this.exerciseId}) : super(key: key);

  @override
  State<DiscussionListScreen> createState() => _DiscussionListScreenState();

  
}

class _DiscussionListScreenState extends State<DiscussionListScreen> {
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DiscussionProvider>(context, listen: false)
          .loadDiscussionsByExercise(widget.exerciseId);
    });
  }

  Future<void> _loadUserId() async {
    final id = await AccessTokenUtil.getUserId();
    setState(() {
      _currentUserId = id;
    });
  }

  bool _isOwner(int createdById) {
    return _currentUserId != null && createdById == _currentUserId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Thảo luận",
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Tạo thảo luận mới",
            onPressed: _currentUserId == null
                ? null
                : () => _showCreateDiscussionDialog(context),
          ),
        ],
      ),
      body: Consumer<DiscussionProvider>(
        builder: (context, provider, _) {
          if (provider.loading || _currentUserId == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }
          if (provider.discussions.isEmpty) {
            return const Center(child: Text("Chưa có thảo luận nào cho bài tập này!"));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: provider.discussions.length,
            separatorBuilder: (context, idx) => const SizedBox(height: 10),
            itemBuilder: (ctx, i) {
              final d = provider.discussions[i];
              final firstChar = d.createdByName.isNotEmpty
                  ? d.createdByName[0].toUpperCase()
                  : "?";
              final createdTime = d.createdAt != null
                  ? DateFormat('HH:mm dd/MM/yyyy').format(d.createdAt!)
                  : "";

              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => DiscussionCommentScreen(discussion: d),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blue[100],
                          backgroundImage:
                              (d.avatarUrl != null && d.avatarUrl!.isNotEmpty)
                                  ? NetworkImage(d.avatarUrl!)
                                  : null,
                          child: (d.avatarUrl == null || d.avatarUrl!.isEmpty)
                              ? Text(
                                  firstChar,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    fontSize: 20,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                d.content,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    d.createdByName,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (createdTime.isNotEmpty) ...[
                                    const SizedBox(width: 8),
                                    Icon(Icons.schedule,
                                        size: 14, color: Colors.grey[400]),
                                    const SizedBox(width: 2),
                                    Text(
                                      createdTime,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                              if (_isOwner(d.createdById))
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton.icon(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.blueAccent,
                                        ),
                                        icon: const Icon(Icons.edit, size: 18),
                                        label: const Text("Sửa",
                                            style: TextStyle(fontSize: 14)),
                                        onPressed: () =>
                                            _showEditDiscussionDialog(
                                                context, d),
                                      ),
                                      TextButton.icon(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.red,
                                        ),
                                        icon: const Icon(Icons.delete_outline,
                                            size: 18),
                                        label: const Text("Xoá",
                                            style: TextStyle(fontSize: 14)),
                                        onPressed: () =>
                                            _showDeleteDiscussionDialog(
                                                context, d),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right,
                            color: Colors.grey, size: 30),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showCreateDiscussionDialog(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tạo thảo luận mới'),
        content: TextField(
          controller: _titleController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Nhập tiêu đề thảo luận...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: (_currentUserId == null)
                ? null
                : () async {
                    final title = _titleController.text.trim();
                    if (title.isEmpty) return;
                    await Provider.of<DiscussionProvider>(context,
                            listen: false)
                        .addDiscussion(widget.exerciseId, title);
                    Navigator.of(ctx).pop();
                  },
            child: const Text('Tạo'),
          ),
        ],
      ),
    );
  }

  void _showEditDiscussionDialog(BuildContext context, var discussion) {
    final TextEditingController controller =
        TextEditingController(text: discussion.content);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sửa thảo luận'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Nhập nội dung mới...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newContent = controller.text.trim();
              if (newContent.isEmpty) return;
              await Provider.of<DiscussionProvider>(context, listen: false)
                  .editDiscussion(discussion.id.toString(), newContent);
              Navigator.of(ctx).pop();
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDiscussionDialog(BuildContext context, var discussion) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xoá thảo luận'),
        content: const Text('Bạn có chắc chắn muốn xoá thảo luận này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              await Provider.of<DiscussionProvider>(context, listen: false)
                  .deleteDiscussion(discussion.id.toString());
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
  }
}
