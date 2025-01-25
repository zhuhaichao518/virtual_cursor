import 'package:flutter/material.dart';
import 'dart:math';

class VirtualMouse extends StatefulWidget {
  final Offset initialPosition;
  final Function(Offset)? onPositionChanged;
  final VoidCallback? onLeftPressed;
  final VoidCallback? onLeftReleased;
  final VoidCallback? onRightPressed;
  final VoidCallback? onRightReleased;

  VirtualMouse({
    this.initialPosition = const Offset(100, 100),
    this.onPositionChanged,
    this.onLeftPressed,
    this.onLeftReleased,
    this.onRightPressed,
    this.onRightReleased,
  });

  @override
  _VirtualMouseState createState() => _VirtualMouseState();
}

class _VirtualMouseState extends State<VirtualMouse> {
  Offset position = Offset.zero;
  bool _leftPressed = false;
  bool _rightPressed = false;
  double _angle = 0;

  void _rotate() {
    setState(() {
      _angle += pi / 2;
    });
  }

  @override
  void initState() {
    super.initState();
    position = widget.initialPosition;
  }

  Offset _transformDelta(Offset delta, double angle) {
    final steps = ((angle / (pi / 2)).round()) % 4;
    switch (steps) {
      case 1:
        return Offset(-delta.dy, delta.dx);
      case 2:
        return Offset(-delta.dx, -delta.dy);
      case 3:
        return Offset(delta.dy, -delta.dx);
      default:
        return delta;
    }
  }

  void _updatePosition(Offset newPosition) {
    setState(() => position = newPosition);
    widget.onPositionChanged?.call(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Transform.rotate(
        angle: _angle,
        child: GestureDetector(
          onPanUpdate: (details) {
            final transformedDelta = _transformDelta(details.delta, _angle);
            _updatePosition(position + transformedDelta);
          },
          onPanEnd:  (_) {
            
          },
          child: Container(
            width: 100,
            height: 100,
            color: Colors.transparent,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: CustomPaint(
                    size: Size(40, 40),
                    painter: CursorTrianglePainter(),
                  ),
                ),
                Positioned(
                  left: 5,
                  top: 50,
                  child: GestureDetector(
                    onTapDown: (_) {
                      setState(() => _leftPressed = true);
                      widget.onLeftPressed?.call();
                    },
                    onTapUp: (_) {
                      setState(() => _leftPressed = false);
                      widget.onLeftReleased?.call();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _leftPressed ? Colors.blue[800] : Colors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 50,
                  top: 5,
                  child: GestureDetector(
                    onTapDown: (_) {
                      setState(() => _rightPressed = true);
                      widget.onRightPressed?.call();
                    },
                    onTapUp: (_) {
                      setState(() => _rightPressed = false);
                      widget.onRightReleased?.call();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _rightPressed ? Colors.red[800] : Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: Icon(Icons.rotate_right),
                    onPressed: _rotate,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CursorTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 3, size.height);
    path.lineTo(size.width, size.height / 3);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class VirtualMouseDemo extends StatefulWidget {
  @override
  _VirtualMouseDemoState createState() => _VirtualMouseDemoState();
}

class _VirtualMouseDemoState extends State<VirtualMouseDemo> {
  Offset _lastPosition = Offset(100, 100);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.grey[200],
            child: Center(
              child: Text(
                "虚拟鼠标控件演示",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          TextButton(
            onPressed: () => print('背景按钮'),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              '背景按钮',
              style: TextStyle(color: Colors.white),
            ),
          ),
          VirtualMouse(
            initialPosition: _lastPosition,
            onPositionChanged: (pos) {
              print('位置更新：(${pos.dx}, ${pos.dy})');
              setState(() => _lastPosition = pos);
            },
            onLeftPressed: () => print('左键按下'),
            onLeftReleased: () => print('左键释放'),
            onRightPressed: () => print('右键按下'),
            onRightReleased: () => print('右键释放'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: VirtualMouseDemo(),
  ));
}