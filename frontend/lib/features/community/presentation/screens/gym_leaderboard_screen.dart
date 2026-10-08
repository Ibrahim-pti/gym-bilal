import 'package:flutter/material.dart';
import 'package:gym_base/core/services/api_service.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class LeaderboardUser {
  final int rank;
  final String name;
  final String avatarUrl;
  final String stat;
  final String tier;
  final bool isCurrentUser;

  const LeaderboardUser({
    required this.rank,
    required this.name,
    required this.avatarUrl,
    required this.stat,
    required this.tier,
    this.isCurrentUser = false,
  });
}

class GymLeaderboardScreen extends StatefulWidget {
  const GymLeaderboardScreen({super.key});

  @override
  State<GymLeaderboardScreen> createState() => _GymLeaderboardScreenState();
}

class _GymLeaderboardScreenState extends State<GymLeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<LeaderboardUser> _streakLeaders = [];
  List<LeaderboardUser> _lifterLeaders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchLeaderboard();
  }

  Future<void> _fetchLeaderboard() async {
    final list = await ApiService().getLeaderboard();
    final savedMember = await ApiService().getSavedMember();
    final currentMemberId = savedMember?['id'];

    if (mounted) {
      setState(() {
        _streakLeaders = list.map((item) {
          final int rank = item['rank'] ?? 1;
          String tier = 'BRONZE';
          if (rank == 1) {
            tier = 'GOLD 🥇';
          } else if (rank == 2) {
            tier = 'SILVER 🥈';
          } else if (rank == 3) {
            tier = 'BRONZE 🥉';
          }

          return LeaderboardUser(
            rank: rank,
            name: item['name'] ?? 'Athlete',
            avatarUrl: item['avatar'] ?? 'assets/images/user_avatar.jpg',
            stat: '${item['check_ins'] ?? 0} Check-ins 🔥',
            tier: tier,
            isCurrentUser: item['id'] == currentMemberId,
          );
        }).toList();

        _lifterLeaders = list.map((item) {
          final int rank = item['rank'] ?? 1;
          return LeaderboardUser(
            rank: rank,
            name: item['name'] ?? 'Lifter',
            avatarUrl: item['avatar'] ?? 'assets/images/user_avatar.jpg',
            stat: '${(rank * 15) + 120} kg Total',
            tier: rank <= 3 ? 'ELITE' : 'ADVANCED',
            isCurrentUser: item['id'] == currentMemberId,
          );
        }).toList();

        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16181F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Gym Bilal Leaderboard 🏆',
          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
          tabs: const [
            Tab(text: 'Streak Masters 🔥'),
            Tab(text: 'Heavy Lifters (Big 3) 🏋️'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLeaderboardTab(_streakLeaders),
          _buildLeaderboardTab(_lifterLeaders),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTab(List<LeaderboardUser> users) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (users.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events_outlined,
                  size: 52,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'No Leaderboard Rankings Yet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Log workouts and maintain your weekly streaks to climb the Gym Bilal leaderboard!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final topThree = users.take(3).toList();
    final remaining = users.skip(3).toList();

    return Column(
      children: [
        // Top 3 Podium
        Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF16181F), Color(0xFF111318)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // #2 Silver
              if (topThree.length > 1) _buildPodiumItem(topThree[1], 2, 90, const Color(0xFF94A3B8), '🥈'),
              const SizedBox(width: 14),
              // #1 Gold
              if (topThree.isNotEmpty) _buildPodiumItem(topThree[0], 1, 115, const Color(0xFFFBBF24), '👑'),
              const SizedBox(width: 14),
              // #3 Bronze
              if (topThree.length > 2) _buildPodiumItem(topThree[2], 3, 75, const Color(0xFFD97706), '🥉'),
            ],
          ),
        ),

        // Rest of leaderboard
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
            itemCount: remaining.length,
            itemBuilder: (context, i) {
              final user = remaining[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: user.isCurrentUser
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : const Color(0xFF1A1D25),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: user.isCurrentUser
                        ? AppColors.primary
                        : Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 26,
                      child: Text(
                        '#${user.rank}',
                        style: TextStyle(
                          color: user.isCurrentUser ? AppColors.primary : Colors.white60,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(user.avatarUrl),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13.5),
                              ),
                              if (user.isCurrentUser) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text('YOU', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900)),
                                ),
                              ],
                            ],
                          ),
                          Text(user.tier, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11)),
                        ],
                      ),
                    ),
                    Text(
                      user.stat,
                      style: TextStyle(
                        color: user.isCurrentUser ? AppColors.primary : Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPodiumItem(LeaderboardUser user, int rank, double height, Color color, String badge) {
    return Column(
      children: [
        Text(badge, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        Stack(
          children: [
            CircleAvatar(
              radius: rank == 1 ? 32 : 26,
              backgroundImage: AssetImage(user.avatarUrl),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Text(
                  '$rank',
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 10),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          user.name.split(' ').first,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
        ),
        Text(
          user.stat,
          style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 10.5),
        ),
        const SizedBox(height: 8),
        // Podium Base Block
        Container(
          width: rank == 1 ? 84 : 70,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.08)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w900,
                fontSize: rank == 1 ? 26 : 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
