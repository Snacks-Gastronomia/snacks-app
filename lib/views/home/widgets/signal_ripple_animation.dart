import 'dart:math';

import 'package:flutter/material.dart';

class SignalRippleWidget extends StatefulWidget {
  final int count;
  final Color color;

  const SignalRippleWidget(
      {Key? key, this.count = 3, this.color = const Color(0xFF0080ff)})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignalRippleWidgetState createState() => _SignalRippleWidgetState();
}

class _SignalRippleWidgetState extends State<SignalRippleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000))
      ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: SignalRipplePainter(_controller.value,
              count: widget.count, color: widget.color),
        );
      },
    );
  }
}

class SignalRipplePainter extends CustomPainter {
  final double progress;
  final int count;
  final Color color;

  Paint _paint = Paint()..style = PaintingStyle.fill;

  SignalRipplePainter(this.progress,
      {this.count = 3, this.color = const Color(0xFF0080ff)});

  @override
  void paint(Canvas canvas, Size size) {
    double radius = min(size.width / 2, size.height / 2);

    for (int i = count; i >= 0; i--) {
      final double opacity = (1.0 - ((i + progress) / (count + 1)));
      final Color _color = color.withOpacity(opacity);
      _paint..color = _color;

      double _radius = radius * ((i + progress) / (count + 1));

      canvas.drawCircle(
          Offset(size.width / 2, size.height / 2), _radius, _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
