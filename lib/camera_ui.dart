import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Ensure this import is present
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class CameraUI extends StatefulWidget {
  @override
  _CameraUIState createState() => _CameraUIState();
}

class _CameraUIState extends State<CameraUI> {
  File? _image;
  String _caption = "";
  bool _loading = false;

  Future<void> _requestPermission() async {
    if (await Permission.camera.isDenied) {
      await Permission.camera.request();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    await _requestPermission(); // Ensure permission
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _caption = "";
        _loading = true;
      });
      await _sendImageForCaptioning(_image!);
    }
  }

  Future<void> _sendImageForCaptioning(File image) async {
    try {
      final uri = Uri.parse('http://127.0.0.1:5000/caption'); // Update this to your backend IP
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('image', image.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);
        setState(() {
          _caption = data['caption'] ?? 'No caption received';
        });
      } else {
        setState(() {
          _caption = "Server error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _caption = "Failed to connect to server.";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera and Captioning'),
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

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),  // Use ImageSource.camera
                  icon: Icon(Icons.camera_alt),
                  label: Text('Camera'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery), // Use ImageSource.gallery
                  icon: Icon(Icons.photo),
                  label: Text('Gallery'),
                ),
              ],
            ),

            SizedBox(height: 20),

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
