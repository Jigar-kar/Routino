import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/custom_keypad.dart';
import '../providers/auth_provider.dart';

class PinLockScreen extends ConsumerStatefulWidget {
  const PinLockScreen({super.key});

  @override
  ConsumerState<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends ConsumerState<PinLockScreen> {
  String _pin = '';
  bool _isError = false;
  bool _canUseBiometric = false;

  @override
  void initState() {
    super.initState();
    _initBiometric();
  }

  Future<void> _initBiometric() async {
    final can = await ref.read(authProvider.notifier).canUseBiometric();
    if (mounted) {
      setState(() => _canUseBiometric = can);
      // Auto-trigger biometric prompt as soon as screen opens
      if (can) {
        await Future.delayed(const Duration(milliseconds: 400));
        _triggerBiometric();
      }
    }
  }

  Future<void> _triggerBiometric() async {
    final success = await ref.read(authProvider.notifier).unlockWithBiometric();
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.fingerprint, color: Colors.white),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Biometric authentication failed. Use your PIN.'),
              ),
            ],
          ),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _onDigitPressed(String digit) async {
    if (_isError || _pin.length >= 4) return;

    setState(() {
      _pin += digit;
    });

    if (_pin.length == 4) {
      final success = await ref.read(authProvider.notifier).unlock(_pin);
      if (!success && mounted) {
        setState(() => _isError = true);
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            setState(() {
              _pin = '';
              _isError = false;
            });
          }
        });
      }
    }
  }

  void _onDeletePressed() {
    if (_isError) return;
    setState(() {
      if (_pin.isNotEmpty) {
        _pin = _pin.substring(0, _pin.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 1),
            // Lock icon with subtle glow
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryLight.withValues(alpha: 0.12),
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                size: 48,
                color: AppTheme.primaryLight,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome Back',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _canUseBiometric
                  ? 'Use biometrics or enter your PIN'
                  : 'Enter your 4-digit PIN to continue',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            PinDotRow(pinLength: _pin.length, isError: _isError),
            if (_isError)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Incorrect PIN. Try again.',
                  style: TextStyle(color: AppTheme.error, fontSize: 13),
                ),
              ),
            const Spacer(flex: 2),
            // Biometric quick-access button above keypad
            if (_canUseBiometric)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: _triggerBiometric,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.primaryLight.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          LucideIcons.fingerprint,
                          size: 32,
                          color: AppTheme.primaryLight,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Use Biometrics',
                        style: TextStyle(
                          color: AppTheme.primaryLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 8),
            AuthKeypad(
              onDigitPressed: _onDigitPressed,
              onDeletePressed: _onDeletePressed,
              // Wire keypad fingerprint key to biometric trigger
              onBiometricPressed: _canUseBiometric ? _triggerBiometric : null,
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
