import 'package:flutter/material.dart';
import 'package:merchent/utils/app_log/app_log.dart';
import '../utils/app_size.dart';

class TopRoundWidget extends StatelessWidget {
  final Widget? child;
  final double? height;
  final bool hasAppBar;
  final double? curveHeight;

  const TopRoundWidget({
    super.key,
    this.child,
    this.height,
    this.hasAppBar = false,
    this.curveHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TopRoundClipper(curveHeight: curveHeight),
      child: Container(
        width: double.infinity,
        height: height ?? AppSize.height(value: 350),
        color: const Color(0xFF3FAE6A),
        child: Stack(
          children: [
            // Content (all padding controlled from outside via child)
            if (child != null) child!,

            // Back button overlay (positioned at top-left)
            if (hasAppBar)
              Positioned(
                top: 0,
                left: 0,
                child: SafeArea(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      appLog('Back button pressed');
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class TopRoundClipper extends CustomClipper<Path> {
  final double? curveHeight;

  TopRoundClipper({this.curveHeight});

  @override
  Path getClip(Size size) {
    var path = Path();
    double h = curveHeight ?? 40.0;
    path.lineTo(0, size.height - h); // Start at bottom-left, slightly up

    // Create a quadratic bezier curve
    // Control point is at the center bottom (size.width / 2, size.height)
    // End point is at bottom-right, slightly up (size.width, size.height - 30)
    var firstControlPoint = Offset(size.width / 2, size.height + h);
    var firstEndPoint = Offset(size.width, size.height - h);

    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    path.lineTo(size.width, 0); // Go to top-right
    path.close(); // Close the path (back to top-left)
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
