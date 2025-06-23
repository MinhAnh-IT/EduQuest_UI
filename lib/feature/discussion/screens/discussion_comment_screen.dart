import 'package:edu_quest/feature/discussion/models/discussion_model.dart';
import 'package:edu_quest/feature/discussion/providers/discussion_provider.dart';
import 'package:edu_quest/feature/discussion/screens/comment_bubble_screen.dart';
import 'package:edu_quest/shared/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscussionCommentScreen extends StatefulWidget {
  final Discussion discussion;
  const DiscussionCommentScreen({super.key, required this.discussion});

  @override
  State<DiscussionCommentScreen> createState() => _DiscussionCommentScreenState();
}

class _DiscussionCommentScreenState extends State<DiscussionCommentScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DiscussionProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(title: widget.discussion.title,
          foregroundColor: Colors.white, centerTitle: true,
          backgroundColor: Colors.blueAccent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).maybePop(),
          )),
      body: Column(
        children: [
          Expanded(
            child: provider.loading
                ? const Center(child: CircularProgressIndicator())
                : provider.comments.isEmpty
                    ? const Center(child: Text("Chưa có bình luận nào!"))
                    : ListView.builder(
                        reverse: true,
                        itemCount: provider.comments.length,
                        itemBuilder: (ctx, i) =>
                            CommentBubble(comment: provider.comments[i]),
                      ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.emoji_emotions), onPressed: () {}),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Nhập bình luận...',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24)),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      ),
                      minLines: 1,
                      maxLines: 4,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () async {
                      if (_controller.text.trim().isEmpty) return;
                      await provider.addComment(
                          widget.discussion.id, _controller.text.trim());
                      _controller.clear();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
