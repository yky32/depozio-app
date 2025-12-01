import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depozio/features/deposit/data/models/category_entity.dart';
import 'package:depozio/features/deposit/presentation/widgets/delete_category_dialogs.dart';
import 'package:depozio/features/deposit/presentation/bloc/deposit_bloc.dart';

/// A swipeable card widget for category items with delete functionality
class SwipeableCategoryCard extends StatefulWidget {
  const SwipeableCategoryCard({
    super.key,
    required this.category,
    required this.theme,
    required this.colorScheme,
    required this.l10n,
  });

  final CategoryModel category;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final dynamic l10n; // AppLocalizations

  @override
  State<SwipeableCategoryCard> createState() => _SwipeableCategoryCardState();
}

class _SwipeableCategoryCardState extends State<SwipeableCategoryCard>
    with SingleTickerProviderStateMixin {
  double _dragOffset = 0.0;
  static const double _deleteButtonWidth = 80.0;
  static const double _maxDragOffset = _deleteButtonWidth;

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.primaryDelta!;
      // Clamp the drag offset to prevent over-dragging
      if (_dragOffset > 0) {
        _dragOffset = 0;
      } else if (_dragOffset < -_maxDragOffset) {
        _dragOffset = -_maxDragOffset;
      }
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final threshold = _maxDragOffset / 2;
    if (_dragOffset < -threshold) {
      // Snap to fully open
      setState(() {
        _dragOffset = -_maxDragOffset;
      });
    } else {
      // Snap back to closed
      setState(() {
        _dragOffset = 0;
      });
    }
  }

  void _resetPosition() {
    setState(() {
      _dragOffset = 0;
    });
  }

  Future<void> _handleDelete() async {
    final deletedCategory = widget.category;
    final confirmed = await showDeleteCategoryDialog(context, widget.category);
    
    if (confirmed && mounted) {
      // Delete via BLoC
      context.read<DepositBloc>().add(DeleteCategory(categoryId: widget.category.id));
      
      // Show undo SnackBar
      showUndoSnackBar(
        context,
        deletedCategory,
        onCategoryRestored: () {
          // Restore via BLoC
          context.read<DepositBloc>().add(RestoreCategory(category: deletedCategory));
        },
      );
      
      _resetPosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Delete button background
          Positioned.fill(
            child: GestureDetector(
              onTap: _handleDelete,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
          // Card content - provides size for Stack
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(_dragOffset, 0, 0),
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.category.icon,
                    color: widget.colorScheme.primary,
                    size: 24,
                  ),
                ),
                title: Text(
                  widget.category.name,
                  style: widget.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  widget.category.type == 'deposits'
                      ? widget.l10n.add_category_type_deposits
                      : widget.l10n.add_category_type_expenses,
                  style: widget.theme.textTheme.bodySmall?.copyWith(
                    color: widget.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        widget.category.type == 'deposits'
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.category.type == 'deposits' ? 'Deposit' : 'Expense',
                    style: widget.theme.textTheme.bodySmall?.copyWith(
                      color:
                          widget.category.type == 'deposits'
                              ? Colors.green
                              : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onTap: () {
                  if (_dragOffset < 0) {
                    _resetPosition();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
