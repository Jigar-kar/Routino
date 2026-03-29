import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/widgets/primary_button.dart';
import '../../user/providers/user_provider.dart';
import '../../user/models/user_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/services/backup_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _updateUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final name = _nameController.text.trim();
    final email = _emailController.text.trim().isEmpty
        ? null
        : _emailController.text.trim();
    final phone = _phoneController.text.trim().isEmpty
        ? null
        : _phoneController.text.trim();

    final userModel = UserModel(
      id: 'local_user',
      name: name,
      email: email,
      phone: phone,
      createdAt: DateTime.now(),
    );

    try {
      final currentUser = ref.read(userProvider);
      if (currentUser == null) {
        await ref.read(userProvider.notifier).saveUser(userModel);
      } else {
        final updatedUser = currentUser.copyWith(
          name: name,
          email: email,
          phone: phone,
        );
        await ref.read(userProvider.notifier).updateUser(updatedUser);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.of(
          context,
        ).pop(); // Go back to dashboard to see the updated name
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildColorPicker(
    String label,
    Color currentColor,
    Function(Color) onColorChanged,
  ) {
    return ListTile(
      title: Text(label),
      trailing: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: currentColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey),
        ),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Pick $label'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: currentColor,
                onColorChanged: onColorChanged,
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Done'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userStreamProvider);
    final currentTheme = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: userAsync.when(
        data: (user) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile Settings',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      text: 'Update Profile',
                      onPressed: _updateUser,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'App Settings',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              const Text('Theme'),
              ...ThemeType.values.map(
                (theme) => RadioListTile<ThemeType>(
                  title: Text(theme.name.toUpperCase()),
                  value: theme,
                  groupValue: currentTheme,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(themeProvider.notifier).setTheme(value);
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text('Security'),
              const SizedBox(height: 8),
              FutureBuilder<bool>(
                future: ref.read(authProvider.notifier).canUseBiometric(),
                builder: (context, snapshot) {
                  final available = snapshot.data ?? false;
                  return ListTile(
                    leading: Icon(
                      Icons.fingerprint,
                      color: available ? Colors.green : Colors.grey,
                    ),
                    title: const Text('Biometric Unlock'),
                    subtitle: Text(
                      available
                          ? 'Enabled — fingerprint or face ID is active for all users'
                          : 'Not available on this device',
                    ),
                    trailing: Icon(
                      available ? Icons.check_circle : Icons.cancel,
                      color: available ? Colors.green : Colors.grey,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Text('Backup & Restore'),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.cloud_upload_outlined, color: Colors.blue),
                title: const Text('Export Backup (JSON)'),
                subtitle: const Text('Save your tasks and data to Drive, Files, or email.'),
                onTap: () async {
                  setState(() => _isLoading = true);
                  final success = await BackupService().exportBackupToDriveOrLocal();
                  if (mounted) {
                    setState(() => _isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(success ? 'Export successful or shared.' : 'Export cancelled or failed.')),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.cloud_download_outlined, color: Colors.blueGrey),
                title: const Text('Import Backup'),
                subtitle: const Text('Restore your data from a JSON file.'),
                onTap: () async {
                  setState(() => _isLoading = true);
                  final success = await BackupService().importBackupFromJSON();
                  if (mounted) {
                    setState(() => _isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(success ? 'Backup restored successfully!' : 'Import cancelled or failed.')),
                    );
                  }
                },
              ),
              if (currentTheme == ThemeType.custom) ...[
                const SizedBox(height: 16),
                const Text('Customize Colors'),
                const SizedBox(height: 8),
                _buildColorPicker(
                  'Primary Color',
                  ref.read(themeProvider.notifier).primaryColor,
                  (color) {
                    ref
                        .read(themeProvider.notifier)
                        .setCustomColors(primary: color);
                  },
                ),
                _buildColorPicker(
                  'Secondary Color',
                  ref.read(themeProvider.notifier).secondaryColor,
                  (color) {
                    ref
                        .read(themeProvider.notifier)
                        .setCustomColors(secondary: color);
                  },
                ),
                _buildColorPicker(
                  'Background Color',
                  ref.read(themeProvider.notifier).backgroundColor,
                  (color) {
                    ref
                        .read(themeProvider.notifier)
                        .setCustomColors(background: color);
                  },
                ),
                _buildColorPicker(
                  'Surface Color',
                  ref.read(themeProvider.notifier).surfaceColor,
                  (color) {
                    ref
                        .read(themeProvider.notifier)
                        .setCustomColors(surface: color);
                  },
                ),
                _buildColorPicker(
                  'Text Color',
                  ref.read(themeProvider.notifier).textColor,
                  (color) {
                    ref
                        .read(themeProvider.notifier)
                        .setCustomColors(text: color);
                  },
                ),
              ],
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
