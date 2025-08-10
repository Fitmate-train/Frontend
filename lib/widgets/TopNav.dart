import 'package:flutter/material.dart';

class TopNav extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoggedIn;
  final VoidCallback? onLoginPressed;
  final VoidCallback? onProfilePressed;

  const TopNav({
    super.key,
    required this.isLoggedIn,
    this.onLoginPressed,
    this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'FitMate',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        isLoggedIn
            ? IconButton(
              icon: const Icon(Icons.account_circle, size: 28),
              onPressed:
                  onProfilePressed ??
                  () {
                    Navigator.pushNamed(context, '/profile');
                  },
            )
            : TextButton(
              onPressed:
                  onLoginPressed ??
                  () {
                    Navigator.pushNamed(context, '/login');
                  },
              child: const Text(
                '로그인',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
