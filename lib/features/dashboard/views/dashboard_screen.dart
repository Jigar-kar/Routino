import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../tasks/views/tasks_screen.dart';
import '../../expenses/views/expenses_screen.dart';
import '../../routines/views/routines_screen.dart';
import '../../notes/views/notes_screen.dart';
import '../../documents/views/documents_screen.dart';
import '../../user/providers/user_provider.dart';
import '../../user/views/user_form_screen.dart';
import '../../settings/views/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeView(),
    const RoutinesScreen(),
    const ExpensesScreen(),
    const DocumentsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppTheme.primaryLight,
        unselectedItemColor: AppTheme.textSecondary,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.repeat), label: 'Routines'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.dollarSign), label: 'Expenses'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.folder), label: 'Docs'),
        ],
      ),
    );
  }
}

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, ref),
            const SizedBox(height: 32),
            _buildTodayFocus(context),
            const SizedBox(height: 32),
            _buildGridSection(context),
            const SizedBox(height: 32),
            _buildRecentNotesSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userStreamProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Good Morning', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 4),
              userAsync.when(
                data: (user) => user != null
                  ? Text(user.name, style: Theme.of(context).textTheme.displaySmall)
                  : GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UserFormScreen())),
                      child: Text('Create Profile', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppTheme.primaryLight)),
                    ),
                loading: () => Text('Loading...', style: Theme.of(context).textTheme.displaySmall),
                error: (_, __) => Text('Error', style: Theme.of(context).textTheme.displaySmall),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          child: Container(
            height: 48,
            width: 48,
            decoration: const BoxDecoration(
              color: AppTheme.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.settings),
          ),
        ),
      ],
    );
  }

  Widget _buildTodayFocus(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Focus for Today", style: Theme.of(context).textTheme.headlineMedium),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TasksScreen())),
              child: Text('All Tasks', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.primaryLight)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TasksScreen())),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryLight.withValues(alpha: 0.3),
                  offset: const Offset(0, 8),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('High Priority', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Finish Quarterly Report',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GlassCard(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExpensesScreen())),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppTheme.success.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: const Icon(LucideIcons.wallet, color: AppTheme.success),
                ),
                const SizedBox(height: 16),
                Text('Expense', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text('Vault', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GlassCard(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RoutinesScreen())),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppTheme.warning.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: const Icon(LucideIcons.repeat, color: AppTheme.warning),
                ),
                const SizedBox(height: 16),
                Text('Routine', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text('Habits', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentNotesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Quick Notes', style: Theme.of(context).textTheme.headlineMedium),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotesScreen())),
              child: Text('View All', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.primaryLight)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GlassCard(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotesScreen())),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(color: AppTheme.primaryLight.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(LucideIcons.fileText, color: AppTheme.primaryLight, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Saved thoughts', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                    Text('Tap to open Notebook', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
