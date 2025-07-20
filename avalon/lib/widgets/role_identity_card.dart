import 'package:flutter/material.dart';
import '../models/role.dart';
import '../constants/assets.dart';

class RoleIdentityCard extends StatelessWidget {
  final Role role;
  final String extraInfo;
  final String roleDesc;
  final String? bottomHint;
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final bool scrollable;
  final double topOffset; // ← 新增：上方留白（讓文字整體往下）

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
    this.topOffset = 48,              // 預設往下推，可調整
  }) : super(key: key);

  String _assetFor(Role r) {
    return r.map(
      merlin: (_) => AppAssets.images.roleMerlin,
      percival: (_) => AppAssets.images.rolePercival,
      loyalServant: (_) => AppAssets.images.roleLoyal,
      assassin: (_) => AppAssets.images.roleAssassin,
      morgana: (_) => AppAssets.images.roleMorgana,
      mordred: (_) => AppAssets.images.roleMordred,
      oberon: (_) => AppAssets.images.roleOberon,
      minion: (_) => AppAssets.images.roleMinion,
    );
  }

  @override
  Widget build(BuildContext context) {
    final column = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: topOffset), // ← 推下整體內容
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
        const SizedBox(height: 20),
        Text(
          role.name,
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          extraInfo,
          style: const TextStyle(
            fontSize: 18,
            height: 1.33,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 14),
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
          const SizedBox(height: 26),
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
          image: DecorationImage(
            image: AssetImage(AppAssets.images.cardFront),
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
                  child: column,
                )
              : column,
        ),
      ),
    );
  }
}
