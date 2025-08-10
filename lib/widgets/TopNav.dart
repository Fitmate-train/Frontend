import 'package:flutter/material.dart';

class TopNav extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoggedIn;
  final VoidCallback? onLoginPressed;
  final VoidCallback? onLogoutPressed;
  final VoidCallback? onProfilePressed;

  const TopNav({
    super.key,
    required this.isLoggedIn,
    this.onLoginPressed,
    this.onLogoutPressed,
    this.onProfilePressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: const Text('FitMate', style: TextStyle(color: Colors.black)),
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        // ✅ 로그인/로그아웃 토글, 글씨색 검정
        TextButton(
          onPressed:
              isLoggedIn
                  ? (onLogoutPressed ??
                      onLoginPressed) // onLogoutPressed 없으면 로그인 콜백 재사용
                  : onLoginPressed,
          style: TextButton.styleFrom(foregroundColor: Colors.black),
          child: Text(isLoggedIn ? '로그아웃' : '로그인'),
        ),
        IconButton(
          onPressed: onProfilePressed,
          icon: const Icon(Icons.person_outline),
          color: Colors.black,
          tooltip: '마이페이지',
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
