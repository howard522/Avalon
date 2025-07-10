/// 決定每回合隊伍人數
class TeamSizeFactory {
  /// roundNumber 從 1 開始
  static int teamSize(int playerCount, int roundNumber) {
    final table = {
      5: [2, 3, 2, 3, 3],
      6: [2, 3, 4, 3, 4],
      7: [2, 3, 3, 4, 4],
      8: [3, 4, 4, 5, 5],
      9: [3, 4, 4, 5, 5],
      10: [3, 4, 4, 5, 5],
    };
    final rounds = table[playerCount] ?? table[5]!;
    return rounds[roundNumber - 1];
  }
}