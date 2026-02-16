import 'package:flutter/material.dart';

enum MascotType { rondy, carrevite, trigo }

class MascotWidget extends StatelessWidget {
  final MascotType type;
  final double size;

  const MascotWidget({super.key, required this.type, this.size = 60});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size + (size * 0.4),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Feet
          Positioned(
            bottom: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLeg(),
                SizedBox(width: size * 0.2),
                _buildLeg(),
              ],
            ),
          ),
          // Body
          _buildBody(),
          // Arms
          Positioned(
            top: size * 0.4,
            left: 0,
            child: _buildArm(true),
          ),
          Positioned(
            top: size * 0.4,
            right: 0,
            child: _buildArm(false),
          ),
          // Face
          Positioned(
            top: size * 0.2,
            child: _buildFace(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (type) {
      case MascotType.rondy:
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: Color(0xFFF25022),
            shape: BoxShape.circle,
          ),
        );
      case MascotType.carrevite:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFF00A4EF),
            borderRadius: BorderRadius.circular(size * 0.1),
          ),
        );
      case MascotType.trigo:
        return CustomPaint(
          size: Size(size, size),
          painter: _TrianglePainter(const Color(0xFFFFB900)),
        );
    }
  }

  Widget _buildLeg() {
    return Container(
      width: size * 0.1,
      height: size * 0.3,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(size * 0.05),
      ),
    );
  }

  Widget _buildArm(bool left) {
    return Transform.rotate(
      angle: left ? -0.5 : 0.5,
      child: Container(
        width: size * 0.1,
        height: size * 0.4,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(size * 0.05),
        ),
      ),
    );
  }

  Widget _buildFace() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEye(),
            SizedBox(width: size * 0.2),
            _buildEye(),
          ],
        ),
        SizedBox(height: size * 0.1),
        Container(
          width: size * 0.4,
          height: size * 0.1,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(size * 0.05),
          ),
        ),
      ],
    );
  }

  Widget _buildEye() {
    return Container(
      width: size * 0.15,
      height: size * 0.15,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: size * 0.07,
          height: size * 0.07,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
