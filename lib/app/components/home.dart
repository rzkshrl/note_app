// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:note_app/app/routes/routing_constant.dart';
import 'package:note_app/app/utils/modalSheet.dart';
import 'package:note_app/app/utils/sql_helper.dart';
import 'package:sizer/sizer.dart';

import '../routes/navigation_service.dart';
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

  bool isRotated = false;

  bool isFABClicked = false;
  bool isFABClicked2 = false;

  late List<Map<String, dynamic>> notesData;
  List<int> selectedNoteIds = [];

  bool isDeleteEnabled = false;

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
  }

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

  void handleButtonClickFABReversed() {
    setState(() {
      isFABClicked = !isFABClicked;
      if (isFABClicked) {
        cAniFAB.reverse(from: 0);
      } else {
        cAniFAB.forward(from: 1);
      }
      isFABClicked2 = !isFABClicked2;
      if (isFABClicked2) {
        cAniFAB2.reverse(from: 0);
      } else {
        cAniFAB2.forward(from: 1);
      }
    });
  }

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

  String extractTimefromTimeStamp(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    final formattedDate = DateFormat('HH:mm').format(dateTime);

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    NavigationService navService = NavigationService();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      floatingActionButton: Padding(
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
                          Future.delayed(const Duration(milliseconds: 101))
                              .then((value) => Navigator.of(context)
                                  .pushReplacementNamed(textEditorViewRoute));
                        },
                        onLongPressStart: (details) {
                          handleButtonClickFAB();
                          cAniFAB.forward();
                          cAniFAB2.forward();
                        },
                        onLongPressEnd: (details) async {
                          await cAniFAB.reverse();
                          await cAniFAB2.reverse();
                          // navService.routeTo(textEditorViewRoute);
                          await Navigator.of(context)
                              .pushReplacementNamed(textEditorViewRoute);
                        },
                        child: AnimatedBuilder(
                          animation: cAniFAB,
                          builder: (context, child) {
                            return ScaleTransition(
                              scale:
                                  Tween(begin: 1.05, end: 1.4).animate(cAniFAB),
                              child: child,
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 3.w, top: 4.45.h),
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
      body: SingleChildScrollView(
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
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    PopupMenuButton<dynamic>(
                        tooltip: '',
                        icon: ClipOval(
                          child: Material(
                            color: Colors.transparent,
                            child: Icon(
                              Icons.more_vert_rounded,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        ),
                        offset: Offset(-2.5.w, 5.5.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        itemBuilder: (context) => [
                              buildPopupMenuItem(
                                  'Grid view',
                                  1,
                                  Theme.of(context).popupMenuTheme.textStyle!,
                                  () {}),
                              CustomPopupMenuDivider(
                                color: Theme.of(context)
                                    .iconTheme
                                    .color!
                                    .withOpacity(0.3),
                              ),
                              buildPopupMenuItem('Delete items', 2,
                                  Theme.of(context).popupMenuTheme.textStyle!,
                                  () {
                                setState(() {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return promptDeleteAllItems(
                                          context,
                                          () {
                                            setState(() {
                                              SQLHelper().deleteAllItem();
                                              Navigator.of(context).pop();
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
                              buildPopupMenuItem('Sort', 3,
                                  Theme.of(context).popupMenuTheme.textStyle!,
                                  () {
                                navService.routeTo(textEditorViewRoute);
                              }),
                              CustomPopupMenuDivider(
                                color: Theme.of(context)
                                    .iconTheme
                                    .color!
                                    .withOpacity(0.3),
                              ),
                              buildPopupMenuItem(
                                  'Settings',
                                  4,
                                  Theme.of(context).popupMenuTheme.textStyle!,
                                  () {}),
                            ]),
                  ]),
                  Padding(
                    padding: EdgeInsets.only(left: 3.w, top: 1.h),
                    child: Column(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                        style: Theme.of(context).textTheme.headlineSmall,
                        decoration: InputDecoration(
                          hintText: 'Search notes',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(fontSize: 12.sp),
                          isDense: true,
                          contentPadding: const EdgeInsets.all(0),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(
                              left: 1.w,
                              right: 0.8.w,
                            ),
                            child: const Align(
                                widthFactor: 0.5,
                                heightFactor: 0.5,
                                child: FaIcon(
                                  FontAwesomeIcons.search,
                                  size: 18,
                                )),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
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
                        final date =
                            extractDatefromTimeStamp(itemNotes[constants.date]);
                        // final time = extractDatefromTimeStamp(
                        //     itemNotes[constants.date]);

                        return Padding(
                          padding: EdgeInsets.only(bottom: 1.155.h),
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            splashFactory: NoSplash.splashFactory,
                            onTap: () {},
                            child: Container(
                              height: 9.h,
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 4.w, right: 4.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              ),
                            ),
                          ),
                        );
                      }),
                ],
              );
            }),
      ),
    );
  }

  @override
  void dispose() {
    cAniAllNotes.dispose();
    cAniFAB.dispose();
    cAniFAB2.dispose();
    super.dispose();
  }
}
