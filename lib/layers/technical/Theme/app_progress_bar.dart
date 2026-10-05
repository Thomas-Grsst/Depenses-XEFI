import 'package:flutter/material.dart';

import 'app_tokens_context.dart';

class AppProgressBar extends StatelessWidget {
  final double value;
  final double? marker;
  final Color? fill;
  final Color? track;
  final Color? markerColor;
  final double height;
  final bool dot;

  const AppProgressBar(
    this.value, {
    super.key,
    this.marker,
    this.fill,
    this.track,
    this.markerColor,
    this.height = 8,
    this.dot = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    final barHeight = graphite ? 1.0 : height;
    final boxHeight = graphite ? 9.0 : height + 6;
    final progress = value.clamp(0.0, 1.0);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: boxHeight,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: barHeight,
                decoration: BoxDecoration(
                  color: track ?? tokens.track,
                  borderRadius: BorderRadius.circular(barHeight / 2),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                width: width * progress,
                height: barHeight,
                decoration: BoxDecoration(
                  color: fill ?? (graphite ? tokens.ink : tokens.mintFill),
                  borderRadius: BorderRadius.circular(barHeight / 2),
                ),
              ),
              if (marker != null)
                Positioned(
                  left: (width * marker!.clamp(0.0, 0.99)) - 1,
                  child: Container(
                    width: graphite ? 1 : 2,
                    height: boxHeight,
                    decoration: BoxDecoration(
                      color: markerColor ?? (graphite ? tokens.muted : tokens.ink),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              if (dot && graphite)
                Positioned(
                  left: width * progress - 3.5,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(color: tokens.accent, shape: BoxShape.circle),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
