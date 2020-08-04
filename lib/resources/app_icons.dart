import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcons {
  AppIcons._();

  static const _icon_folder = 'images';

  static final SvgPicture ic_user = loadSvgFromAssetWithCustomColor("user.svg", Colors.grey);
  static final SvgPicture ic_search = loadSvgFromAssetWithCustomColor("search.svg", Colors.grey);

  static loadSvgFromAsset(String path) {
    return SvgPicture.asset('$_icon_folder/$path');
  }

  static loadSvgFromAssetWithCustomColor(String path, Color color) {
    return SvgPicture.asset(
      '$_icon_folder/$path',
      color: color,
    );
  }
}