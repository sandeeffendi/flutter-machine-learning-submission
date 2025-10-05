import 'package:flutter/material.dart';

class FeatureContainer extends StatefulWidget {
  final double minHeight;
  final double maxHeigth;
  final double minWidth;
  final double maxWidth;
  final Color boxColor;
  final Widget? child;

  const FeatureContainer({
    super.key,
    required this.minHeight,
    required this.maxHeigth,
    required this.minWidth,
    required this.maxWidth,
    this.boxColor = const Color.fromARGB(128, 143, 143, 143),
    this.child,
  });

  @override
  State<FeatureContainer> createState() => _FeatureContainerState();
}

class _FeatureContainerState extends State<FeatureContainer> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: widget.minHeight,
        minWidth: widget.minWidth,
        maxHeight: widget.maxHeigth,
        maxWidth: widget.maxWidth,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: widget.boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: widget.child,
      ),
    );
  }
}
