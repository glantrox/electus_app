import 'package:electus_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ScanCvScreen extends StatefulWidget {
  const ScanCvScreen({super.key});

  @override
  State<ScanCvScreen> createState() => _ScanCvScreenState();
}

class _ScanCvScreenState extends State<ScanCvScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  String? _cameraError;
  FlashMode _flashMode = FlashMode.auto;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        // Use the first rear camera
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );

        await _cameraController!.initialize();
        await _cameraController!.setFlashMode(_flashMode);

        if (mounted) {
          setState(() => _isCameraInitialized = true);
        }
      } else {
        if (mounted) {
          setState(() {
            _cameraError = 'No camera found on this device.';
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Camera Initialization Error: $e');
      if (mounted) {
        setState(() {
          _cameraError = 'Failed to initialize camera: $e';
          _isCameraInitialized = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (!_cameraController!.value.isInitialized ||
        _cameraController!.value.isTakingPicture) {
      return;
    }
    try {
      await _cameraController!.takePicture();
      // Route to crop/preview screen and pass the XFile path
      // context.push('/scan_preview', extra: picture.path);
    } catch (e) {
      debugPrint('Capture Error: $e');
    }
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null) return;

    FlashMode nextMode;
    switch (_flashMode) {
      case FlashMode.auto:
        nextMode = FlashMode.always;
        break;
      case FlashMode.always:
        nextMode = FlashMode.off;
        break;
      case FlashMode.off:
        nextMode = FlashMode.auto;
        break;
      case FlashMode.torch:
        nextMode = FlashMode.auto;
        break;
    }

    await _cameraController!.setFlashMode(nextMode);
    setState(() => _flashMode = nextMode);
  }

  Future<void> _pickFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Route to crop/preview screen and pass the XFile path
      // context.push('/scan_preview', extra: image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraError != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.redAccent,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  _cameraError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _pickFromGallery,
                  child: const Text('Pick from Gallery Instead'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (!_isCameraInitialized || _cameraController == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: AppColor.primary)),
      );
    }

    // Wrap in pop scope to ensure hardware back button behaves properly with full-screen views
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Live Camera Preview
            CameraPreview(_cameraController!),

            // 2. Bottom Gradient Overlay for icon visibility
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 200,
              child: _BottomGradient(),
            ),

            // 3. Top Left Close Button
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              child: _GlassButton(
                icon: Icons.close,
                onTap: () => context.pop(),
              ),
            ),

            // 4. Bottom Controls Row
            Positioned(
              bottom: 48,
              left: 32,
              right: 32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _GlassButton(icon: _getFlashIcon(), onTap: _toggleFlash),
                  _CaptureButton(onTap: _takePicture),
                  _GlassButton(
                    icon: Icons.photo_library_outlined,
                    onTap: _pickFromGallery,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFlashIcon() {
    switch (_flashMode) {
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.flash_on;
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.torch:
        return Icons.highlight;
    }
  }
}

// --- Separated UI Widgets ---

class _BottomGradient extends StatelessWidget {
  const _BottomGradient();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withValues(alpha: 0.85),
            Colors.black.withValues(alpha: 0.4),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

class _CaptureButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CaptureButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColor.primary, width: 3),
        ),
        child: Center(
          child: Container(
            height: 66,
            width: 66,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
