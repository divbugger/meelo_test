// lib/widgets/idem_logo.dart - Reusable Idem logo widget

import 'package:flutter/material.dart';

class IdemLogo extends StatelessWidget {
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;

  const IdemLogo({
    super.key,
    this.fontSize = 24,
    this.color,
    this.fontWeight = FontWeight.w700,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'meelo',
      style: TextStyle(
        fontFamily: 'Manrope',
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Theme.of(context).colorScheme.onSurface,
        letterSpacing: -0.5,
      ),
    );
  }
}

class IdemLogoContainer extends StatelessWidget {
  final double size;
  final Color? backgroundColor;
  final Color? textColor;

  const IdemLogoContainer({
    super.key,
    this.size = 40,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor ?? Theme.of(context).colorScheme.primary,
      ),
      child: Center(
        child: IdemLogo(
          fontSize: size * 0.4,
          color: textColor ?? Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}