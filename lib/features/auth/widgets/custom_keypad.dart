import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';

class PinDotRow extends StatelessWidget {
  final int pinLength;
  final bool isError;

  const PinDotRow({super.key, required this.pinLength, this.isError = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isFilled = index < pinLength;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isError
                ? AppTheme.error
                : (isFilled ? AppTheme.primaryLight : AppTheme.surfaceVariant),
            border: Border.all(
              color: isError
                  ? AppTheme.error
                  : (isFilled
                      ? AppTheme.primaryLight
                      : AppTheme.textSecondary.withValues(alpha: 0.3)),
            ),
            boxShadow: isFilled && !isError
                ? [
                    BoxShadow(
                      color: AppTheme.primaryLight.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    )
                  ]
                : null,
          ),
        );
      }),
    );
  }
}

class AuthKeypad extends StatelessWidget {
  final Function(String) onDigitPressed;
  final VoidCallback onDeletePressed;

  /// When provided, the bottom-left key shows a fingerprint icon and calls this.
  /// When null, the bottom-left key is invisible (e.g. during PIN setup).
  final VoidCallback? onBiometricPressed;

  const AuthKeypad({
    super.key,
    required this.onDigitPressed,
    required this.onDeletePressed,
    this.onBiometricPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow(['1', '2', '3'], context),
        _buildRow(['4', '5', '6'], context),
        _buildRow(['7', '8', '9'], context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Bottom-left: fingerprint button (real) or empty spacer
            onBiometricPressed != null
                ? _buildActionKey(
                    icon: LucideIcons.fingerprint,
                    onTap: onBiometricPressed!,
                    context: context,
                    color: AppTheme.primaryLight,
                  )
                : const SizedBox(width: 80, height: 80),
            _buildDigitKey('0', context),
            _buildActionKey(
              icon: LucideIcons.delete,
              onTap: onDeletePressed,
              context: context,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(List<String> digits, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map((d) => _buildDigitKey(d, context)).toList(),
    );
  }

  Widget _buildDigitKey(String digit, BuildContext context) {
    return InkWell(
      onTap: () => onDigitPressed(digit),
      borderRadius: BorderRadius.circular(40),
      splashColor: AppTheme.primaryLight.withValues(alpha: 0.1),
      child: Container(
        width: 80,
        height: 80,
        alignment: Alignment.center,
        child: Text(
          digit,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 32),
        ),
      ),
    );
  }

  Widget _buildActionKey({
    required IconData icon,
    required VoidCallback onTap,
    required BuildContext context,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      splashColor: (color ?? AppTheme.error).withValues(alpha: 0.12),
      child: Container(
        width: 80,
        height: 80,
        alignment: Alignment.center,
        child: Icon(icon, size: 28, color: color ?? AppTheme.textPrimary),
      ),
    );
  }
}
