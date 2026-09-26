import 'package:flutter/material.dart';
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

  final List<LeaderboardUser> _streakLeaders = const [
    LeaderboardUser(rank: 1, name: 'Soran Farhad', avatarUrl: 'assets/images/user_avatar.jpg', stat: '42 Days Streak 🔥', tier: 'Elite Beast 👑'),
    LeaderboardUser(rank: 2, name: 'Karwan Hama', avatarUrl: 'assets/images/onboarding_athlete.jpg', stat: '38 Days Streak 🔥', tier: 'Diamond 💎'),
    LeaderboardUser(rank: 3, name: 'Darya Ahmed', avatarUrl: 'assets/images/user_avatar.jpg', stat: '31 Days Streak 🔥', tier: 'Diamond 💎'),
    LeaderboardUser(rank: 4, name: 'Aryan Rathore (You)', avatarUrl: 'assets/images/user_avatar.jpg', stat: '14 Days Streak 🔥', tier: 'Gold 🥇', isCurrentUser: true),
    LeaderboardUser(rank: 5, name: 'Bawer Ali', avatarUrl: 'assets/images/onboarding_athlete.jpg', stat: '12 Days Streak 🔥', tier: 'Gold 🥇'),
    LeaderboardUser(rank: 6, name: 'Rawand Othman', avatarUrl: 'assets/images/user_avatar.jpg', stat: '11 Days Streak 🔥', tier: 'Silver 🥈'),
    LeaderboardUser(rank: 7, name: 'Hevar Sleman', avatarUrl: 'assets/images/onboarding_athlete.jpg', stat: '9 Days Streak 🔥', tier: 'Silver 🥈'),
  ];

  final List<LeaderboardUser> _lifterLeaders = const [
    LeaderboardUser(rank: 1, name: 'Karwan Hama', avatarUrl: 'assets/images/onboarding_athlete.jpg', stat: '585 kg Big 3', tier: 'Elite Beast 👑'),
    LeaderboardUser(rank: 2, name: 'Aryan Rathore (You)', avatarUrl: 'assets/images/user_avatar.jpg', stat: '445 kg Big 3', tier: 'Diamond 💎', isCurrentUser: true),
    LeaderboardUser(rank: 3, name: 'Soran Farhad', avatarUrl: 'assets/images/user_avatar.jpg', stat: '430 kg Big 3', tier: 'Gold 🥇'),
    LeaderboardUser(rank: 4, name: 'Zana Qadir', avatarUrl: 'assets/images/onboarding_athlete.jpg', stat: '390 kg Big 3', tier: 'Gold 🥇'),
    LeaderboardUser(rank: 5, name: 'Alan Sherwan', avatarUrl: 'assets/images/user_avatar.jpg', stat: '375 kg Big 3', tier: 'Silver 🥈'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
