import 'package:flutter/material.dart';
import 'dart:math';

class VirtualMouse extends StatefulWidget {
  final Offset initialPosition;
  VirtualMouse({this.initialPosition = const Offset(100, 100)});

  @override
  _VirtualMouseState createState() => _VirtualMouseState();
}

class _VirtualMouseState extends State<VirtualMouse> {
  Offset position = Offset.zero;
  bool _leftPressed = false;
  bool _rightPressed = false;
  double _angle = 0; // 新增旋转角度状态

  // 旋转控制方法
  void _rotate() {
    setState(() {
      _angle += pi/2; // 每次旋转90度
    });
  }

  @override
  void initState() {
    super.initState();
    position = widget.initialPosition;
  }

  // 处理坐标变换
  Offset _transformDelta(Offset delta, double angle) {
    // 将弧度转换为90度的整数倍（处理浮点精度）
    final steps = ((angle / (pi / 2)).round()) % 4;

    switch (steps) {
      case 1: // 90度
        return Offset(-delta.dy, delta.dx);
      case 2: // 180度
        return Offset(-delta.dx, -delta.dy);
      case 3: // 270度
        return Offset(delta.dy, -delta.dx);
      default: // 0度或360度
        return delta;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Transform.rotate(
        angle: _angle, //90 * (pi / 180),
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              // 应用坐标变换
              final transformedDelta = _transformDelta(details.delta, _angle);
              position += transformedDelta;
            });
          },
          child: Container(
            width: 100,
            height: 100,
            color: Colors.transparent,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 鼠标指针
                Positioned(
                  left: 0,
                  top: 0,
                  child: CustomPaint(
                    size: Size(40, 40),
                    painter: CursorTrianglePainter(),
                  ),
                ),

                // 左键
                Positioned(
                  left: -10,
                  top: 50,
                  child: GestureDetector(
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
                  left: 50,
                  top: -10,
                  child: GestureDetector(
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

                // 添加旋转按钮
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
    // TopLeft 三角形绘制逻辑
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
