import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  /// Standard breakpoints
  static const double _mobileBreakpoint = 600;
  static const double _tabletBreakpoint = 1024;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (width < _mobileBreakpoint) {
          return mobile;
        } else if (width < _tabletBreakpoint && tablet != null) {
          return tablet!;
        } else {
          return desktop;
        }
      },
    );
  }
}
