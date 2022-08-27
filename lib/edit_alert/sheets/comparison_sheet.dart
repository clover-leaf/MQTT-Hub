import 'package:bee/components/component.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class ComparisonSheet extends StatelessWidget {
  const ComparisonSheet({
    super.key,
    required this.onComparisonSelected,
  });

  final void Function(Comparison) onComparisonSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      decoration: const BoxDecoration(
        color: ColorName.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
            child: Text(
              'COMPARISON',
              style: textTheme.titleSmall,
            ),
          ),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              ...Comparison.values.map(
                (comparison) => TComparisonItem(
                  comparison: comparison,
                  onPressed: () => onComparisonSelected(comparison),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
