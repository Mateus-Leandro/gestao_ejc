import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FunctionMusicIcon {
  Widget getIcon({required String musicLink, required bool activeFields}) {
    final String lowerLink = musicLink.toLowerCase();
    final iconData = _getFontAwesomeIcon(lowerLink);

    final Color iconColor = activeFields ? _getIconColor(lowerLink) : Colors.grey;

    if (iconData != null) {
      return FaIcon(iconData, color: iconColor);
    }

    return Icon(Icons.music_note_outlined, color: iconColor);
  }

  IconData? _getFontAwesomeIcon(String link) {
    if (link.contains('spotify')) return FontAwesomeIcons.spotify;
    if (link.contains('youtube')) return FontAwesomeIcons.youtube;
    if (link.contains('deezer')) return FontAwesomeIcons.deezer;
    return null;
  }

  Color _getIconColor(String link) {
    if (link.contains('spotify')) return Colors.green;
    if (link.contains('youtube')) return Colors.red;
    if (link.contains('deezer')) return Colors.purpleAccent;
    return Colors.black54;
  }
}
