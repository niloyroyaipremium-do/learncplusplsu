import 'package:flutter/material.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final bool centerContent;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth,
    this.centerContent = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // For web, use full width but with a reasonable max width
        if (constraints.maxWidth > 1200) {
          return Center(
            child: SizedBox(width: maxWidth ?? 1200, child: child),
          );
        }

        // For mobile and tablet, use full width
        return SizedBox(width: double.infinity, child: child);
      },
    );
  }
}
