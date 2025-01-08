import 'package:flutter/material.dart';

enum CursorDirection { TopLeft, TopRight, ButtomLeft, ButtomRight }

class VirtualMouse extends StatefulWidget {
  final Offset initialPosition;
  VirtualMouse({this.initialPosition = const Offset(100, 100)});

  @override
  _VirtualMouseState createState() => _VirtualMouseState();
}

class _VirtualMouseState extends State<VirtualMouse> {
  Offset position = Offset.zero;
  CursorDirection direction = CursorDirection.TopLeft;

  @override
  void initState() {
    super.initState();
    position = widget.initialPosition;
  }

  void moveTo(Offset newPosition) {
    setState(() {
      position = newPosition;
    });
  }

  // 根据 direction 动态调整三角形的位置
  Offset _getTrianglePosition() {
    switch (direction) {
      case CursorDirection.TopLeft:
        return Offset(-20, -20);
      case CursorDirection.TopRight:
        return Offset(20, -20);
      case CursorDirection.ButtomLeft:
        return Offset(-20, 20);
      case CursorDirection.ButtomRight:
        return Offset(20, 20);
    }
  }

  Offset _getLeftButtonPosition() {
    switch (direction) {
      case CursorDirection.TopLeft:
        return Offset(-40, 0);
      case CursorDirection.TopRight:
        return Offset(20, -20);
      case CursorDirection.ButtomLeft:
        return Offset(-20, 20);
      case CursorDirection.ButtomRight:
        return Offset(20, 20);
    }
  }

  Offset _getRightButtonPosition() {
    switch (direction) {
      case CursorDirection.TopLeft:
        return Offset(-20, -20);
      case CursorDirection.TopRight:
        return Offset(20, -20);
      case CursorDirection.ButtomLeft:
        return Offset(-20, 20);
      case CursorDirection.ButtomRight:
        return Offset(20, 20);
    }
  }

  @override
  Widget build(BuildContext context) {
    Offset triangleOffset = _getTrianglePosition();
    Offset lbuttonOffset = _getLeftButtonPosition();
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: triangleOffset.dx,
            top: triangleOffset.dy,
            child: CustomPaint(
              size: Size(30, 30), // 设置三角形的宽度和高度
              painter: CursorTrianglePainter(direction: direction),
            ),
          ),
          GestureDetector(
            onPanUpdate: (details) {
              moveTo(position + details.delta);
            },
            child: Icon(Icons.circle, size: 40, color: Colors.black),
          ),
          Positioned(
            left: -lbuttonOffset.dx,
            top: lbuttonOffset.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                moveTo(position + details.delta);
              },
              child:
                  Icon(Icons.rectangle_rounded, size: 30, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class CursorTrianglePainter extends CustomPainter {
  final CursorDirection direction;

  CursorTrianglePainter({required this.direction});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black // 三角形颜色
      ..style = PaintingStyle.fill; // 填充样式

    Path path = Path();

    // 根据方向绘制三角形
    switch (direction) {
      case CursorDirection.TopLeft:
        path.moveTo(0, 0);
        path.lineTo(size.width / 3, size.height);
        path.lineTo(size.width, size.height / 3);
        break;
      case CursorDirection.TopRight:
        path.moveTo(size.width, size.height);
        path.lineTo(size.width / 2, 0);
        path.lineTo(0, size.height);
        break;
      case CursorDirection.ButtomLeft:
        path.moveTo(0, 0);
        path.lineTo(size.width / 2, size.height);
        path.lineTo(size.width, 0);
        break;
      case CursorDirection.ButtomRight:
        path.moveTo(size.width, 0);
        path.lineTo(size.width / 2, size.height);
        path.lineTo(0, 0);
        break;
    }

    path.close();
    canvas.drawPath(path, paint); // 绘制路径
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // 静态绘制，不需要重绘
  }
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
