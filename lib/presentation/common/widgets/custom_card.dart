import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const CustomCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // यहाँ थीम का उपयोग किया गया है
    final cardTheme = Theme.of(context).cardTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        padding: padding ?? const EdgeInsets.all(16),
        // सही तरीका ShapeDecoration का उपयोग करना है
        decoration: ShapeDecoration(
          color: cardTheme.color, // थीम से रंग
          shape: cardTheme.shape!, // थीम से आकार (बॉर्डर और रेडियस सहित)
          shadows: cardTheme.shadowColor != null && cardTheme.elevation! > 0
              ? [
                  BoxShadow(
                    color: cardTheme.shadowColor!,
                    blurRadius: cardTheme.elevation!,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: child,
      ),
    );
  }
}
