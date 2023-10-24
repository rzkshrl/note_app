// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:intl/intl.dart';
import 'package:note_app/app/routes/routing_constant.dart';
import 'package:note_app/app/utils/modalSheet.dart';
import 'package:note_app/app/utils/sql_helper.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

import '../utils/constants.dart';
import '../utils/popupmenu.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  // animation controller for All Notes btn
  late AnimationController cAniAllNotes;
  // animation controller for FAB btn
  late AnimationController cAniFAB;
  late AnimationController cAniFAB2;

  // animationController with index for item on listview
  Map<int, AnimationController> cAniItemNotes = {};
  late AnimationController cAniItemDeleteNotes;

  bool isRotated = false;
  bool isFABClicked = false;
  bool isFABClicked2 = false;
  bool isLongPressed = false;
  // bool status with index for item on listview
  Map<int, bool> isItemClicked = {};
  bool isItemDeletedClicked = false;

  late List<Map<String, dynamic>> notesData;
  Set<int> selectedNoteIds = {};

  List<bool> selectedItems = [];

  var constants = Constants();

  @override
  void initState() {
    super.initState();
    cAniAllNotes = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    cAniFAB = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    cAniFAB2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    cAniItemDeleteNotes = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  // handle animation on AllNotes category
  void handleButtonClick() {
    setState(() {
      isRotated = !isRotated;
      if (isRotated) {
        cAniAllNotes.forward(from: 0);
      } else {
        cAniAllNotes.reverse(from: 1);
      }
    });
  }

  // handle animation on FAB button
  void handleButtonClickFAB() {
    setState(() {
      isFABClicked = !isFABClicked;
      if (isFABClicked) {
        cAniFAB.forward(from: 0);
      } else {
        cAniFAB.reverse(from: 1);
      }
      isFABClicked2 = !isFABClicked2;
      if (isFABClicked2) {
        cAniFAB2.forward(from: 0);
      } else {
        cAniFAB2.reverse(from: 1);
      }
    });
  }

  //handle animation on items notes
  void handleItemNotesAnimation(int index) {
    setState(() {
      isItemClicked[index] = !isItemClicked[index]!;
      if (isItemClicked[index]!) {
        cAniItemNotes[index]!.forward(from: 0);
      } else {
        cAniItemNotes[index]!.reverse(from: 1);
      }
    });
  }

  // read all data from database/to show on Home
  Future<List<Map<String, dynamic>>> readDataAll() async {
    try {
      List<Map> notesList = await SQLHelper().getAllItem();
      List<Map<String, dynamic>> notesData =
          List<Map<String, dynamic>>.from(notesList);
      notesData
          .sort((a, b) => (b[constants.date]).compareTo(a[constants.date]));
      return notesData;
    } catch (e) {
      debugPrint('$e');
      return [{}];
    }
  }

  void afterNavigatorPop() {
    setState(() {});
  }

  // handle long press item
  void handleLongPressNotes(int id) {
    setState(() {
      if (selectedNoteIds.contains(id) == false) {
        selectedNoteIds.add(id);
      }
    });
  }

  // remove selection after long press
  void handleLongPressNotesAfterSelect(int id) {
    setState(() {
      if (selectedNoteIds.contains(id) == true) {
        selectedNoteIds.remove(id);
      }
    });
  }

  void handleDelete() async {
    try {
      var notesDB = SQLHelper();
      for (int id in selectedNoteIds) {
        await notesDB.deleteItem(id);
      }
    } catch (e) {
      debugPrint('$e');
    } finally {
      setState(() {
        selectedNoteIds = {};
      });
    }
  }

  // convert timestamp to DateTime types/for sorting date
  String extractDatefromTimeStamp(String timestamp) {
    final currentDate = DateTime.now();
    final yesterday = currentDate.subtract(const Duration(days: 1));
    final dateTime = DateTime.parse(timestamp);
    final formattedDate = DateFormat('MMM dd').format(dateTime);

    if (dateTime.year == currentDate.year &&
        dateTime.month == currentDate.month &&
        dateTime.day == currentDate.day) {
      return 'Today';
    } else if (dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return formattedDate;
    }
  }

  // convert timestamp to HH:mm
  String extractTimefromTimeStamp(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    final formattedDate = DateFormat('HH:mm').format(dateTime);

    return formattedDate;
  }

  String getSelectedItemCount() {
    int count = 0;
    for (bool isSelected in selectedItems) {
      if (isSelected) {
        count++;
      }
    }
    if (count == 0) {
      return 'None';
    }
    return '${count.toString()} item';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        floatingActionButton: isLongPressed
            ? Container()
            : Padding(
                padding: EdgeInsets.only(
                  right: 4.w,
                ),
                child: AnimatedBuilder(
                    animation: cAniFAB2,
                    builder: (context, child) {
                      return ScaleTransition(
                        scale: Tween(begin: 1.2, end: 1.13).animate(cAniFAB2),
                        child: SizedBox(
                          width: 10.w,
                          child: InkWell(
                            enableFeedback: false,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            splashFactory: NoSplash.splashFactory,
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context)
                                      .floatingActionButtonTheme
                                      .backgroundColor),
                              child: GestureDetector(
                                onTap: () async {
                                  handleButtonClickFAB();
                                  // navService.routeTo(textEditorViewRoute);
                                  Future.delayed(
                                          const Duration(milliseconds: 101))
                                      .then((value) => Navigator.of(context)
                                          .pushReplacementNamed(
                                              textEditorNewViewRoute));
                                },
                                // onLongPressCancel: () {
                                //   cAniFAB.reverse();
                                //   cAniFAB2.reverse();
                                // },
                                // onLongPressUp: () {
                                //   cAniFAB.reverse();
                                //   cAniFAB2.reverse();
                                // },
                                // onLongPressDown: (details) {
                                //   cAniFAB.reverse();
                                //   cAniFAB2.reverse();
                                // },
                                onLongPressStart: (details) {
                                  handleButtonClickFAB();
                                  cAniFAB.forward();
                                  cAniFAB2.forward();
                                },
                                onLongPressEnd: (details) async {
                                  await cAniFAB.reverse();
                                  await cAniFAB2.reverse();
                                  // navService.routeTo(textEditorViewRoute);
                                  if (details.velocity ==
                                      Velocity(pixelsPerSecond: Offset(1, 1))) {
                                    return;
                                  } else {
                                    await Navigator.of(context)
                                        .pushReplacementNamed(
                                            textEditorNewViewRoute);
                                  }
                                },
                                child: AnimatedBuilder(
                                  animation: cAniFAB,
                                  builder: (context, child) {
                                    return ScaleTransition(
                                      scale: Tween(begin: 1.05, end: 1.4)
                                          .animate(cAniFAB),
                                      child: child,
                                    );
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 3.w, top: 4.45.h),
                                    child: FaIcon(FontAwesomeIcons.plus,
                                        size: 18,
                                        color: Theme.of(context)
                                            .floatingActionButtonTheme
                                            .foregroundColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
        body: FooterView(
          footer: Footer(
            backgroundColor: Colors.transparent,
            child: isLongPressed
                ? Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: PhosphorIcon(PhosphorIcons.regular.share),
                            ),
                            Text(
                              "Share",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: PhosphorIcon(
                                  PhosphorIcons.regular.sneakerMove),
                            ),
                            Text(
                              "Share",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: PhosphorIcon(PhosphorIcons.regular.trash),
                            ),
                            Text(
                              "Share",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: PhosphorIcon(PhosphorIcons.regular.check),
                            ),
                            Text(
                              "Share",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Container(),
          ),
          flex: 2,
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(left: 4.w, right: 4.w),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: readDataAll(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 48.h,
                          ),
                          const Center(child: Text(''))
                        ],
                      );
                    }
                    notesData = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isLongPressed
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    isLongPressed = false;
                                    selectedItems.clear();
                                    selectedNoteIds.clear();
                                  });
                                },
                                icon: PhosphorIcon(PhosphorIcons.regular.x),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                    PopupMenuButton<dynamic>(
                                        tooltip: '',
                                        icon: ClipOval(
                                          child: Material(
                                            color: Colors.transparent,
                                            child: Icon(
                                              Icons.more_vert_rounded,
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                            ),
                                          ),
                                        ),
                                        offset: Offset(-2.5.w, 5.5.h),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0)),
                                        itemBuilder: (context) => [
                                              buildPopupMenuItem(
                                                  'Grid view',
                                                  1,
                                                  Theme.of(context)
                                                      .popupMenuTheme
                                                      .textStyle!,
                                                  () {}),
                                              CustomPopupMenuDivider(
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color!
                                                    .withOpacity(0.3),
                                              ),
                                              buildPopupMenuItem(
                                                  'Delete items',
                                                  2,
                                                  Theme.of(context)
                                                      .popupMenuTheme
                                                      .textStyle!, () {
                                                setState(() {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) {
                                                        return promptDeleteAllItems(
                                                          context,
                                                          () {
                                                            setState(() {
                                                              SQLHelper()
                                                                  .deleteAllItem();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                          },
                                                        );
                                                      });
                                                });
                                              }),
                                              CustomPopupMenuDivider(
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color!
                                                    .withOpacity(0.3),
                                              ),
                                              buildPopupMenuItem(
                                                  'Sort',
                                                  3,
                                                  Theme.of(context)
                                                      .popupMenuTheme
                                                      .textStyle!,
                                                  () {}),
                                              CustomPopupMenuDivider(
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color!
                                                    .withOpacity(0.3),
                                              ),
                                              buildPopupMenuItem(
                                                  'Settings',
                                                  4,
                                                  Theme.of(context)
                                                      .popupMenuTheme
                                                      .textStyle!,
                                                  () {}),
                                            ]),
                                  ]),
                        Padding(
                          padding: EdgeInsets.only(left: 3.w, top: 1.h),
                          child: isLongPressed
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${getSelectedItemCount()} selected",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge!
                                          .copyWith(fontSize: 34),
                                    ),
                                    SizedBox(
                                      height: 2.7.h,
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      splashFactory: NoSplash.splashFactory,
                                      onTap: () {
                                        handleButtonClick();
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "All Notes",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge!
                                                .copyWith(fontSize: 34),
                                          ),
                                          SizedBox(
                                            width: 2.5.w,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(top: 0.6.h),
                                            child: AnimatedBuilder(
                                              animation: cAniAllNotes,
                                              builder: (context, child) {
                                                return Transform.rotate(
                                                  angle: cAniAllNotes.value *
                                                      1 *
                                                      pi,
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
                                      '${notesData.length} Notes',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(fontSize: 16),
                                    ),
                                  ],
                                ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Form(
                          child: SizedBox(
                            height: 5.h,
                            child: TextFormField(
                              enabled: !isLongPressed,
                              style: Theme.of(context).textTheme.headlineSmall,
                              decoration: InputDecoration(
                                hintText: 'Search notes',
                                hintStyle: isLongPressed
                                    ? Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .copyWith(fontSize: 12.sp)
                                    : Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontSize: 12.sp),
                                isDense: true,
                                contentPadding: const EdgeInsets.all(0),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(
                                    left: 1.w,
                                    right: 0.8.w,
                                  ),
                                  child: Align(
                                      widthFactor: 0.5,
                                      heightFactor: 0.5,
                                      child: FaIcon(
                                        FontAwesomeIcons.search,
                                        size: 18,
                                        color: isLongPressed
                                            ? Theme.of(context)
                                                .iconTheme
                                                .color!
                                                .withOpacity(0.3)
                                            : Theme.of(context).iconTheme.color,
                                      )),
                                ),
                                filled: true,
                                fillColor: isLongPressed
                                    ? Theme.of(context)
                                        .cardColor
                                        .withOpacity(0.4)
                                    : Theme.of(context).cardColor,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28),
                                    borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: notesData.length,
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.only(bottom: 0.1.h),
                            itemBuilder: (context, index) {
                              var itemNotes = notesData[index];
                              final date = extractDatefromTimeStamp(
                                  itemNotes[constants.date]);
                              // initiate state for animationController with index and the status bool
                              if (cAniItemNotes[index] == null) {
                                cAniItemNotes[index] = AnimationController(
                                  vsync: this,
                                  duration: const Duration(milliseconds: 100),
                                );
                                isItemClicked[index] = false;
                              }

                              if (selectedItems.length <= index) {
                                selectedItems.add(false);
                              }

                              return AnimatedBuilder(
                                animation: cAniItemNotes[index]!,
                                builder: (
                                  context,
                                  child,
                                ) {
                                  return ScaleTransition(
                                    scale: Tween(begin: 1.0, end: 0.95)
                                        .animate(cAniItemNotes[index]!),
                                    child: child,
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 1.155.h),
                                  child: GestureDetector(
                                    onLongPressStart: (details) {
                                      handleItemNotesAnimation(index);
                                      cAniItemNotes[index]!.forward();
                                      selectedItems[index] =
                                          !selectedItems[index];
                                    },
                                    onLongPressEnd: (details) async {
                                      await cAniItemNotes[index]!.reverse();
                                      setState(() {
                                        isLongPressed = true;
                                        if (selectedItems[index] == true) {
                                          selectedNoteIds
                                              .add(itemNotes[constants.id]);
                                        }

                                        debugPrint(
                                            'ini selectedNoteIds : ${selectedNoteIds}');
                                        // isItemDeletedClicked = !isItemDeletedClicked;
                                        // cAniItemDeleteNotes.forward;
                                      });
                                    },
                                    child: InkWell(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      splashFactory: NoSplash.splashFactory,
                                      onTap: () async {
                                        if (isLongPressed == true) {
                                          setState(() {
                                            selectedItems[index] =
                                                !selectedItems[index];
                                            if (selectedItems[index] == true) {
                                              selectedNoteIds
                                                  .add(itemNotes[constants.id]);
                                            } else {
                                              selectedNoteIds.removeWhere((e) =>
                                                  e == itemNotes[constants.id]);
                                            }
                                            debugPrint(
                                                'ini selectedNoteIds : ${selectedNoteIds}');
                                            debugPrint(
                                                'ini selectedItems : ${selectedItems}');
                                            cAniItemNotes[index]!
                                                .forward()
                                                .then((value) => Future.delayed(
                                                        const Duration(
                                                            milliseconds: 50))
                                                    .then((value) =>
                                                        cAniItemNotes[index]!
                                                            .reverse()));
                                          });
                                        } else {
                                          handleItemNotesAnimation(index);
                                          await Future.delayed(const Duration(
                                                  milliseconds: 101))
                                              .then((value) =>
                                                  Navigator.of(context)
                                                      .pushReplacementNamed(
                                                          textEditorUpdateViewRoute,
                                                          arguments: [
                                                        itemNotes[constants.id],
                                                        itemNotes[
                                                            constants.title],
                                                        itemNotes[
                                                            constants.text],
                                                        itemNotes[
                                                            constants.date]
                                                      ]));
                                        }
                                      },
                                      child: Container(
                                        height: 9.h,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).canvasColor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 4.w, right: 4.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${itemNotes[constants.title]}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineSmall,
                                                  ),
                                                  SizedBox(
                                                    height: 0.55.h,
                                                  ),
                                                  Text(
                                                    date,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium,
                                                  ),
                                                ],
                                              ),
                                              AnimatedBuilder(
                                                animation: cAniItemDeleteNotes,
                                                builder: (
                                                  context,
                                                  child,
                                                ) {
                                                  return SlideTransition(
                                                    position: Tween<Offset>(
                                                      begin: Offset.zero,
                                                      end: const Offset(
                                                          1.5, 0.0),
                                                    ).animate(
                                                        cAniItemDeleteNotes),
                                                    // scale: Tween(begin: 1.0, end: 0.95)
                                                    //     .animate(cAniItemNotes[index]!),
                                                    child: isLongPressed
                                                        ? Checkbox(
                                                            value:
                                                                selectedItems[
                                                                    index],
                                                            onChanged: (value) {
                                                              setState(() {
                                                                selectedItems[
                                                                        index] =
                                                                    value!;
                                                                if (value ==
                                                                    true) {
                                                                  selectedNoteIds.add(
                                                                      itemNotes[
                                                                          constants
                                                                              .id]);
                                                                } else {
                                                                  selectedNoteIds.removeWhere((e) =>
                                                                      e ==
                                                                      itemNotes[
                                                                          constants
                                                                              .id]);
                                                                }

                                                                cAniItemNotes[
                                                                        index]!
                                                                    .forward()
                                                                    .then((value) => Future.delayed(const Duration(
                                                                            milliseconds:
                                                                                20))
                                                                        .then((value) =>
                                                                            cAniItemNotes[index]!.reverse()));
                                                              });
                                                            })
                                                        : const SizedBox(),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ],
                    );
                  }),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    cAniAllNotes.dispose();
    cAniFAB.dispose();
    cAniFAB2.dispose();
    super.dispose();
  }
}
