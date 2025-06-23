import 'package:edu_quest/feature/discussion/models/discussion_model.dart';
import 'package:flutter/material.dart';

class CommentBubble extends StatelessWidget {
  final DiscussionComment comment;
  const CommentBubble({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    bool isMe = comment.authorName == "Bạn";
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Card(
        color: isMe ? Colors.blue[100] : Colors.white,
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage(comment.avatarUrl)),
                  const SizedBox(width: 8),
                  Text(comment.authorName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Text(timeAgo(comment.createdAt),
                      style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 4),
              Text(comment.content),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.thumb_up_alt_outlined, size: 18),
                    onPressed: () {/* upvote */},
                  ),
                  Text('${comment.votes}'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

String timeAgo(DateTime dt) {
  final diff = DateTime.now().difference(dt);
  if (diff.inMinutes < 1) return 'Vừa xong';
  if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
  if (diff.inHours < 24) return '${diff.inHours} giờ trước';
  return '${diff.inDays} ngày trước';
}
