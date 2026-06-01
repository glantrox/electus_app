import 'package:flutter/material.dart';

class RiasecSlider extends StatelessWidget {
  final String label;
  final double value;
  final Color sliderColor;
  final ValueChanged<double> onChanged;

  const RiasecSlider({
    super.key,
    required this.label,
    required this.value,
    required this.sliderColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Text(
              "${(value * 100).toInt()}%",
              style: TextStyle(color: sliderColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
          ),
          child: Slider(
            value: value,
            activeColor: sliderColor,
            inactiveColor: colorScheme.surfaceContainerHighest,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
