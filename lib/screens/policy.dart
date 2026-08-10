import 'package:flutter/material.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            Text(
              'Last updated: August 10, 2026',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            const _PolicyCard(
              children: [
                _PolicySection(
                  title: '1. Introduction',
                  body:
                      'Welcome to QuizApp. We respect your privacy and are committed to protecting the personal data you share with us. This policy explains what information we collect, how we use it, and the choices you have.',
                ),
                _PolicySection(
                  title: '2. Information We Collect',
                  body:
                      'We may collect your name, email address, profile photo, and quiz activity such as scores, categories played, and achievements. If you sign in with a third-party account, we receive basic profile details from that provider.',
                ),
                _PolicySection(
                  title: '3. How We Use Your Information',
                  body:
                      'We use your information to create and manage your account, track your progress and leaderboard rankings, personalize quiz recommendations, send important updates, and improve app performance and features.',
                ),
                _PolicySection(
                  title: '4. Data Sharing',
                  body:
                      'We do not sell your personal data. We may share limited information with trusted service providers who help us operate the app (such as hosting or analytics), and only to the extent necessary for them to perform their services.',
                ),
                _PolicySection(
                  title: '5. Leaderboards & Public Profiles',
                  body:
                      'Your username, avatar, and score may be visible to other users on public leaderboards. You can control what information appears on your public profile from the Edit Profile screen.',
                ),
                _PolicySection(
                  title: '6. Data Security',
                  body:
                      'We use industry-standard measures to protect your data from unauthorized access, alteration, or loss. However, no method of transmission over the internet is 100% secure.',
                ),
                _PolicySection(
                  title: '7. Children\'s Privacy',
                  body:
                      'QuizApp is not directed at children under 13. We do not knowingly collect personal information from children under 13. If you believe a child has provided us data, please contact us to remove it.',
                ),
                _PolicySection(
                  title: '8. Your Rights',
                  body:
                      'You may access, update, or delete your account information at any time from the app settings. You may also request a copy of your data or ask us to delete your account entirely.',
                ),
                _PolicySection(
                  title: '9. Changes to This Policy',
                  body:
                      'We may update this policy from time to time. We will notify you of significant changes through the app or via email. Continued use of the app after changes means you accept the updated policy.',
                ),
                _PolicySection(
                  title: '10. Contact Us',
                  body:
                      'If you have any questions about this Privacy Policy, please reach out to us at support@quizapp.com.',
                  isLast: true,
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _PolicyCard extends StatelessWidget {
  final List<Widget> children;
  const _PolicyCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
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

class _PolicySection extends StatelessWidget {
  final String title;
  final String body;
  final bool isLast;

  const _PolicySection({
    required this.title,
    required this.body,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: isLast ? 16 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey.shade700,
            ),
          ),
          if (!isLast) ...[
            const SizedBox(height: 16),
            Divider(height: 1, color: Colors.grey.shade200),
          ],
        ],
      ),
    );
  }
}