import 'dart:io';
import 'package:flutter/material.dart';
import 'image_picker_helper.dart';
import 'package:image_picker/image_picker.dart';

/// Example widget showing how to use ImagePickerHelper with runtime permissions
class ImagePickerWidget extends StatefulWidget {
  final Function(File?) onImageSelected;
  final String? initialImageUrl;

  const ImagePickerWidget({
    super.key,
    required this.onImageSelected,
    this.initialImageUrl,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _selectedImage;

  /// Show bottom sheet to select image source
  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Image Source',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Colors.blue),
                  title: const Text('Camera'),
                  subtitle: const Text('Take a new photo'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: Colors.green),
                  title: const Text('Gallery'),
                  subtitle: const Text('Choose from gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImage(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Pick image with runtime permission request
  Future<void> _pickImage(ImageSource source) async {
    File? image;

    // Show loading indicator
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    try {
      if (source == ImageSource.camera) {
        // This will automatically request camera permission at runtime
        image = await ImagePickerHelper.pickImageFromCamera();
      } else {
        // This will automatically request storage/photos permission at runtime
        image = await ImagePickerHelper.pickImageFromGallery();
      }

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
      }

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
        widget.onImageSelected(image);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No image selected'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showImageSourceBottomSheet,
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[400]!, width: 2),
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                ),
              )
            : widget.initialImageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.initialImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholder();
                      },
                    ),
                  )
                : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey[600]),
        const SizedBox(height: 8),
        Text(
          'Add Image',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }
}

/// Simple usage example
class ExampleUsageScreen extends StatefulWidget {
  const ExampleUsageScreen({super.key});

  @override
  State<ExampleUsageScreen> createState() => _ExampleUsageScreenState();
}

class _ExampleUsageScreenState extends State<ExampleUsageScreen> {
  File? _profileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Picker Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImagePickerWidget(
              onImageSelected: (image) {
                setState(() {
                  _profileImage = image;
                });
                print('Image selected: ${image?.path}');
              },
            ),
            const SizedBox(height: 20),
            if (_profileImage != null)
              Text('Image Path: ${_profileImage!.path}'),
            const SizedBox(height: 20),
            
            // Direct usage without widget
            ElevatedButton.icon(
              onPressed: () async {
                // This will request permission at runtime automatically
                final image = await ImagePickerHelper.pickImageFromCamera();
                if (image != null) {
                  setState(() {
                    _profileImage = image;
                  });
                }
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Photo (Direct)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () async {
                // This will request permission at runtime automatically
                final image = await ImagePickerHelper.pickImageFromGallery();
                if (image != null) {
                  setState(() {
                    _profileImage = image;
                  });
                }
              },
              icon: const Icon(Icons.photo_library),
              label: const Text('Choose from Gallery (Direct)'),
            ),
          ],
        ),
      ),
    );
  }
}

