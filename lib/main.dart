import 'package:flutter/material.dart';

enum CursorDirection { TopLeft, TopRight, BottomLeft, BottomRight }

class VirtualMouse extends StatefulWidget {
  final Offset initialPosition;
  VirtualMouse({this.initialPosition = const Offset(100, 100)});

  @override
  _VirtualMouseState createState() => _VirtualMouseState();
}

class _VirtualMouseState extends State<VirtualMouse> {
  Offset position = Offset.zero;
  CursorDirection direction = CursorDirection.TopLeft;
  bool _leftPressed = false;
  bool _rightPressed = false;

  @override
  void initState() {
    super.initState();
    position = widget.initialPosition;
  }

  void _toggleDirection() {
    setState(() {
      direction = CursorDirection.values[(direction.index + 1) % 4];
    });
  }

  Offset _getDirectionOffset(double distance) {
    switch (direction) {
      case CursorDirection.TopLeft:
        return Offset(distance, distance);
      case CursorDirection.TopRight:
        return Offset(distance, -distance);
      case CursorDirection.BottomLeft:
        return Offset(-distance, distance);
      case CursorDirection.BottomRight:
        return Offset(distance, distance);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Container(
        width: 200,
        height: 200,
        child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            position += details.delta;
          });
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 鼠标指针
            CustomPaint(
              size: Size(40, 40),
              painter: CursorTrianglePainter(direction: direction),
            ),

            // 左键
            Positioned(
              left: _getDirectionOffset(-10).dx,
              top: _getDirectionOffset(50).dy,
              child: GestureDetector(
                onTapDown: (_) => setState(() => _leftPressed = true),
                onTapUp: (_) => setState(() => _leftPressed = false),
                onTapCancel: () => setState(() => _leftPressed = false),
                onTap: () => print('Left Click'),
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

            // 右键
            Positioned(
              left: _getDirectionOffset(50).dx,
              top: _getDirectionOffset(-10).dy,
              child: GestureDetector(
                onTapDown: (_) => setState(() => _rightPressed = true),
                onTapUp: (_) => setState(() => _rightPressed = false),
                onTapCancel: () => setState(() => _rightPressed = false),
                onTap: () => print('Right Click'),
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

            // 切换方向按钮
            Positioned(
              left: 30,
              top: 30,
              child: IconButton(
                icon: Icon(Icons.autorenew, size: 20),
                onPressed: _toggleDirection,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  padding: EdgeInsets.all(4),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class CursorTrianglePainter extends CustomPainter {
  final CursorDirection direction;

  CursorTrianglePainter({required this.direction});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final path = Path();

    switch (direction) {
      case CursorDirection.TopLeft:
        path.moveTo(0, 0);
        path.lineTo(size.width / 3, size.height);
        path.lineTo(size.width, size.height / 3);
        break;
      case CursorDirection.TopRight:
        path.moveTo(size.width, 0);
        path.lineTo(size.width / 3*2, size.height);
        path.lineTo(0, size.height/3);
        break;
      case CursorDirection.BottomLeft:
        path.moveTo(0, size.height);
        path.lineTo(size.width / 2, size.height);
        path.lineTo(size.width, 0);
        break;
      case CursorDirection.BottomRight:
        path.moveTo(size.width, 0);
        path.lineTo(size.width / 2, size.height);
        path.lineTo(0, 0);
        break;
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CursorTrianglePainter oldDelegate) =>
      oldDelegate.direction != direction;
}

class VirtualMouseDemo extends StatefulWidget {
  @override
  _VirtualMouseDemoState createState() => _VirtualMouseDemoState();
}

class _VirtualMouseDemoState extends State<VirtualMouseDemo> {
  Offset mousePosition = Offset(100, 100);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 模拟屏幕内容
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
            onPressed: () {
              print('背景按钮');
            },
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
          // 虚拟鼠标控件
          VirtualMouse(
            initialPosition: mousePosition,
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
