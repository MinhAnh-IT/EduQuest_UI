import 'package:edu_quest/feature/discussion/models/discussion_model.dart';
import 'package:edu_quest/feature/discussion/providers/discussion_comment_provider.dart';
import 'package:edu_quest/feature/discussion/services/discussion_comment_service.dart';
import 'package:edu_quest/shared/utils/accessTokenUtill.dart';
import 'package:edu_quest/shared/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'comment_bubble_screen.dart'; // Import CommentBubble ở đây

class DiscussionCommentScreen extends StatefulWidget {
  final Discussion discussion;
  const DiscussionCommentScreen({Key? key, required this.discussion})
      : super(key: key);

  @override
  State<DiscussionCommentScreen> createState() =>
      _DiscussionCommentScreenState();
}

class _DiscussionCommentScreenState extends State<DiscussionCommentScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late DiscussionCommentProvider commentProvider;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    commentProvider = DiscussionCommentProvider(
      api: DiscussionCommentApiService(),
      discussionId: widget.discussion.id,
    );
    _init();
  }

  Future<void> _init() async {
    await commentProvider.loadComments();
    final userId = await AccessTokenUtil.getUserId();
    setState(() {
      _currentUserId = userId;
    });
    commentProvider.connectWebSocket('http://localhost:8080/ws');

    commentProvider.addListener(() {
      if (_scrollController.hasClients) {
        Future.delayed(const Duration(milliseconds: 150), () {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    commentProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: commentProvider,
      child: Consumer<DiscussionCommentProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: CustomAppBar(
                title: widget.discussion.content,
                foregroundColor: Colors.white,
                centerTitle: true,
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
                            ? const Center(
                                child: Text("Chưa có bình luận nào!"))
                            : ListView.separated(
                                controller: _scrollController,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                itemCount: provider.comments.length,
                                itemBuilder: (ctx, i) => CommentBubble(
                                    comment: provider.comments[i],
                                    isMe: provider.comments[i].createdBy ==
                                        _currentUserId,
                                    onLike: () {
                                      provider.sendLike(provider.comments[i].id, true);
                                    }),
                                separatorBuilder: (ctx, i) =>
                                    const SizedBox(height: 9),
                              )),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 30, right: 8, bottom: 6, top: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Nhập bình luận...',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 0),
                            ),
                            minLines: 1,
                            maxLines: 4,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send, color: Colors.blue),
                          onPressed: (_currentUserId == null)
                              ? null
                              : () {
                                  final text = _controller.text.trim();
                                  if (text.isEmpty) return;
                                  provider.sendComment(text, _currentUserId!);
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
        },
      ),
    );
  }
}
