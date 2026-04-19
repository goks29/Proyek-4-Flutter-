import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'vision_controller.dart';

class VisionView extends StatefulWidget {
  const VisionView({super.key});

  @override
  State<VisionView> createState() => _VisionViewState();
}

class _VisionViewState extends State<VisionView> {
  late VisionController _visionController;

  @override
  void initState() {
    super.initState();
    _visionController = VisionController();
    _visionController.startMockDetection();
  }

  @override
  void dispose() {
    _visionController.dispose();
    super.dispose();
  }

  Widget _buildMenuButton(IconData icon, String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(icon, color: Colors.white, size: 30),
            onPressed: onPressed,
          ),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _visionController,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("PCD Image Editor"),
            actions: [
              IconButton(
                icon: Icon(
                  _visionController.isFlashlightOn
                      ? Icons.flash_on
                      : Icons.flash_off,
                ),
                onPressed: _visionController.toggleFlashlight,
                tooltip: 'Toggle Flashlight',
              ),
              if (_visionController.processedImage != null)
                IconButton(
                  icon: const Icon(Icons.undo),
                  onPressed: _visionController.resetImage,
                  tooltip: 'Reset Gambar',
                ),
            ],
          ),
          body: Column (
            children: [
              Expanded(
                child: Center(
                  child: _visionController.processedImage != null
                      ? Image.memory(
                        _visionController.processedImage!,
                        fit: BoxFit.contain,
                      )
                    : (!_visionController.isInitialized
                        ? const CircularProgressIndicator()
                        : CameraPreview(_visionController.controller!)),
                ),
              ),

              if(_visionController.processedImage != null) 
                Container(
                  height: 100,
                  color: Colors.grey[900],
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    children: [
                      _buildMenuButton(Icons.invert_colors, "Inverse", _visionController.applyInverse),
                      _buildMenuButton(Icons.gradient, "Grayscale", _visionController.applyGrayscale),
                      _buildMenuButton(Icons.equalizer, "Equalize", _visionController.applyEqualizeHistogram),
                      _buildMenuButton(Icons.details, "Sharpen", _visionController.applySharpen),
                      _buildMenuButton(Icons.blur_on, "Blur", _visionController.applyGaussianBlur),
                      _buildMenuButton(Icons.line_style, "Edge", _visionController.applyEdgeDetection),
                    ],
                  ),
                ),
            ],
          ),
          floatingActionButton: _visionController.processedImage == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Tombol BARU: Upload dari Galeri
                FloatingActionButton(
                  heroTag: "btn_gallery",
                  backgroundColor: Colors.blue, // Kasih warna beda biar enak
                  onPressed: () => _visionController.pickImageFromGallery(),
                  tooltip: 'Upload Gambar',
                  child: const Icon(Icons.photo_library),
                ),
                const SizedBox(height: 16),
                
                // Tombol Kamera yang udah ada (tetep simpen di sini)
                FloatingActionButton(
                  heroTag: "btn_kamera",
                  onPressed: () => _visionController.setImageFromCamera(),
                  tooltip: 'Capture Photo',
                  child: const Icon(Icons.camera_alt),
                ),
              ],
            )
          : null,
        );
      }
    );
  }
}
