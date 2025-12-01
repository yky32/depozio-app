import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depozio/core/extensions/localizations.dart';
import 'package:depozio/core/localization/app_localizations.dart';
import 'package:depozio/features/deposit/data/models/category_entity.dart';
import 'package:depozio/features/deposit/data/models/category_icon_helper.dart';
import 'package:depozio/features/deposit/presentation/bloc/deposit_bloc.dart';
import 'package:depozio/core/network/logger.dart';

/// Bottom sheet for adding category that covers the navigation bar
/// This widget is specific to the deposit page
class AddCategoryBottomSheet extends StatelessWidget {
  const AddCategoryBottomSheet({
    super.key,
    this.maxHeightPercentage = 0.9,
  });

  /// Maximum height as a percentage of screen height (0.0 to 1.0)
  /// Default is 0.9 (90%)
  final double maxHeightPercentage;

  // Use the icon helper for consistency
  static List<IconData> get _availableIcons =>
      CategoryIconHelper.availableIcons;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final keyboardHeight = mediaQuery.viewInsets.bottom;

    final availableHeight = screenHeight - keyboardHeight;
    final maxHeight = (screenHeight * maxHeightPercentage).clamp(
      0.0,
      availableHeight,
    );

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              alignment: Alignment.center,
              child: Container(
                width: 80,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Text(
              l10n.add_category_bottom_sheet_title,
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            child: _CategoryFormContent(
              theme: theme,
              colorScheme: colorScheme,
              l10n: l10n,
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal widget that maintains form state
class _CategoryFormContent extends StatefulWidget {
  const _CategoryFormContent({
    required this.theme,
    required this.colorScheme,
    required this.l10n,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final AppLocalizations l10n;

  @override
  State<_CategoryFormContent> createState() => _CategoryFormContentState();
}

class _CategoryFormContentState extends State<_CategoryFormContent> {
  late final TextEditingController _nameController;
  late final FocusNode _nameFocusNode;
  late final ValueNotifier<IconData?> _selectedIconNotifier;
  late final ValueNotifier<String?> _selectedTypeNotifier;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nameFocusNode = FocusNode();
    _selectedIconNotifier = ValueNotifier<IconData?>(null);
    _selectedTypeNotifier = ValueNotifier<String?>(null);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    _selectedIconNotifier.dispose();
    _selectedTypeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
      padding: EdgeInsets.fromLTRB(24, 0, 24, keyboardHeight > 0 ? 16 : 24),
      child: ValueListenableBuilder<IconData?>(
        valueListenable: _selectedIconNotifier,
        builder: (context, selectedIcon, _) {
          return ValueListenableBuilder<String?>(
            valueListenable: _selectedTypeNotifier,
            builder: (context, selectedType, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nameController,
                    focusNode: _nameFocusNode,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onTapOutside: (event) => _nameFocusNode.unfocus(),
                    style: widget.theme.textTheme.bodyLarge,
                    decoration: InputDecoration(
                      labelText: widget.l10n.add_category_name,
                      hintText: widget.l10n.add_category_name_hint,
                      filled: true,
                      fillColor: widget.colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: widget.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    widget.l10n.add_category_icon,
                    style: widget.theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final itemSize = (constraints.maxWidth - (4 * 12)) / 5;
                      final totalHeight = (itemSize * 3) + (2 * 12) + 32;

                      return Container(
                        width: double.infinity,
                        height: totalHeight,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: widget.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1,
                                mainAxisExtent: itemSize,
                              ),
                          itemCount:
                              AddCategoryBottomSheet._availableIcons.length,
                          itemBuilder: (context, index) {
                            final icon =
                                AddCategoryBottomSheet._availableIcons[index];
                            final isSelected = selectedIcon == icon;
                            return GestureDetector(
                              onTap: () {
                                _nameFocusNode.unfocus();
                                _selectedIconNotifier.value = icon;
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? widget.colorScheme.primary
                                              .withValues(alpha: 0.1)
                                          : widget
                                              .colorScheme
                                              .surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      isSelected
                                          ? Border.all(
                                            color: widget.colorScheme.primary,
                                            width: 2,
                                          )
                                          : null,
                                ),
                                child: Icon(
                                  icon,
                                  color:
                                      isSelected
                                          ? widget.colorScheme.primary
                                          : widget.colorScheme.onSurface
                                              .withValues(alpha: 0.7),
                                  size: 24,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  if (selectedIcon == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Please select an icon',
                        style: widget.theme.textTheme.bodySmall?.copyWith(
                          color: Colors.red.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),
                  Text(
                    widget.l10n.add_category_type,
                    style: widget.theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTypeButton(
                          type: 'deposits',
                          selectedType: selectedType,
                          icon: Icons.account_balance_wallet,
                          label: widget.l10n.add_category_type_deposits,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTypeButton(
                          type: 'expenses',
                          selectedType: selectedType,
                          icon: Icons.receipt_long,
                          label: widget.l10n.add_category_type_expenses,
                        ),
                      ),
                    ],
                  ),
                  if (selectedType == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Please select a type',
                        style: widget.theme.textTheme.bodySmall?.copyWith(
                          color: Colors.red.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(widget.l10n.action_cancel),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_nameController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a category name'),
                                ),
                              );
                              _nameFocusNode.requestFocus();
                              return;
                            }

                            if (selectedIcon == null || selectedType == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please select an icon and type',
                                  ),
                                ),
                              );
                              return;
                            }

                            final category = CategoryModel(
                              id:
                                  DateTime.now().millisecondsSinceEpoch
                                      .toString(),
                              name: _nameController.text.trim(),
                              iconIndex: CategoryIconHelper.getIconIndex(
                                selectedIcon,
                              ),
                              type: selectedType,
                              createdAt: DateTime.now(),
                            );

                            LoggerUtil.d('➕ Creating category: ${category.name} (type: ${category.type}, id: ${category.id})');
                            
                            // Add category via BLoC
                            try {
                              final bloc = context.read<DepositBloc>();
                              LoggerUtil.d('✅ BLoC obtained, dispatching AddCategory event');
                              bloc.add(AddCategory(category: category));
                              LoggerUtil.i('📤 AddCategory event dispatched');
                              
                              if (context.mounted) {
                                LoggerUtil.d('🚪 Closing bottom sheet');
                                Navigator.of(context).pop();
                              }
                            } catch (e, stackTrace) {
                              LoggerUtil.e('❌ Error adding category', error: e, stackTrace: stackTrace);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(widget.l10n.action_confirm),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTypeButton({
    required String type,
    required String? selectedType,
    required IconData icon,
    required String label,
  }) {
    final isSelected = selectedType == type;
    return GestureDetector(
      onTap: () {
        _nameFocusNode.unfocus();
        _selectedTypeNotifier.value = type;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? widget.colorScheme.primary.withValues(alpha: 0.1)
                  : widget.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color:
                  isSelected
                      ? widget.colorScheme.primary
                      : widget.colorScheme.onSurface.withValues(alpha: 0.7),
              size: 24,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                label,
                style: widget.theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color:
                      isSelected
                          ? widget.colorScheme.primary
                          : widget.colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
