import 'package:flutter/material.dart';
import 'package:electus_app/core/theme/colors.dart';

class FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  FilterHeaderDelegate({
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor, 
      padding: EdgeInsets.only(top: 16, bottom: 16),
      alignment: Alignment.center,
      child: SizedBox(
        height: 36,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 24),
          children: [
            FilterChipWidget(
              label: 'All Roles',
              isSelected: selectedFilter == 'All Roles',
              onTap: () => onFilterChanged('All Roles'),
            ),
            SizedBox(width: 8),
            FilterChipWidget(
              label: 'Frontend Dev',
              isSelected: selectedFilter == 'Frontend Dev',
              onTap: () => onFilterChanged('Frontend Dev'),
            ),
            SizedBox(width: 8),
            FilterChipWidget(
              label: 'UI/UX Designer',
              isSelected: selectedFilter == 'UI/UX Designer',
              onTap: () => onFilterChanged('UI/UX Designer'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 68.0;

  @override
  double get minExtent => 68.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
