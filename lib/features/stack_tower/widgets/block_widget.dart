import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/block_model.dart';
import '../../../core/constants/app_colors.dart';

/// Widget for rendering a single block
/// Uses Container with decoration for smooth rendering
class BlockWidget extends StatelessWidget {
  final BlockModel block;
  final bool isCurrent; // Whether this is the currently moving block

  const BlockWidget({super.key, required this.block, this.isCurrent = false});

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<AppColorProvider>().blockColors;
    final color = colors[block.colorIndex % colors.length];

    return Positioned(
      left: block.left,
      top: block.y,
      child: Container(
        width: block.width,
        height: block.height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(51),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: isCurrent ? Border.all(color: Colors.white, width: 2) : null,
        ),
      ),
    );
  }
}
