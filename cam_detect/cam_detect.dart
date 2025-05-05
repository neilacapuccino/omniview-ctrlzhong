import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> sendFrameToYOLO(File imageFile) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('http://YOUR_BACKEND_IP:5000/detect'),
  );
  request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

  var response = await request.send();
  if (response.statusCode == 200) {
    final result = await http.Response.fromStream(response);
    print('YOLO Results: ${result.body}');
  } else {
    print('Detection failed: ${response.statusCode}');
  }
}
