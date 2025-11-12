import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edgeup_upsc_app/core/utils/app_theme.dart';
import 'package:edgeup_upsc_app/core/utils/theme_manager.dart';
import 'package:edgeup_upsc_app/core/utils/page_transitions.dart';
import 'package:edgeup_upsc_app/features/auth/presentation/pages/login_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Create staggered animations for different sections
    _fadeAnimations = List.generate(6, (index) {
      final start = index * 0.08;
      final end = start + 0.4;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end.clamp(0.0, 1.0), curve: Curves.easeOut),
        ),
      );
    });

    _slideAnimations = List.generate(6, (index) {
      final start = index * 0.08;
      final end = start + 0.4;
      return Tween<Offset>(
        begin: const Offset(0, 0.15),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end.clamp(0.0, 1.0), curve: Curves.easeOutCubic),
        ),
      );
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleLogout(BuildContext context) {
    Navigator.of(context).pushReplacement(
      FadePageRoute(page: const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppTheme.darkGradient : AppTheme.subtleGradient,
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Custom App Bar
              SliverAppBar(
                expandedHeight: 160,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 60, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: AppTheme.premiumGradient,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryViolet.withAlpha(76),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.school_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back!',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    'EdgeUp UPSC',
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          color: AppTheme.primaryViolet,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  // Theme toggle
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      onPressed: () => themeManager.toggleTheme(),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withAlpha(25)
                              : Colors.white.withAlpha(200),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? Colors.white.withAlpha(25) : AppTheme.lightBorder,
                          ),
                        ),
                        child: Icon(
                          isDark ? Icons.light_mode : Icons.dark_mode,
                          color: isDark ? AppTheme.primaryViolet : AppTheme.lightTextPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  // Logout
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: IconButton(
                      onPressed: () => _handleLogout(context),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withAlpha(25)
                              : Colors.white.withAlpha(200),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? Colors.white.withAlpha(25) : AppTheme.lightBorder,
                          ),
                        ),
                        child: Icon(
                          Icons.logout,
                          color: isDark ? Colors.red.shade300 : Colors.red.shade700,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Content
              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Quick Stats Card
                    FadeTransition(
                      opacity: _fadeAnimations[0],
                      child: SlideTransition(
                        position: _slideAnimations[0],
                        child: _buildGlassCard(
                          isDark: isDark,
                          child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: AppTheme.premiumGradient,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.trending_up,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Today\'s Progress',
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    Text(
                                      'Keep up the great work!',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                _buildStatItem(context, isDark, '5', 'Hours', Icons.schedule),
                                const SizedBox(width: 24),
                                _buildStatItem(context, isDark, '12', 'Topics', Icons.menu_book),
                                const SizedBox(width: 24),
                                _buildStatItem(context, isDark, '85%', 'Score', Icons.star),
                              ],
                            ),
                          ],
                        ),
                      ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Study Materials Section
                    FadeTransition(
                      opacity: _fadeAnimations[1],
                      child: SlideTransition(
                        position: _slideAnimations[1],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Study Materials',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            _buildStudyMaterialsGrid(context, isDark),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Daily Goals Section
                    FadeTransition(
                      opacity: _fadeAnimations[2],
                      child: SlideTransition(
                        position: _slideAnimations[2],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today\'s Goals',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            _buildDailyGoalsCard(context, isDark),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Mock Tests Section
                    FadeTransition(
                      opacity: _fadeAnimations[3],
                      child: SlideTransition(
                        position: _slideAnimations[3],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mock Tests',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            _buildMockTestsSection(context, isDark),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Performance Analytics
                    FadeTransition(
                      opacity: _fadeAnimations[4],
                      child: SlideTransition(
                        position: _slideAnimations[4],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Performance Analytics',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            _buildPerformanceCard(context, isDark),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Recent Activity
                    FadeTransition(
                      opacity: _fadeAnimations[5],
                      child: SlideTransition(
                        position: _slideAnimations[5],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recent Activity',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            _buildRecentActivityCard(context, isDark),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Premium CTA
                    _buildGlassCard(
                      isDark: isDark,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: AppTheme.premiumGradient,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.workspace_premium,
                              color: Colors.white,
                              size: 40,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Unlock Premium Features',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Get unlimited access to all features and content',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withAlpha(230),
                                  ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppTheme.primaryViolet,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 28,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'Upgrade Now',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard({required bool isDark, required Widget child}) {
    return Container(
      decoration: AppTheme.glassCard(isDark: isDark),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, bool isDark, String value, String label, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: AppTheme.primaryViolet,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildStudyMaterialsGrid(BuildContext context, bool isDark) {
    final materials = [
      {'title': 'History', 'icon': Icons.history_edu, 'topics': '45', 'color': AppTheme.primaryViolet},
      {'title': 'Geography', 'icon': Icons.public, 'topics': '38', 'color': AppTheme.electricBlue},
      {'title': 'Polity', 'icon': Icons.account_balance, 'topics': '52', 'color': AppTheme.accentPurple},
      {'title': 'Economics', 'icon': Icons.trending_up, 'topics': '41', 'color': AppTheme.primaryViolet},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: materials.length,
      itemBuilder: (context, index) {
        final material = materials[index];
        return _buildGlassCard(
          isDark: isDark,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [material['color'] as Color, (material['color'] as Color).withAlpha(179)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (material['color'] as Color).withAlpha(51),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      material['icon'] as IconData,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    material['title'] as String,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${material['topics']} topics',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDailyGoalsCard(BuildContext context, bool isDark) {
    final goals = [
      {'title': 'Complete 2 mock tests', 'completed': true},
      {'title': 'Study 50 flashcards', 'completed': true},
      {'title': 'Read 3 articles', 'completed': false},
      {'title': 'Practice essay writing', 'completed': false},
    ];

    return _buildGlassCard(
      isDark: isDark,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: AppTheme.premiumGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.flag_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '2 of 4 completed',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
                Text(
                  '50%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primaryViolet,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...goals.map((goal) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(
                    goal['completed'] as bool ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: goal['completed'] as bool ? AppTheme.primaryViolet : (isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      goal['title'] as String,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            decoration: goal['completed'] as bool ? TextDecoration.lineThrough : null,
                            color: goal['completed'] as bool
                                ? (isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary)
                                : (isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary),
                          ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildMockTestsSection(BuildContext context, bool isDark) {
    final tests = [
      {'title': 'Prelims 2024 - Set 1', 'duration': '2h', 'questions': '100', 'attempted': false},
      {'title': 'Current Affairs Weekly', 'duration': '1h', 'questions': '50', 'attempted': true},
      {'title': 'CSAT Practice Test', 'duration': '2h', 'questions': '80', 'attempted': false},
    ];

    return Column(
      children: tests.map((test) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _buildGlassCard(
          isDark: isDark,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          test['attempted'] as bool ? Colors.green : AppTheme.electricBlue,
                          test['attempted'] as bool ? Colors.green.shade700 : AppTheme.accentPurple,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      test['attempted'] as bool ? Icons.check_circle_outline : Icons.quiz_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          test['title'] as String,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 14,
                              color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${test['duration']} • ${test['questions']} questions',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildPerformanceCard(BuildContext context, bool isDark) {
    final metrics = [
      {'label': 'Accuracy', 'value': 0.85, 'color': Colors.green},
      {'label': 'Speed', 'value': 0.72, 'color': AppTheme.electricBlue},
      {'label': 'Consistency', 'value': 0.91, 'color': AppTheme.primaryViolet},
    ];

    return _buildGlassCard(
      isDark: isDark,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: AppTheme.premiumGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.insights,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Your Performance',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...metrics.map((metric) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        metric['label'] as String,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        '${((metric['value'] as double) * 100).toInt()}%',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: metric['color'] as Color,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: metric['value'] as double,
                      backgroundColor: isDark
                          ? Colors.white.withAlpha(25)
                          : Colors.black.withAlpha(25),
                      valueColor: AlwaysStoppedAnimation<Color>(metric['color'] as Color),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard(BuildContext context, bool isDark) {
    final activities = [
      {
        'title': 'Completed Mock Test',
        'subtitle': 'Prelims 2024 - Set 1',
        'time': '2h ago',
        'icon': Icons.check_circle,
        'iconColor': Colors.green,
      },
      {
        'title': 'Studied Geography',
        'subtitle': '15 topics covered',
        'time': '5h ago',
        'icon': Icons.book,
        'iconColor': AppTheme.electricBlue,
      },
      {
        'title': 'Achieved Daily Goal',
        'subtitle': '7 day streak',
        'time': '1d ago',
        'icon': Icons.flag,
        'iconColor': AppTheme.primaryViolet,
      },
    ];

    return _buildGlassCard(
      isDark: isDark,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: activities.map((activity) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (activity['iconColor'] as Color).withAlpha(38),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    activity['icon'] as IconData,
                    color: activity['iconColor'] as Color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity['title'] as String,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        activity['subtitle'] as String,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Text(
                  activity['time'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                      ),
                ),
              ],
            ),
          )).toList(),
        ),
      ),
    );
  }
}
