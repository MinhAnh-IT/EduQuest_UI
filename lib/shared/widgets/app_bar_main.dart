import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const MyAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            // Xử lý theo lựa chọn
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'option1', child: Text('Tùy chọn 1')),
            const PopupMenuItem(value: 'option2', child: Text('Tùy chọn 2')),
          ],
        ),
      ],
      title: Text(title, textAlign: TextAlign.center),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).maybePop();
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
