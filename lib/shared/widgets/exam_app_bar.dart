import 'package:flutter/material.dart';

class ExamAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onSubmit;
  final bool showSubmitButton;

  const ExamAppBar({
    super.key,
    required this.title,
    this.onSubmit,
    this.showSubmitButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white,),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      actions: [
        if (showSubmitButton && onSubmit != null) // Chỉ hiển thị khi showSubmitButton = true
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              height: 36,
              width: 87,
              child: ElevatedButton(
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  textStyle:
                      const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Nộp bài"),
              ),
            ),
          )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}