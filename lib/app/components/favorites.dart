// ignore_for_file: deprecated_member_use, unused_import

import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:note_app/app/routes/routing_constant.dart';
import 'package:note_app/app/theme/theme.dart';
import 'package:note_app/app/utils/dialog.dart';
import 'package:note_app/app/utils/floatingactionbutton.dart';
import 'package:note_app/app/utils/selectionbottomnavbar.dart';
import 'package:note_app/app/utils/sql_helper.dart';
import 'package:note_app/app/utils/textfield.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

import '../utils/button.dart';
import '../utils/constants.dart';
import '../utils/flexiblespacebar.dart';
import '../utils/homeandselectiontoggle.dart';
import '../utils/icons.dart';
import '../utils/modalsheet.dart';
import '../utils/popupmenu.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> with TickerProviderStateMixin {
  // animation controller for All Notes btn
  late AnimationController cAniAllNotes;
  bool isRotated = false;

  // animation controller for FAB btn
  late AnimationController cAniFAB;
  late AnimationController cAniFAB2;
  bool isFABClicked = false;
  bool isFABClicked2 = false;

  // animationController with index for item on listview
  bool isLongPressed = false;
  Map<int, AnimationController> cAniItemNotes = {};
  late AnimationController cAniItemDeleteNotes;

  // animation controller appbar collapse
  late AnimationController cAniAppBar;

  // scroll controlller for singlechildscrollview
  ScrollController scrollController = ScrollController();

  // bool status for toolbar selection on longpressed items
  bool isClicked = false;

  // bool status with index for item on listview
  Map<int, bool> isItemClicked = {};
  bool isItemDeletedClicked = false;

  // initiate notesData from database
  List<Map<String, dynamic>> notesData = [];
  List<Map<String, dynamic>> notesDataAll = [];
  List<Map<String, dynamic>> searchedNotesData = [];

  // init id and item status into set and list
  Set<int> selectedNoteIds = {};
  List<bool> selectedItems = [];
  bool allSelectedItems = false;

  // call string constants
  var constants = Constants();

  var titleFontSize = 0.sp;

  var searchTextController = TextEditingController();
  bool isSearch = false;

  void resetAnimationOnScroll() {
    for (int index in cAniItemNotes.keys) {
      cAniItemNotes[index]!.reverse();
      if (!isLongPressed) {
        selectedItems[index] = false;
      }
    }
  }

  bool isAllNotes = false;
  bool isFavoritesOnly = false;
  bool isRecentlyDeleted = false;

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

    cAniAppBar = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    scrollController.addListener(() {
      handleScroll();
      setState(() {
        titleFontSize = isSliverAppBarExpanded ? 16.sp : 14.sp;
      });
    });
    constants;
  }

  // stop animation when scrolling
  void handleScroll() {
    for (int index in cAniItemNotes.keys) {
      if (scrollController.position.userScrollDirection ==
              ScrollDirection.reverse ||
          scrollController.position.userScrollDirection ==
              ScrollDirection.forward) {
        cAniItemNotes[index]!.reverse();
        if (!isLongPressed) {
          selectedItems[index] = false;
        }
      }
    }
  }

  // handle animation on AllNotes category
  void handleButtonClick() {
    setState(() {
      cAniAllNotes.forward();
      String? currentRoute = ModalRoute.of(context)?.settings.name;
      showDialog(
        context: context,
        barrierColor: Theme.of(context).popupMenuTheme.color!.withOpacity(0.5),
        builder: (BuildContext context) {
          return buildDialogAllNotesCategory(
            isSliverAppBarExpanded,
            context,
            currentRoute!,
            notesDataAll,
            notesData,
          );
        },
        barrierDismissible: true,
      ).then((value) => cAniAllNotes.reverse());
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

  bool get isSliverAppBarExpanded {
    return scrollController.hasClients &&
        scrollController.offset > (220 - kToolbarHeight);
  }

  // read all data from database/to show on Favorites
  Future<List<Map<String, dynamic>>> readDataAll() async {
    try {
      List<Map> notesList = await SQLHelper().getFavoritedItem();
      List<Map<String, dynamic>> notesData =
          List<Map<String, dynamic>>.from(notesList);
      List<Map> notesListAll = await SQLHelper().getAllItem();
      notesDataAll = List<Map<String, dynamic>>.from(notesListAll);

      notesData.sort((a, b) => (b[constants.pin]).compareTo(a[constants.pin]));

      return notesData;
    } catch (e) {
      debugPrint('$e');
      return [{}];
    }
  }

  // filter data with search on list
  void searchToList(String searchString) {
    searchedNotesData = notesData.where((notes) {
      var title = notes['title'].toLowerCase();
      return title.contains(searchString.toLowerCase());
    }).toList();
    setState(() {});
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

  // show item count on selection
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

  // clear list and revert bool
  void clear() {
    setState(() {
      isLongPressed = false;
      selectedItems.clear();
      selectedNoteIds.clear();
      allSelectedItems = false;
    });
  }

  // callback from willpop/back button
  Future<bool> onWillPop() async {
    if (isLongPressed == true) {
      clear();
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
          floatingActionButton: isLongPressed
              ? Container()
              : showFAB(
                  cAniFAB2,
                  cAniFAB,
                ),
          bottomNavigationBar: isLongPressed
              ? showSelectionBottomBar(
                  context,
                  selectedItems,
                  selectedNoteIds,
                  notesData,
                  isClicked,
                  allSelectedItems,
                  isLongPressed,
                  setState,
                  clear,
                  btnLongPressedItemHomeSelectAll(
                    allSelectedItems,
                    context,
                    PhosphorIcon(
                      !allSelectedItems
                          ? PhosphorIcons.regular.checkSquare
                          : PhosphorIcons.fill.checkSquare,
                      color: !allSelectedItems
                          ? Theme.of(context).iconTheme.color
                          : Theme.of(context)
                              .floatingActionButtonTheme
                              .backgroundColor,
                    ),
                    () {
                      setState(() {
                        isClicked = !isClicked;
                      });
                      Future.delayed(const Duration(milliseconds: 100), () {
                        setState(() {
                          isClicked = false;
                        });
                      });
                      //action
                      allSelectedItems = !allSelectedItems;
                      if (allSelectedItems) {
                        for (var item in notesData) {
                          selectedNoteIds.add(item[constants.id]);
                        }
                        selectedItems = List<bool>.generate(
                            selectedNoteIds.length, (index) => false);
                        for (var i = 0; i < selectedItems.length; i++) {
                          selectedItems[i] = true;
                        }
                        debugPrint('select all');
                        debugPrint('selectedNoteIds : $selectedNoteIds');
                      } else if (!allSelectedItems) {
                        for (var item in notesData) {
                          selectedNoteIds.remove(item[constants.id]);
                        }
                        selectedItems = List<bool>.generate(
                            selectedNoteIds.length, (index) => false);
                        for (var i = 0; i < selectedItems.length; i++) {
                          selectedItems[i] = false;
                          allSelectedItems = false;
                          debugPrint('deselect all');
                          debugPrint('selectedNoteIds : $selectedNoteIds');
                        }
                      }
                    },
                    (details) {
                      setState(() {
                        isClicked = !isClicked;
                      });
                      //action
                      allSelectedItems = !allSelectedItems;
                      if (allSelectedItems) {
                        for (var item in notesData) {
                          selectedNoteIds.add(item[constants.id]);
                        }
                        selectedItems = List<bool>.generate(
                            selectedNoteIds.length, (index) => false);
                        for (var i = 0; i < selectedItems.length; i++) {
                          selectedItems[i] = true;
                        }
                        debugPrint('select all');
                        debugPrint('selectedNoteIds : $selectedNoteIds');
                      } else if (!allSelectedItems) {
                        for (var item in notesData) {
                          selectedNoteIds.remove(item[constants.id]);
                        }
                        selectedItems = List<bool>.generate(
                            selectedNoteIds.length, (index) => false);
                        for (var i = 0; i < selectedItems.length; i++) {
                          selectedItems[i] = false;
                          allSelectedItems = false;
                          debugPrint('deselect all');
                          debugPrint('selectedNoteIds : $selectedNoteIds');
                        }
                      }
                    },
                  ),
                )
              : null,
          body: FutureBuilder<List<Map<String, dynamic>>>(
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
                return GestureDetector(
                  onVerticalDragDown: (details) {
                    resetAnimationOnScroll();
                  },
                  onVerticalDragEnd: (details) {
                    resetAnimationOnScroll();
                  },
                  child: buildFavorites(),
                );
              })),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    cAniAllNotes.dispose();
    cAniFAB.dispose();
    cAniFAB2.dispose();
    super.dispose();
  }

  Widget buildFavorites() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      controller: scrollController,
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
          pinned: true,
          snap: false,
          floating: false,
          expandedHeight: 25.h,
          centerTitle: false,
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            if (isSliverAppBarExpanded)
              if (isLongPressed)
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        clear();
                      },
                      icon: PhosphorIcon(PhosphorIcons.regular.x),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 1.w),
                      child: Text(
                        "${getSelectedItemCount()} selected",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(fontSize: titleFontSize),
                      ),
                    ),
                  ],
                )
              else
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  onTap: () {
                    handleButtonClick();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My favorites",
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(fontSize: titleFontSize),
                        ),
                        SizedBox(
                          width: 2.5.w,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 0.1.h),
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
                              size: 14,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
            else
              const SizedBox(),
            popupMenuBtn(context, setState, promptDeleteAllItems),
          ]),
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: EdgeInsets.only(top: 5.h, left: 4.w, right: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  toggleTitleHomeFavorites(
                    isLongPressed,
                    context,
                    () {
                      setState(() {
                        isLongPressed = false;
                        selectedItems.clear();
                        selectedNoteIds.clear();
                        allSelectedItems = false;
                      });
                    },
                    getSelectedItemCount(),
                    () {
                      handleButtonClick();
                    },
                    cAniAllNotes,
                    searchTextController.text.isEmpty
                        ? notesData
                        : searchedNotesData,
                    isRotated,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  searchBox(
                      isLongPressed, isSearch, context, searchTextController,
                      (text) {
                    searchToList(text);
                  }),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(childCount: 1, (context, index) {
            return Padding(
              padding: EdgeInsets.only(left: 4.w, right: 4.w),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchTextController.text.isEmpty
                        ? notesData.length
                        : searchedNotesData.length,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 0.1.h),
                    itemBuilder: (context, index) {
                      var itemNotes = searchTextController.text.isEmpty
                          ? notesData[index]
                          : searchedNotesData[index];
                      final date =
                          extractDatefromTimeStamp(itemNotes[constants.date]);
                      // initiate state for animationController with index and the status bool
                      if (cAniItemNotes[index] == null) {
                        cAniItemNotes[index] = AnimationController(
                          vsync: this,
                          duration: const Duration(milliseconds: 100),
                        );
                        isItemClicked[index] = false;
                      }
                      // set default value : false for selectedItems
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
                            onLongPressDown: (details) {
                              cAniItemNotes[index]!.forward();
                            },
                            onLongPressStart: (details) {
                              selectedItems[index] = !selectedItems[index];
                            },
                            onLongPressEnd: (details) async {
                              await cAniItemNotes[index]!.reverse();
                              setState(() {
                                isLongPressed = true;
                                if (selectedItems[index] == true) {
                                  selectedNoteIds.add(itemNotes[constants.id]);
                                }

                                debugPrint(
                                    'ini selectedNoteIds : $selectedNoteIds');
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
                                  selectedItems[index] = !selectedItems[index];
                                  setState(() {
                                    if (selectedItems[index] == true) {
                                      selectedNoteIds
                                          .add(itemNotes[constants.id]);
                                    } else {
                                      selectedNoteIds.removeWhere(
                                          (e) => e == itemNotes[constants.id]);
                                    }
                                    debugPrint(
                                        'ini selectedNoteIds : $selectedNoteIds');
                                    debugPrint(
                                        'ini selectedItems : $selectedItems');
                                    Future.delayed(
                                        const Duration(milliseconds: 20), () {
                                      cAniItemNotes[index]!.reverse();
                                    });
                                  });
                                } else {
                                  cAniItemNotes[index]!.forward();
                                  Future.delayed(
                                      const Duration(milliseconds: 70), () {
                                    cAniItemNotes[index]!.reverse();
                                  });

                                  await Future.delayed(
                                          const Duration(milliseconds: 101))
                                      .then((value) => Navigator.of(context)
                                              .pushReplacementNamed(
                                                  textEditorUpdateViewRoute,
                                                  arguments: [
                                                itemNotes[constants.id],
                                                itemNotes[constants.title],
                                                itemNotes[constants.text],
                                                itemNotes[constants.date],
                                                ModalRoute.of(context)
                                                    ?.settings
                                                    .name,
                                              ]));
                                }
                              },
                              child: Container(
                                height: 9.h,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).canvasColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 4.w, right: 4.w),
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
                                                .headlineSmall!
                                                .copyWith(fontSize: 12.sp),
                                          ),
                                          SizedBox(
                                            height: 0.55.h,
                                          ),
                                          statusPinnedFavorited(
                                              context, itemNotes, date),
                                        ],
                                      ),
                                      AnimatedBuilder(
                                        animation: cAniItemNotes[index]!,
                                        child: isLongPressed
                                            ? AnimatedBuilder(
                                                animation:
                                                    cAniItemNotes[index]!,
                                                builder: (
                                                  context,
                                                  child,
                                                ) {
                                                  return SlideTransition(
                                                    position: Tween<Offset>(
                                                      begin: Offset.zero,
                                                      end: const Offset(
                                                          -0.05, 0.0),
                                                    ).animate(
                                                      cAniItemNotes[index]!,
                                                    ),
                                                    child: child,
                                                  );
                                                },
                                                child: Checkbox(
                                                    value: selectedItems[index],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedItems[index] =
                                                            value!;
                                                        if (value == true) {
                                                          selectedNoteIds.add(
                                                              itemNotes[
                                                                  constants
                                                                      .id]);
                                                        } else {
                                                          selectedNoteIds
                                                              .removeWhere((e) =>
                                                                  e ==
                                                                  itemNotes[
                                                                      constants
                                                                          .id]);
                                                        }
                                                        debugPrint(
                                                            'ini selectedNoteIds : $selectedNoteIds');
                                                        debugPrint(
                                                            'ini selectedItems : $selectedItems');
                                                        cAniItemNotes[index]!
                                                            .forward()
                                                            .then((value) => Future.delayed(
                                                                    const Duration(
                                                                        milliseconds:
                                                                            60))
                                                                .then((value) =>
                                                                    cAniItemNotes[
                                                                            index]!
                                                                        .reverse()));
                                                      });
                                                    }),
                                              )
                                            : const SizedBox(),
                                        builder: (
                                          context,
                                          child,
                                        ) {
                                          return ScaleTransition(
                                            scale: Tween(begin: 1.0, end: 0.5)
                                                .animate(
                                              cAniItemNotes[index]!,
                                            ),
                                            child: child,
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
                    },
                  ),
                ],
              ),
            );
          }),
        )
      ],
    );
  }
}
