import 'package:flutter/material.dart';
import 'package:quiz_app/utils/color.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;

  String? _imageUrl; // replace with File/XFile if using image_picker
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // TODO: Prefill with actual current user data
    _nameController = TextEditingController(text: 'Jane Doe');
    _emailController = TextEditingController(text: 'jane.doe@example.com');
    _phoneController = TextEditingController(text: '+1 234 567 8900');
    _bioController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _pickImage() {
    // TODO: Integrate image_picker package here
    // final picker = ImagePicker();
    // final picked = await picker.pickImage(source: ImageSource.gallery);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    // TODO: Replace with actual save/update API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isSaving = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              Center(child: _AvatarPicker(imageUrl: _imageUrl, onTap: _pickImage)),
              const SizedBox(height: 28),
              _FieldLabel('Full Name'),
              _RoundedField(
                controller: _nameController,
                hint: 'Enter your full name',
                icon: Icons.person_outline,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 18),
              _FieldLabel('Email'),
              _RoundedField(
                controller: _emailController,
                hint: 'Enter your email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                  if (!regex.hasMatch(v.trim())) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 18),
              _FieldLabel('Phone Number'),
              _RoundedField(
                controller: _phoneController,
                hint: 'Enter your phone number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 18),
              _FieldLabel('Bio'),
              _RoundedField(
                controller: _bioController,
                hint: 'Tell us a bit about yourself',
                icon: Icons.info_outline,
                maxLines: 4,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.secondaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarPicker extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onTap;

  const _AvatarPicker({required this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 55,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
          child: imageUrl == null
              ? const Icon(Icons.person, size: 55, color: Colors.white)
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }
}

class _RoundedField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  const _RoundedField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: maxLines > 1 ? (maxLines - 1) * 20.0 : 0),
          child: Icon(icon, color: Colors.grey.shade500, size: 20),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
        ),
      ),
    );
  }
}
