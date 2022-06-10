import 'package:flutter/material.dart';

class ColorPalette {
  static const Color primary = Color(0xff0d6efd);
  static const Color secondary = Color(0xff6c757d);
  static const Color success = Color(0xff198754);
  static const Color danger = Color(0xffdc3545);
  static const Color warning = Color(0xffffc107);
  static const Color info = Color(0xff0dcaf0);
  static const Color light = Color(0xfff8f9fa);
  static const Color dark = Color(0xff212529);
}

class TextStyles {
  static const TextStyle h0 = TextStyle(
    fontSize: 40.0,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle h1 = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 20.0,
  );

  static const TextStyle h5 = TextStyle(
    fontSize: 16,
  );
}

class ButtonStyles {
  static final ButtonStyle primary =
      _fromColors(ColorPalette.primary, ColorPalette.light);
  static final ButtonStyle secondary =
      _fromColors(ColorPalette.secondary, ColorPalette.light);
  static final ButtonStyle success =
      _fromColors(ColorPalette.success, ColorPalette.light);
  static final ButtonStyle danger =
      _fromColors(ColorPalette.danger, ColorPalette.light);
  static final ButtonStyle warning =
      _fromColors(ColorPalette.warning, ColorPalette.dark);
  static final ButtonStyle info =
      _fromColors(ColorPalette.info, ColorPalette.light);
  static final ButtonStyle light =
      _fromColors(ColorPalette.light, ColorPalette.dark);
  static final ButtonStyle black =
      _fromColors(ColorPalette.dark, ColorPalette.light);

  static ButtonStyle _fromColors(Color bg, Color fg) {
    return ButtonStyle(
      foregroundColor: MaterialStateProperty.all(fg),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.focused) ||
              states.contains(MaterialState.pressed)) {
            return bg.withOpacity(0.25);
          } else if (states.contains(MaterialState.hovered)) {
            return bg.withOpacity(0.75);
          }
          return bg;
        },
      ),
    );
  }
}
