// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:note_app/app/theme/theme.dart';
import 'package:sizer/sizer.dart';

Widget promptDeleteAllItems(BuildContext context, void Function()? onPressed) {
  bool? isDeleteEnabled = false;
  return StatefulBuilder(builder: (context, setState) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h, right: 4.w, left: 4.w),
      child: Container(
        padding: EdgeInsets.only(top: 4.h, bottom: 2.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Theme.of(context).primaryColor,
        ),
        child: Padding(
          padding: EdgeInsets.only(right: 6.w, left: 6.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'All notes will be deleted from this device. Please do this carefully',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(fontSize: 10.sp),
              ),
              const SizedBox(height: 8.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isDeleteEnabled = !isDeleteEnabled!;
                  });
                },
                child: Row(
                  children: [
                    Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: isDeleteEnabled,
                      onChanged: (value) {
                        setState(() {
                          isDeleteEnabled = value;
                        });
                      },
                    ),
                    Text(
                      "I've read and understand.",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontSize: 10.sp),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'CANCEL',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: 10.sp),
                    ),
                  ),
                  TextButton(
                    onPressed: isDeleteEnabled! ? onPressed : null,
                    child: Text(
                      'DELETE',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                              fontSize: 10.sp,
                              color: isDeleteEnabled!
                                  ? red
                                  : red.withOpacity(0.4)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  });
}
