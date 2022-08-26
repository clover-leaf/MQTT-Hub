import 'package:bee/gen/assets.gen.dart';
import 'package:flutter/painting.dart';

class TileHelper {
  /// input: #123456
  /// output: Color(#ff123456)
  static Color stringToColor(String color) {
    final colorInString = color.replaceAll('#', '0xff');
    final _color = Color(int.parse(colorInString));
    return _color;
  }

  static String colorToString(Color color) {
    final value = color.value.toRadixString(16);
    final _value = '#${value.substring(2)}';
    return _value;
  }

  static String svgPathToString(String path) {
    final value = path.split('/').last.split('.').first;
    return value;
  }

  static SvgGenImage stringToSvg(String path) {
    switch (path) {
      case 'icon':
        return Assets.icons.icon;
      case 'moon':
        return Assets.icons.moon;
      case 'sun':
        return Assets.icons.sun;
      case 'cloud':
        return Assets.icons.cloud;
      case 'wind':
        return Assets.icons.wind;
      case 'snow':
        return Assets.icons.snow;
      case 'star':
        return Assets.icons.star;
      case 'heart':
        return Assets.icons.heart;
      case 'flash':
        return Assets.icons.flash;
      case 'lamp':
        return Assets.icons.lamp;
      case 'lamp-charge':
        return Assets.icons.lampCharge;
      case 'battery-charging':
        return Assets.icons.batteryCharging;
      default:
        return Assets.icons.sun;
    }
  }
}
