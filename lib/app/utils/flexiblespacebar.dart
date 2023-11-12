import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

Widget buildSelectionTitle(
    BuildContext context, void Function()? onPressed, String text) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      IconButton(
        onPressed: onPressed,
        icon: PhosphorIcon(PhosphorIcons.regular.x),
      ),
      SizedBox(
        height: 2.h,
      ),
      Padding(
        padding: EdgeInsets.only(left: 3.5.w),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .copyWith(fontSize: 24.sp),
        ),
      ),
      SizedBox(
        height: 2.7.h,
      ),
    ],
  );
}

Widget buildHomeTitle(BuildContext context, void Function()? onTap,
    AnimationController cAniAllNotes, String text, bool isRotated) {
  return Padding(
    padding: EdgeInsets.only(left: 3.w, top: 7.2.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          onTap: onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "All Notes",
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(fontSize: 24.sp),
              ),
              SizedBox(
                width: 2.5.w,
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.6.h),
                child: AnimatedBuilder(
                  animation: cAniAllNotes,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: cAniAllNotes.value * 1 * pi,
                      child: child,
                    );
                  },
                  child: const FaIcon(
                    FontAwesomeIcons.caretDown,
                    size: 18,
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .copyWith(fontSize: 12.sp),
        ),
      ],
    ),
  );
}
