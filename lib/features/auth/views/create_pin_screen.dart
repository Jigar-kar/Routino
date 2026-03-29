import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/custom_keypad.dart';
import '../providers/auth_provider.dart';

class CreatePinScreen extends ConsumerStatefulWidget {
  const CreatePinScreen({super.key});

  @override
  ConsumerState<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends ConsumerState<CreatePinScreen> {
  String _firstPin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  bool _isError = false;

  void _onDigitPressed(String digit) {
    if (_isError) return;
    
    setState(() {
      if (!_isConfirming) {
        if (_firstPin.length < 4) _firstPin += digit;
        if (_firstPin.length == 4) {
          Future.delayed(const Duration(milliseconds: 300), () {
            setState(() {
              _isConfirming = true;
            });
          });
        }
      } else {
        if (_confirmPin.length < 4) _confirmPin += digit;
        if (_confirmPin.length == 4) {
          _verifyAndSave();
        }
      }
    });
  }

  void _onDeletePressed() {
    setState(() {
      if (!_isConfirming && _firstPin.isNotEmpty) {
        _firstPin = _firstPin.substring(0, _firstPin.length - 1);
      } else if (_isConfirming && _confirmPin.isNotEmpty) {
        _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
      }
    });
  }

  void _verifyAndSave() {
    if (_firstPin == _confirmPin) {
      // Success, saving to secure storage
      ref.read(authProvider.notifier).setupPin(_firstPin);
    } else {
      // Error
      setState(() {
        _isError = true;
      });
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() {
            _confirmPin = '';
            _isError = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 1),
            Text(
              _isConfirming ? 'Confirm your PIN' : 'Create a 4-Digit PIN',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _isConfirming ? 'Re-enter to verify' : 'Used to lock your vault.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 48),
            PinDotRow(
              pinLength: _isConfirming ? _confirmPin.length : _firstPin.length,
              isError: _isError,
            ),
            const SizedBox(height: 32),
            if (_isError)
              const Text('PINs do not match. Try again.', style: TextStyle(color: AppTheme.error)),
            const Spacer(flex: 2),
            AuthKeypad(
              onDigitPressed: _onDigitPressed,
              onDeletePressed: _onDeletePressed,
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
