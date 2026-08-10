import 'package:flutter/material.dart';
import 'package:quiz_app/screens/achievement.dart';
import 'package:quiz_app/screens/edit_profile.dart';
import 'package:quiz_app/screens/policy.dart';
import 'package:quiz_app/services/auth_service.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = 'User';
  String _email = 'email@example.com';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final username = await AuthService.getUsername();
    final email = await AuthService.getEmail();
    if (!mounted) return;
    setState(() {
      _username = username ?? 'User';
      _email = email ?? 'email@example.com';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            _ProfileHeader(_username, email: _email, imageUrl: null),
            const SizedBox(height: 28),
            _MenuSection(
              children: [
                _ProfileMenuItem(
                  icon: Icons.person_outline,
                  label: 'Edit Profile',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),
                _ProfileMenuItem(
                  icon: Icons.emoji_events_outlined,
                  label: 'Achievements',
                  onTap: () {
                    // TODO: Navigate to achievements screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AchievementScreen(),
                      ),
                    );
                  },
                ),
                _ProfileMenuItem(
                  icon: Icons.privacy_tip_outlined,
                  label: 'Policy',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PolicyScreen(),
                      ),
                    );
                  },
                ),
                _ProfileMenuItem(
                  icon: Icons.logout,
                  label: 'Logout',
                  iconColor: Colors.redAccent,
                  labelColor: Colors.redAccent,
                  showDivider: false,
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // TODO: Handle actual logout logic (clear session, navigate to login, etc.)
              AuthService.logout().then((_) {
                // Navigate to login screen or any other appropriate action
                Navigator.pushReplacementNamed(context, '/login');
              });
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? imageUrl;

  const _ProfileHeader(this.name, {required this.email, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: imageUrl != null
                  ? NetworkImage(imageUrl!)
                  : null,
              child: imageUrl == null
                  ? const Icon(Icons.person, size: 55, color: Colors.white)
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  // TODO: Handle image picker for updating profile photo
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class _MenuSection extends StatelessWidget {
  final List<Widget> children;

  const _MenuSection({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;
  final bool showDivider;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.labelColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: iconColor ?? Colors.grey.shade700),
          title: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: labelColor ?? Colors.black87,
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: onTap,
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 56,
            endIndent: 16,
            color: Colors.grey.shade200,
          ),
      ],
    );
  }
}
