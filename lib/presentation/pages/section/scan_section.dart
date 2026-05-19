import 'package:flutter/material.dart';
import 'package:electus_app/presentation/widget/style/colors.dart';

class ScanSection extends StatefulWidget {
  const ScanSection({super.key});

  @override
  State<ScanSection> createState() => _ScanSectionState();
}

class _ScanSectionState extends State<ScanSection>
    with SingleTickerProviderStateMixin {
  bool _isAnalyzing = false;
  late AnimationController _scannerController;
  late Animation<double> _scannerAnimation;

  @override
  void initState() {
    super.initState();
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scannerAnimation = Tween<double>(begin: 0.1, end: 0.8).animate(
      CurvedAnimation(parent: _scannerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _simulateScan() {
    setState(() => _isAnalyzing = true);
    // TODO: Trigger actual OCR/API analysis logic here
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final customColors = context.customColors;

    return Scaffold(
      backgroundColor: customColors.coreBlack,
      body: Stack(
        children: [
          // 1. Camera Feed Placeholder (Replace with CameraPreview)
          Positioned.fill(
            child: Container(
              color:
                  colorScheme.surfaceContainerLowest, // Dark backing for camera
              // Child: CameraPreview(controller),
            ),
          ),

          // 2. Dark Overlay with transparent center (Optional, if you want to dim the outside)
          // Omitted here to match the edge-to-edge look in the mocks,
          // but typically used in production scanners.

          // 3. Viewfinder Brackets
          Positioned(
            top: 60,
            left: 32,
            right: 32,
            bottom: 120, // Leave room for bottom UI
            child: CustomPaint(
              painter: _ViewfinderPainter(
                color: customColors.primaryFixedDim,
                strokeWidth: 3.0,
                cornerLength: 40.0,
              ),
            ),
          ),

          // 4. Animated Scanner Line
          AnimatedBuilder(
            animation: _scannerAnimation,
            builder: (context, child) {
              return Positioned(
                top:
                    MediaQuery.of(context).size.height *
                    _scannerAnimation.value,
                left: 32,
                right: 32,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colorScheme.secondaryContainer.withOpacity(0.0),
                        colorScheme.secondaryContainer.withOpacity(0.4),
                        colorScheme.secondaryContainer, // Solid line at bottom
                      ],
                      stops: const [0.0, 0.95, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),

          // 5. Bottom Action Area
          Positioned(
            left: 24,
            right: 24,
            bottom: 40,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isAnalyzing
                  ? const _AnalysisCard()
                  : _ScanButton(onPressed: _simulateScan),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Viewfinder Custom Painter ---

class _ViewfinderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double cornerLength;

  _ViewfinderPainter({
    required this.color,
    required this.strokeWidth,
    required this.cornerLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Top Left
    path.moveTo(0, cornerLength);
    path.lineTo(0, 0);
    path.lineTo(cornerLength, 0);

    // Top Right
    path.moveTo(size.width - cornerLength, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, cornerLength);

    // Bottom Right
    path.moveTo(size.width, size.height - cornerLength);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - cornerLength, size.height);

    // Bottom Left
    path.moveTo(cornerLength, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height - cornerLength);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ViewfinderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.cornerLength != cornerLength;
  }
}

// --- Bottom UI Components ---

class _ScanButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ScanButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final customColors = context.customColors;

    return Center(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 160,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: customColors.primaryFixedDim,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            'SCAN',
            style: TextStyle(
              color: customColors.onPrimaryFixed,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _AnalysisCard extends StatelessWidget {
  const _AnalysisCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.secondaryContainer.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.document_scanner_outlined,
                    color: colorScheme.secondaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'ANALYZING DOCUMENT...',
                    style: TextStyle(
                      color: colorScheme.secondaryContainer,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              Text(
                '78%',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(
              color: Colors.white12,
              height: 1,
            ), // Standard M3 subtle divider logic
          ),

          // Process Steps
          _ProcessStep(
            icon: Icons.check_circle_outline,
            text: 'Contact Information Extracted',
            isComplete: true,
          ),
          const SizedBox(height: 12),
          _ProcessStep(
            icon: Icons.check_circle_outline,
            text: 'Work History Parsed',
            isComplete: true,
          ),
          const SizedBox(height: 12),
          _ProcessStep(
            icon: Icons.sync,
            text: 'Extracting Skills...',
            isComplete: false,
            isActive: true,
          ),

          const SizedBox(height: 20),

          // Extracted Skill Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _SkillChip(label: 'PYTHON'),
              _SkillChip(label: 'REACT'),
              _SkillChip(label: 'AWS'),
              _SkillChip(label: 'AGILE'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProcessStep extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isComplete;
  final bool isActive;

  const _ProcessStep({
    required this.icon,
    required this.text,
    this.isComplete = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    Color contentColor;
    if (isActive) {
      contentColor = colorScheme.secondaryContainer; // Lime green
    } else if (isComplete) {
      contentColor = colorScheme.onSurfaceVariant; // Light Grey/Blue
    } else {
      contentColor = colorScheme.surfaceVariant; // Dim Grey
    }

    return Row(
      children: [
        Icon(icon, size: 20, color: contentColor),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: isActive ? contentColor : colorScheme.onSurface,
            fontSize: 14,
            fontWeight: isActive || isComplete
                ? FontWeight.w500
                : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;

  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final customColors = context.customColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: customColors.primaryFixedDim.withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
