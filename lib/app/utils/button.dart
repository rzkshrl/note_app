import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget btnLongPressedItemHome(
    List<bool>? selectedItems,
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
                  style: selectedItems!.contains(true)
                      ? Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(fontSize: 10)
                      : Theme.of(context).textTheme.headlineLarge!.copyWith(
                          fontSize: 10,
                          color: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .color!
                              .withOpacity(0.2)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  });
}

Widget btnLongPressedItemHomeSelectAll(
    bool allSelectedItems,
    BuildContext context,
    Widget icon,
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
                Text(!allSelectedItems ? 'Select all' : 'Deselect all',
                    style: !allSelectedItems
                        ? Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(fontSize: 10)
                        : Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 10)),
              ],
            ),
          ),
        ),
      ),
    );
  });
}
