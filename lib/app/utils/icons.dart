// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

Widget iconUndo(BuildContext context, bool isTextEmpty) {
  if (isTextEmpty) {
    return const FaIcon(FontAwesomeIcons.undoAlt);
  } else {
    return FaIcon(
      FontAwesomeIcons.undoAlt,
      color: Theme.of(context).iconTheme.color!.withOpacity(0.5),
    );
  }
}

Widget iconRedo(BuildContext context, bool isTextEmpty) {
  if (isTextEmpty) {
    return const FaIcon(FontAwesomeIcons.redoAlt);
  } else {
    return FaIcon(
      FontAwesomeIcons.redoAlt,
      color: Theme.of(context).iconTheme.color!.withOpacity(0.5),
    );
  }
}
