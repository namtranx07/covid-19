library text_style;
import 'package:flutter/material.dart';

class AppFonts {
  static String redHatDisplay = "RedHatDisplay";
}

extension TextStyleExtension on TextStyle {
  TextStyle redHatDisplayBlack() {
    return this.copyWith(fontFamily: AppFonts.redHatDisplay, fontWeight: FontWeight.w900);
  }

  TextStyle redHatDisplayBlackItalic() {
    return this.copyWith(fontFamily: AppFonts.redHatDisplay, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic);
  }

  TextStyle redHatDisplayBold() {
    return this.copyWith(fontFamily: AppFonts.redHatDisplay, fontWeight: FontWeight.bold);
  }


  TextStyle redHatDisplayMedium() {
    return this.copyWith(fontFamily: AppFonts.redHatDisplay, fontWeight: FontWeight.w500);
  }

  TextStyle redHatDisplayMediumItalic() {
    return this.copyWith(fontFamily: AppFonts.redHatDisplay, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic);
  }

  TextStyle redHatDisplayRegular() {
    return this.copyWith(fontFamily: AppFonts.redHatDisplay, fontWeight: FontWeight.normal);
  }
}