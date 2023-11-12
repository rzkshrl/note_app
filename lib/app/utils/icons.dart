// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_app/app/theme/theme.dart';
import 'package:note_app/app/utils/constants.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

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

Widget statusPinnedFavorited(
    BuildContext context, Map<String, dynamic> itemNotes, String date) {
  var constants = Constants();
  if (itemNotes[constants.pin] == 1 && itemNotes[constants.favorite] == 1) {
    return Row(
      children: [
        Icon(
          PhosphorIcons.regular.pushPin,
          size: 3.w,
          color: blue,
        ),
        SizedBox(
          width: 1.w,
        ),
        Icon(
          PhosphorIcons.fill.star,
          size: 3.w,
          color: yellow,
        ),
        SizedBox(
          width: 1.5.w,
        ),
        Text(
          date,
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .copyWith(fontSize: 12.sp),
        ),
      ],
    );
  } else if (itemNotes[constants.pin] == 0 &&
      itemNotes[constants.favorite] == 1) {
    return Row(
      children: [
        Icon(
          PhosphorIcons.fill.star,
          size: 3.w,
          color: yellow,
        ),
        SizedBox(
          width: 1.5.w,
        ),
        Text(
          date,
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .copyWith(fontSize: 12.sp),
        ),
      ],
    );
  } else if (itemNotes[constants.pin] == 1 &&
      itemNotes[constants.favorite] == 0) {
    return Row(
      children: [
        Icon(
          PhosphorIcons.regular.pushPin,
          size: 3.w,
          color: blue,
        ),
        SizedBox(
          width: 1.5.w,
        ),
        Text(
          date,
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .copyWith(fontSize: 12.sp),
        ),
      ],
    );
  } else {
    return Text(date,
        style: Theme.of(context)
            .textTheme
            .displayMedium!
            .copyWith(fontSize: 12.sp));
  }
}
