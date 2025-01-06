import 'package:flutter/material.dart';

enum CursorDirection{
  TopLeft,
  TopRight,
  ButtomLeft,
  ButtomRight
}
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

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: position.dx,
        top: position.dy,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
          Positioned(
            left: -20, 
            top: -20, 
            child: CustomPaint(
              size: Size(30, 30), // 设置三角形的宽度和高度
              painter: CursorTrianglePainter(),
            ),
          ),
          GestureDetector(
            onPanUpdate: (details) {
              moveTo(position + details.delta);
            },
            child: Icon(Icons.circle, size: 30, color: Colors.black),
          ),
        ]));
  }
}

class CursorTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black // 三角形颜色
      ..style = PaintingStyle.fill; // 填充样式

    Path path = Path();
    path.moveTo(0, 0); // 起点：左下角
    path.lineTo(size.width / 3, size.height); // 顶点：上中
    path.lineTo(size.width, size.height/3); // 右下角
    path.close(); // 闭合路径

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
