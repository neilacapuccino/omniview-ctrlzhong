import 'package:flutter/material.dart';

// -==-=-=-=-=-=-=- AREA WHHERE TO PUT THE CAMERA PREVIEW

class CameraBox extends StatelessWidget {
  const CameraBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE8FFF3),
      child: Center(
        child: Text(
          'CAMERA',
          style: TextStyle(
            color: const Color.fromARGB(255, 255, 0, 0),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

//-=-=-=-=-=-=-=-=-=-=--=-=-=-=-=end of line

class CameraUI extends StatefulWidget {
  const CameraUI({Key? key}) : super(key: key);

  @override
  State<CameraUI> createState() => _CameraUIState();
}

class _CameraUIState extends State<CameraUI> with SingleTickerProviderStateMixin {
  String _selectedMode = 'Lens';

  void _showModeMenu() async {
    final mode = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('Lens'),
            onTap: () => Navigator.pop(context, 'Lens'),
          ),
          ListTile(
            title: Text('Gesture'),
            onTap: () => Navigator.pop(context, 'Gesture'),
          ),
          ListTile(
            title: Text('Voice'),
            onTap: () => Navigator.pop(context, 'Voice'),
          ),
          ListTile(
            title: Text('Coming soon'),
            enabled: false,
          ),
        ],
      ),
    );
    if (mode != null && mode != _selectedMode) {
      setState(() {
        _selectedMode = mode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8FFF3), 
      body: Stack(
        children: [
          Positioned.fill(
            child: CameraBox(),
          ),
          // Top black bar with Home button, Mode centered, and flashlight icon
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Home button
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Home',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Mode centered
                  Expanded(
                    child: Center(
                      child: GestureDetector(
                        onTap: _showModeMenu,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _selectedMode,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Flashlight icon
                  IconButton(
                    icon: Icon(Icons.flashlight_on, color: Colors.white),
                    onPressed: () {
                      // TODO: Add flashlight toggle logic
                    },
                  ),
                ],
              ),
            ),
          ),
          // Bottom black bar with mode-dependent icon
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _selectedMode == 'Lens'
                      ? Text('Live', style: TextStyle(color: Colors.red, fontSize: 22, fontWeight: FontWeight.bold))
                      : Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(
                            child: _selectedMode == 'Gesture'
                                ? Icon(Icons.lightbulb, color: Colors.black, size: 40)
                                : _selectedMode == 'Voice'
                                    ? Icon(Icons.mic, color: Colors.black, size: 40)
                                    : Icon(Icons.radio_button_unchecked, color: Colors.black, size: 40),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
