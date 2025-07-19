/// MissionVoteRevealPage 的路由參數
class MissionRevealArgs {
  final int teamSize;      // 本回合投票人數
  final int successCount;  // 成功票數
  final int failCount;     // 失敗票數

  const MissionRevealArgs({
    required this.teamSize,
    required this.successCount,
    required this.failCount,
  });
}
