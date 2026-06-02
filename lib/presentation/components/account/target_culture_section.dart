import 'package:flutter/material.dart';
import 'riasec_slider.dart';

class TargetCultureSection extends StatelessWidget {
  final Map<String, double> riasecValues;
  final VoidCallback onReset;
  final void Function(String label, double value) onChanged;

  const TargetCultureSection({
    super.key,
    required this.riasecValues,
    required this.onReset,
    required this.onChanged,
  });

  static const Map<String, Color> _riasecColors = {
    'Realistic': Color(0xFF00685C),
    'Investigative': Color(0xFF006C49),
    'Artistic': Color(0xFF825100),
    'Social': Color(0xFF006B5F),
    'Enterprising': Color(0xFF7CD6C6),
    'Conventional': Color(0xFF6E7976),
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_graph,
                    color: Color(0xFF00685C),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "Target Culture",
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: onReset,
              icon: const Icon(
                Icons.restart_alt,
                color: Color(0xFF00685C),
                size: 18,
              ),
              label: const SizedBox(
                width: 80,
                child: Text(
                  "Reset",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF00685C), fontSize: 11),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          "Adjust these sliders to define the ideal candidate fit based on the RIASEC organizational model.",
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        ...riasecValues.keys.map((String key) {
          return RiasecSlider(
            label: key,
            value: riasecValues[key] ?? 0.0,
            sliderColor: _riasecColors[key] ?? const Color(0xFF2D7D6F),
            onChanged: (val) => onChanged(key, val),
          );
        }),
      ],
    );
  }
}
