import 'package:flutter/material.dart';
import 'package:depozio/widgets/buttons/back_button.dart' as custom;
import 'package:depozio/router/app_page.dart';
import 'package:go_router/go_router.dart';

/// Temporary test page to verify Satoshi font is applied
/// You can navigate to this page to see all font weights
class FontTestPage extends StatelessWidget {
  const FontTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: custom.BackButton(
          onPressed: () => context.go(AppPage.setting.path),
        ),
        title: const Text('Font Test - Satoshi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Satoshi Font Verification',
              style: theme.textTheme.displayMedium,
            ),
            const SizedBox(height: 32),
            _buildFontWeightTest('Light (300)', FontWeight.w300),
            _buildFontWeightTest('Regular (400)', FontWeight.w400),
            _buildFontWeightTest('Medium (500)', FontWeight.w500),
            _buildFontWeightTest('Bold (700)', FontWeight.w700),
            _buildFontWeightTest('Black (900)', FontWeight.w900),
            const SizedBox(height: 32),
            Text(
              'Theme Text Styles',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text('Display Large', style: theme.textTheme.displayLarge),
            Text('Display Medium', style: theme.textTheme.displayMedium),
            Text('Title Large', style: theme.textTheme.titleLarge),
            Text('Title Medium', style: theme.textTheme.titleMedium),
            Text('Title Small', style: theme.textTheme.titleSmall),
            Text('Body Large', style: theme.textTheme.bodyLarge),
            Text('Body Medium', style: theme.textTheme.bodyMedium),
            Text('Body Small', style: theme.textTheme.bodySmall),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'If you see different font styles above, Satoshi font is working!',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.green.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontWeightTest(String label, FontWeight weight) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontFamily: 'Satoshi',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'The quick brown fox jumps over the lazy dog',
            style: TextStyle(
              fontSize: 18,
              fontWeight: weight,
              fontFamily: 'Satoshi',
            ),
          ),
        ],
      ),
    );
  }
}
