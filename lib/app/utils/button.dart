import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget btnLongPressedItemHome(
    BuildContext context,
    Widget icon,
    String text,
    void Function()? onTap,
    void Function(LongPressEndDetails)? onLongPressEnd) {
  bool? isClicked = false;
  return StatefulBuilder(builder: (context, setState) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: isClicked! ? Theme.of(context).cardColor : Colors.transparent,
      child: GestureDetector(
        onLongPressDown: (details) {
          setState(() {
            isClicked = !isClicked!;
          });
        },
        onLongPressEnd: onLongPressEnd,
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: SizedBox(
            width: 22.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                Text(
                  text,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  });
}
