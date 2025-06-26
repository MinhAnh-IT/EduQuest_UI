import 'package:edu_quest/feature/discussion/models/discussion_comment_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentBubble extends StatefulWidget {
  final DiscussionComment comment;
  final bool isMe;
  final void Function()? onLike;

  const CommentBubble({
    Key? key,
    required this.comment,
    required this.isMe,
    this.onLike,
  }) : super(key: key);

  @override
  State<CommentBubble> createState() => _CommentBubbleState();
}

class _CommentBubbleState extends State<CommentBubble> {
  bool _showTime = false;

  @override
  Widget build(BuildContext context) {
    final time =
        DateFormat('HH:mm dd/MM/yyyy').format(widget.comment.createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Column(
        crossAxisAlignment:
            widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (_showTime)
            Padding(
              padding: EdgeInsets.only(
                left: widget.isMe ? 60 : 50,
                right: widget.isMe ? 50 : 50,
                top: 3,
                bottom: 2,
              ),
              child: Text(
                time,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          // Row chứa avatar + bubble
          GestureDetector(
            onTap: () => setState(() => _showTime = !_showTime),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment:
                  widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: widget.isMe
                  ? [
                      Flexible(child: _bubble(context)),
                      const SizedBox(width: 8),
                      _avatar(),
                    ]
                  : [
                      _avatar(),
                      const SizedBox(width: 8),
                      Flexible(child: _bubble(context)),
                    ],
            ),
          ),
          Row(
            mainAxisAlignment:
                widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: widget.isMe ? 60 : 48,
                  right: widget.isMe ? 40 : 60, 
                  top: 2,
                ),
                child: _likeButton(context, alignRight: widget.isMe),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _avatar() {
    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.blue[100],
      backgroundImage: (widget.comment.createdByAvatar != null &&
              widget.comment.createdByAvatar!.isNotEmpty)
          ? NetworkImage(widget.comment.createdByAvatar!)
          : null,
      child: (widget.comment.createdByAvatar == null ||
              widget.comment.createdByAvatar!.isEmpty)
          ? Text(
              widget.comment.createdByName.isNotEmpty
                  ? widget.comment.createdByName[0].toUpperCase()
                  : "?",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontSize: 16,
              ),
            )
          : null,
    );
  }

  Widget _bubble(BuildContext context) {
    return Container(
      margin: widget.isMe
          ? const EdgeInsets.only(left: 40)
          : const EdgeInsets.only(right: 40),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: widget.isMe ? const Color(0xFF0078FF) : Colors.grey[200],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.isMe ? 16 : 0),
          topRight: Radius.circular(widget.isMe ? 0 : 16),
          bottomLeft: const Radius.circular(16),
          bottomRight: const Radius.circular(16),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment:
            widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!widget.isMe)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                widget.comment.createdByName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 13,
                ),
              ),
            ),
          Text(
            widget.comment.content,
            style: TextStyle(
              color: widget.isMe ? Colors.white : Colors.black87,
              fontSize: 15,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _likeButton(BuildContext context, {required bool alignRight}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: widget.onLike,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.thumb_up_alt_outlined,
              size: 16,
              color: alignRight ? Colors.blue[400] : Colors.grey[500],
            ),
            const SizedBox(width: 2),
            Text(
              '${widget.comment.voteCount}',
              style: TextStyle(
                fontSize: 12,
                color: alignRight ? Colors.blue[400] : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
