import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depozio/features/deposit/presentation/bloc/deposit_bloc.dart';

class DepositErrorState extends StatelessWidget {
  const DepositErrorState({
    super.key,
    required this.theme,
    required this.colorScheme,
    required this.l10n,
    required this.error,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final dynamic l10n;
  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.deposit_page_error_loading,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<DepositBloc>().add(LoadDeposits());
            },
            child: Text(l10n.deposit_page_retry),
          ),
        ],
      ),
    );
  }
}
