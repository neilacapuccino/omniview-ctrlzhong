import 'package:flutter/material.dart';
import 'camera_ui.dart';
import 'logout_helper.dart';
import 'premium_ui.dart';

class SelectionScreen extends StatelessWidget {
  final String username;
  const SelectionScreen({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 106),
                const Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Text(
                    "Let's get started!",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 64, 46, 104),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(height: 36),
                _SelectionBox(
                  label: 'Live lens',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const CameraUI()),
                    );
                  },
                ),
                _SelectionBox(
                  label: 'Premium',
                  trailing: Icon(Icons.star, color: Colors.amber, size: 28),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const PremiumUI()),
                    );
                  },
                ),
                _SelectionBox(
                  label: 'Settings',
                  onTap: () {},
                ),
                _SelectionBox(
                  label: 'Logout',
                  onTap: () {
                    LogoutHelper.logout(context);
                  },
                ),
              ],
            ),
            // Decorative stars at the bottom
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Design(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionBox extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
  const _SelectionBox({
    required this.label,
    required this.onTap,
    this.trailing,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.92,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 28),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (trailing != null) ...[
                trailing!,
                const SizedBox(width: 28),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class Design extends StatelessWidget {
  const Design({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Stack(
        children: [
          // Star 1
          Positioned(
            left: 30,
            top: 40,
            child: Transform.rotate(
              angle: 0.2,
              child: Icon(Icons.star, size: 32, color: Color(0xFFB39DDB)),
            ),
          ),
          // Star 2
          Positioned(
            left: 80,
            top: 10,
            child: Transform.rotate(
              angle: -0.4,
              child: Icon(Icons.star, size: 24, color: Color(0xFF9575CD)),
            ),
          ),
          // Star 3
          Positioned(
            right: 60,
            top: 30,
            child: Transform.rotate(
              angle: 0.7,
              child: Icon(Icons.star, size: 40, color: Color(0xFF7E57C2)),
            ),
          ),
          // Star 4
          Positioned(
            right: 20,
            top: 60,
            child: Transform.rotate(
              angle: -0.2,
              child: Icon(Icons.star, size: 18, color: Color(0xFF512DA8)),
            ),
          ),
          // Star 5
          Positioned(
            left: 140,
            top: 60,
            child: Transform.rotate(
              angle: 0.5,
              child: Icon(Icons.star, size: 28, color: Color(0xFF9575CD)),
            ),
          ),
          // Star 6
          Positioned(
            right: 120,
            top: 80,
            child: Transform.rotate(
              angle: -0.7,
              child: Icon(Icons.star, size: 22, color: Color(0xFFB39DDB)),
            ),
          ),
        ],
      ),
    );
  }
}
