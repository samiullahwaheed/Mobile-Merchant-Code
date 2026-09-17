import 'package:flutter/material.dart';

class FullScreenImageViewer extends StatefulWidget {
  final Widget image;

  const FullScreenImageViewer({super.key, required this.image});

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  Animation<Matrix4>? zoomAnimation;
  late TransformationController transformationController;
  TapDownDetails? doubleTapDetails;

  @override
  void initState() {
    super.initState();
    transformationController = TransformationController();
    animationController =
    AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
      transformationController.value = zoomAnimation!.value;
    });
  }

  void handleDoubleTapDown(TapDownDetails details) {
    doubleTapDetails = details;
  }

  void handleDoubleTap() {
    final newValue = transformationController.value.isIdentity()
        ? _applyZoom()
        : _revertZoom();

    zoomAnimation = Matrix4Tween(
      begin: transformationController.value,
      end: newValue,
    ).animate(CurveTween(curve: Curves.ease).animate(animationController));
    animationController.forward(from: 0);
  }

  Matrix4 _applyZoom() {
    final tapPosition = doubleTapDetails!.localPosition;
    final zoomed = Matrix4.identity()
      ..translate(-tapPosition.dx, -tapPosition.dy)
      ..scale(2.0); // Ensure you pass a double value for the scaling factor.
    return zoomed;
  }

  Matrix4 _revertZoom() => Matrix4.identity();

  @override
  void dispose() {
    transformationController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: GestureDetector(
        onDoubleTapDown: handleDoubleTapDown,
        onDoubleTap: handleDoubleTap,
        child: InteractiveViewer(
          transformationController: transformationController,
          child: Center(child: widget.image),
        ),
      ),
    );
  }
}