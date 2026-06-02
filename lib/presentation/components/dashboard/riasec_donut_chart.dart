import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:electus_app/domain/entities/candidate_entity.dart';

class RiasecDonutChart extends StatelessWidget {
  final List<HollandCodeDistributionEntity> distribution;

  const RiasecDonutChart({super.key, required this.distribution});

  @override
  Widget build(BuildContext context) {
    if (distribution.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 200,
          width: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(200, 200),
                painter: _RiasecDonutChartPainter(distribution),
              ),
              const Text(
                'RIASEC',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827), // Dark text color
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        // Legend
        Wrap(
          spacing: 16,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: distribution.map((d) {
            Color color = Colors.grey;
            if (d.color.isNotEmpty && d.color.startsWith('#')) {
              try {
                color = Color(
                  int.parse(d.color.substring(1), radix: 16) + 0xFF000000,
                );
              } catch (_) {}
            }

            if (color == Colors.grey) {
              switch (d.code) {
                case 'R':
                  color = const Color(0xFFEF4444);
                  break;
                case 'I':
                  color = const Color(0xFF3B82F6);
                  break;
                case 'A':
                  color = const Color(0xFF8B5CF6);
                  break;
                case 'S':
                  color = const Color(0xFF10B981);
                  break;
                case 'E':
                  color = const Color(0xFFF59E0B);
                  break;
                case 'C':
                  color = const Color(0xFF14B8A6);
                  break;
              }
            }
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(radius: 6, backgroundColor: color),
                const SizedBox(width: 8),
                Text(
                  '${d.code} – ${d.label}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _RiasecDonutChartPainter extends CustomPainter {
  final List<HollandCodeDistributionEntity> distribution;

  _RiasecDonutChartPainter(this.distribution);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = size.width / 2;
    const strokeWidth = 24.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    double startAngle = -math.pi / 2; // Start at top

    double total = 0;
    for (var d in distribution) {
      total += d.value;
    }

    if (total == 0) return;

    for (var d in distribution) {
      final sweepAngle = (d.value / total) * 2 * math.pi;

      Color color = Colors.grey;
      if (d.color.isNotEmpty && d.color.startsWith('#')) {
        try {
          color = Color(
            int.parse(d.color.substring(1), radix: 16) + 0xFF000000,
          );
        } catch (_) {}
      }

      if (color == Colors.grey) {
        switch (d.code) {
          case 'R':
            color = const Color(0xFFEF4444);
            break;
          case 'I':
            color = const Color(0xFF3B82F6);
            break;
          case 'A':
            color = const Color(0xFF8B5CF6);
            break;
          case 'S':
            color = const Color(0xFF10B981);
            break;
          case 'E':
            color = const Color(0xFFF59E0B);
            break;
          case 'C':
            color = const Color(0xFF14B8A6);
            break;
        }
      }
      paint.color = color;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
