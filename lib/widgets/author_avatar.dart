import "package:flutter/material.dart";

class AuthorAvatar extends StatelessWidget {
  final String name;
  final String avatarUrl;

  const AuthorAvatar({super.key, required this.name, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65,
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(radius: 28, backgroundImage: NetworkImage(avatarUrl)),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
