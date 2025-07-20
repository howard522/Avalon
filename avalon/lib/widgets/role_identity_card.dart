import 'package:flutter/material.dart';
import '../models/role.dart';

/// 共用：角色身份卡顯示
class RoleIdentityCard extends StatelessWidget {
  final Role role;
  final String extraInfo;      // 動態資訊（隊友 / 可見壞人 / 等）
  final String roleDesc;       // 靜態描述（規則文字）
  final String? bottomHint;    // 底部提示（例如：點擊交給下一位）
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final bool scrollable;

  const RoleIdentityCard({
    Key? key,
    required this.role,
    required this.extraInfo,
    required this.roleDesc,
    this.bottomHint,
    this.width = 360,
    this.height = 560,
    this.padding = const EdgeInsets.fromLTRB(20, 28, 20, 24),
    this.scrollable = true,
  }) : super(key: key);

  String _assetFor(Role r) {
    return r.map(
      merlin: (_) => 'assets/images/role_merlin.png',
      percival: (_) => 'assets/images/role_percival.png',
      loyalServant: (_) => 'assets/images/role_loyal.png',
      assassin: (_) => 'assets/images/role_assassin.png',
      morgana: (_) => 'assets/images/role_morgana.png',
      mordred: (_) => 'assets/images/role_mordred.png',
      oberon: (_) => 'assets/images/role_oberon.png',
      minion: (_) => 'assets/images/role_minion.png',
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(
          child: Image.asset(
            _assetFor(role),
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 120,
              height: 120,
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: Text(
                role.name.characters.first.toUpperCase(),
                style: const TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          role.name,
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 14),
        Text(
          extraInfo,
          style: const TextStyle(
            fontSize: 18,
            height: 1.33,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          roleDesc,
          style: const TextStyle(
            fontSize: 14,
            height: 1.3,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
        if (bottomHint != null) ...[
          const SizedBox(height: 22),
          Text(
            bottomHint!,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black45,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/card_front_placeholder.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.18),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: padding,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: scrollable
              ? SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: content,
                )
              : content,
        ),
      ),
    );
  }
}
