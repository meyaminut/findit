import 'package:flutter/material.dart';

bool isDesktop(BuildContext context) => MediaQuery.sizeOf(context).width >= 960;
bool isTablet(BuildContext context) {
  final w = MediaQuery.sizeOf(context).width;
  return w >= 600 && w < 960;
}
bool isMobile(BuildContext context) => MediaQuery.sizeOf(context).width < 600;

/// Komponen pembungkus responsif yang membatasi lebar maksimal konten di layar lebar (desktop/tablet)
/// dan memastikan tampilan selalu terpusat dan ergonomis.
class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = 850,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: padding != null ? Padding(padding: padding!, child: child) : child,
      ),
    );
  }
}
