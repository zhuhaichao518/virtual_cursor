import 'package:flutter/material.dart';

class VirtualMouse extends StatefulWidget {
  final Offset initialPosition;

  VirtualMouse({this.initialPosition = const Offset(100, 100)});

  @override
  _VirtualMouseState createState() => _VirtualMouseState();
}

class _VirtualMouseState extends State<VirtualMouse> {
  Offset position = Offset.zero;

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
      child: GestureDetector(
        onPanUpdate: (details) {
          moveTo(position + details.delta);
        },
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.mouse, size: 15, color: Colors.black),
            ],
          ),
        ),
      ),
    );
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
