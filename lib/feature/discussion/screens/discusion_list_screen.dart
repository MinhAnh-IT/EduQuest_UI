import 'package:edu_quest/feature/discussion/providers/discussion_provider.dart';
import 'package:edu_quest/feature/discussion/screens/discussion_comment_screen.dart';
import 'package:edu_quest/shared/widgets/bottom_navigation_bar.dart';
import 'package:edu_quest/shared/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscussionListScreen extends StatefulWidget {
  final int exerciseId;
  const DiscussionListScreen({Key? key, required this.exerciseId})
      : super(key: key);

  @override
  State<DiscussionListScreen> createState() => _DiscussionListScreenState();
}

class _DiscussionListScreenState extends State<DiscussionListScreen> {
  int _currentIndex = 0; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DiscussionProvider>(context, listen: false)
          .loadDiscussionsByExercise(widget.exerciseId);
    });
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
            onPressed: () => _showCreateDiscussionDialog(context),
          ),
        ],
      ),
      body: Consumer<DiscussionProvider>(
        builder: (context, provider, _) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.discussions.isEmpty) {
            return const Center(
                child: Text("Chưa có thảo luận nào cho bài tập này!"));
          }
          return ListView.builder(
            itemCount: provider.discussions.length,
            itemBuilder: (ctx, i) {
              final d = provider.discussions[i];
              return ListTile(
                leading: const Icon(Icons.forum, color: Colors.blue),
                title: Text(d.title),
                subtitle: Text('Tạo bởi ${d.authorName}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  await provider.loadComments(d.id);
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => DiscussionCommentScreen(discussion: d),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
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
            onPressed: () async {
              final title = _titleController.text.trim();
              if (title.isEmpty) return;
              await Provider.of<DiscussionProvider>(context, listen: false)
                  .addDiscussion(widget.exerciseId, title, "Bạn");
              Navigator.of(ctx).pop();
            },
            child: const Text('Tạo'),
          ),
        ],
      ),
    );
  }
}
