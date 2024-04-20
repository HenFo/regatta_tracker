import 'package:flutter/material.dart';

class RegattaController extends StatefulWidget {
  final Widget child;
  final double dragHandleHeight;
  final Color? color;
  const RegattaController(
      {super.key,
      required this.child,
      this.color,
      this.dragHandleHeight = 30.0});

  @override
  State<RegattaController> createState() => _RegattaControllerState();
}

class _RegattaControllerState extends State<RegattaController>
    with SingleTickerProviderStateMixin {
  final double _maxAnimationHeight = 0.75;
  late final AnimationController _heightAnimationController;

  @override
  void dispose() {
    _heightAnimationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _heightAnimationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _heightAnimationController.value = 0.5;
    _heightAnimationController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.dragHandleHeight >= 20);

    return LayoutBuilder(builder: (context, constraints) {
      double minSheetPosition = widget.dragHandleHeight / constraints.maxHeight;
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          alignment: Alignment.bottomCenter,
          width: double.infinity,
          height: constraints.maxHeight * _heightAnimationController.value,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Grabber(
                height: widget.dragHandleHeight,
                onVerticalDragUpdate: (DragUpdateDetails details) {
                  setState(() {
                    _heightAnimationController.value =
                        _heightAnimationController.value -
                            details.delta.dy / context.size!.height;
                    if (_heightAnimationController.value > 0.95) {
                      _heightAnimationController.value = 0.95;
                    }
                    if (_heightAnimationController.value < minSheetPosition) {
                      _heightAnimationController.value = minSheetPosition;
                    }
                  });
                },
                onTapCallback: () {
                  if (_heightAnimationController.value >= 0.5) {
                    _animateSheetClose(minSheetPosition);
                  } else {
                    _animateSheetOpen();
                  }
                },
                onVerticalDragEnd: (DragEndDetails details) {
                  if (details.primaryVelocity! > 5) {
                    _animateSheetClose(minSheetPosition);
                  } else if (details.primaryVelocity! < -5) {
                    _animateSheetOpen();
                  }
                },
              ),
              Expanded(
                  child: ColoredBox(
                      color: widget.color ?? Colors.white,
                      child: widget.child)),
            ],
          ),
        ),
      );
    });
  }

  void _animateSheetOpen() {
    _heightAnimationController.animateTo(_maxAnimationHeight,
        curve: Curves.easeOutBack, duration: Durations.extralong4);
  }

  void _animateSheetClose(double minSheetPosition) {
    _heightAnimationController.animateTo(minSheetPosition,
        curve: Curves.bounceOut, duration: Durations.extralong4);
  }
}

class Grabber extends StatelessWidget {
  const Grabber({
    super.key,
    required this.onVerticalDragUpdate,
    required this.onTapCallback,
    this.onVerticalDragEnd,
    this.height = 30,
    this.color = Colors.white60,
  });

  final ValueChanged<DragUpdateDetails> onVerticalDragUpdate;
  final ValueChanged<DragEndDetails>? onVerticalDragEnd;
  final VoidCallback onTapCallback;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onVerticalDragUpdate: onVerticalDragUpdate,
      onTap: onTapCallback,
      onVerticalDragEnd: onVerticalDragEnd,
      child: Stack(children: [
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 20,
              child: CustomPaint(
                painter: HandlePainter(height: 20, color: color),
              ),
            ),
            Container(
              color: color,
              height: height - 20,
              width: double.infinity,
            )
          ],
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            width: 32.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ]),
    );
  }
}

class HandlePainter extends CustomPainter {
  final double height;
  final Color color;
  HandlePainter({required this.height, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    // Draw the curved shape
    var p1 = [0.0, height];
    var p2 = [size.width / 3, height];
    var p3 = [size.width / 2, 0.0];
    var b1 = (p2[0] + p3[0]) / 2;
    var p4 = [size.width - size.width / 3, height];
    var b2 = (p3[0] + p4[0]) / 2;
    var p5 = [size.width, height];

    Path path = Path();
    path.moveTo(p1[0], p1[1]);
    path.lineTo(p2[0], p2[1]);
    path.cubicTo(b1, height, b1, 0, p3[0], p3[1]);
    path.cubicTo(b2, 0, b2, height, p4[0], p4[1]);
    path.lineTo(p5[0], p5[1]);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
