import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CameraUI extends StatefulWidget {
  @override
  _CameraUIState createState() => _CameraUIState();
}

class _CameraUIState extends State<CameraUI> {
  File? _selectedImage;
  String _captionText = "";
  bool _isLoading = false;
  final FlutterTts _flutterTts = FlutterTts();

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _requestPermission() async {
    if (await Permission.camera.isDenied) {
      await Permission.camera.request();
    }
  }

  // Pick image from the camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    await _requestCameraPermission();

    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _captionText = "";
        _isLoading = true;
      });
      await _processImage(File(pickedFile.path));
    }
  }

  Future<void> _sendImageForCaptioning(File image) async {
    try {
      final uri = Uri.parse('http://192.168.1.13:5000/caption'); // Replace with your actual backend URL

      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('image', image.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        final Map<String, dynamic> data = json.decode(responseString);
        final caption = data['caption'] ?? 'No caption received';

        setState(() {
          _caption = data['caption'] ?? 'No caption received';
        });

        await _speakText(caption);
      } else {
        setState(() {
          _captionText = 'Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _captionText = 'Failed to connect to server.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _speakText(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera and Captioning'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null)
              Image.file(_image!, height: 200, width: 200, fit: BoxFit.cover)
            else
              Text('No image selected'),

            const SizedBox(height: 20),

            // Buttons for taking photo and selecting from gallery
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo),
                  label: const Text('Gallery'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (_loading)
              CircularProgressIndicator()
            else if (_caption.isNotEmpty)
              Text('Caption: $_caption', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
