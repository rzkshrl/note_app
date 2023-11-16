// ignore_for_file: deprecated_member_use, unnecessary_string_interpolations, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
// import 'package:note_app/app/routes/navigation_service.dart';
import 'package:note_app/app/routes/routing_constant.dart';
import 'package:note_app/app/utils/button.dart';
import 'package:note_app/app/utils/constants.dart';
import 'package:note_app/app/utils/sql_helper.dart';
import 'package:sizer/sizer.dart';
import 'package:undo/undo.dart';

import '../utils/icons.dart';
import '../utils/modalsheet.dart';
import '../utils/snackbar.dart';

class TextEditor extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final args;
  const TextEditor({this.args, super.key});

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  String noteTitle = '';
  String noteText = '';

  String noteTitleOnChange = '';
  String noteTextOnChange = '';

  var constants = Constants();
  var changes = ChangeStack();

  var titleTextController = TextEditingController();
  var textTextController = TextEditingController();
  var undoController = UndoHistoryController(
      value: const UndoHistoryValue(canRedo: true, canUndo: true));

  bool isUndoEnabled = false;
  bool isRedoEnabled = false;

  List<String> noteTextChanges = [];

  // trim string/remove whitespaces
  void handleTitleTextChange() {
    setState(() {
      noteTitle = titleTextController.text.trim();
    });
  }

  void handleNoteTextChange() {
    setState(() {
      noteText = textTextController.text.trim();
    });
  }

  @override
  void initState() {
    super.initState();
    // get data from argument routing into variables
    noteTitle = (widget.args[0] == 'new' ? '' : widget.args[1][2]);
    noteText = (widget.args[0] == 'new' ? '' : widget.args[1][3]);
    titleTextController.text =
        (widget.args[0] == 'new' ? '' : widget.args[1][2]);
    textTextController.text =
        (widget.args[0] == 'new' ? '' : widget.args[1][3]);

    titleTextController.addListener(handleTitleTextChange);
    textTextController.addListener(handleNoteTextChange);
    changes;
    if (kDebugMode) {
      debugPrint('TEST ARGUMENTASI DIMENSI : ${widget.args[0]}');
      debugPrint('TEST ARGUMENTASI ROUTING : ${widget.args[1]}');
    }
  }

  @override
  void dispose() {
    titleTextController.dispose();
    textTextController.dispose();
    super.dispose();
  }

  FocusScopeNode currentFocus() {
    return FocusScope.of(context);
  }

  // handle routing back
  void routingLogic() {
    if (widget.args[1][0] == homeViewRoute) {
      Navigator.of(context).pushReplacementNamed(homeViewRoute);
    } else if (widget.args[1][0] == favoritesViewRoute) {
      Navigator.of(context).pushReplacementNamed(favoritesViewRoute);
    }
  }

  // handle back button/onwillpop to saving notes
  Future<void> handleBack() async {
    final dateTimeNow = DateTime.now().toIso8601String();
    if (noteTitle.isEmpty) {
      // go back/dismiss page without saving
      if (noteText.isEmpty) {
        if (widget.args[0] == 'new') {
          routingLogic();
        }
      } else {
        String title = noteText.split('\n')[0];
        if (title.length > 16) {
          title = title.substring(0, 16);
        }
        setState(() {
          noteTitle = title;
        });
        if (widget.args[0] == 'new') {
          try {
            await SQLHelper()
                .createItem(noteTitle, noteText, dateTimeNow, 0, 0);
            routingLogic();
          } catch (e) {
            SnackBarService.showSnackBar(
              content: const Text("Can't save note."),
            );
            if (kDebugMode) {
              debugPrint('$e');
            }
          }
        }
      }
    }

    if (widget.args[0] == 'update' &&
        (widget.args[1][2] != titleTextController.text ||
            widget.args[1][3] != textTextController.text)) {
      await Future.delayed(const Duration(milliseconds: 50));
      promptSaveUpdatedItems(context, () {
        routingLogic();
      }, () {
        try {
          SQLHelper()
              .updateItem(noteTitle, noteText, widget.args[1][1], dateTimeNow);
          routingLogic();
        } catch (e) {
          SnackBarService.showSnackBar(
            content: const Text("Can't save note."),
          );
          if (kDebugMode) {
            debugPrint('$e');
          }
        }
      });
    } else {
      routingLogic();
    }
  }

  // save notes to sqlite databases
  Future<void> saveNotes() async {
    final dateTimeNow = DateTime.now().toIso8601String();
    if (noteTitle.isEmpty) {
      // go back/dismiss page without saving
      if (noteText.isEmpty) {
        routingLogic();
      } else {
        String title = noteText.split('\n')[0];
        if (title.length > 16) {
          title = title.substring(0, 16);
        }
        setState(() {
          noteTitle = title;
        });
        if (widget.args[0] == 'new') {
          try {
            await SQLHelper()
                .createItem(noteTitle, noteText, dateTimeNow, 0, 0);
            routingLogic();
          } catch (e) {
            SnackBarService.showSnackBar(
              content: const Text("Can't save note."),
            );
            debugPrint('$e');
          }
        }
      }
    }
    if (widget.args[0] == 'update') {
      try {
        SQLHelper()
            .updateItem(noteTitle, noteText, widget.args[1][1], dateTimeNow);
        routingLogic();
      } catch (e) {
        SnackBarService.showSnackBar(
          content: const Text("Can't save note."),
        );
        debugPrint('$e');
      }
    }
  }

  // convert date into desired String
  String extractDatefromTimeStamp() {
    if (widget.args[0] == 'new') {
      final currentDate = DateTime.now();
      final formattedDate = DateFormat('MMM dd').format(currentDate);

      if (currentDate.year == currentDate.year &&
          currentDate.month == currentDate.month &&
          currentDate.day == currentDate.day) {
        return 'Today';
      } else {
        return formattedDate;
      }
    } else {
      final currentDate = DateTime.now();
      final date = DateTime.parse(widget.args[1][4]);
      final formattedDate = DateFormat('MMM dd').format(date);

      if (currentDate.year == date.year &&
          currentDate.month == date.month &&
          currentDate.day == date.day) {
        return 'Today';
      } else {
        return formattedDate;
      }
    }
  }

  // convert time on DateTime into desired String
  String extractTimefromTimeStamp() {
    if (widget.args[0] == 'new') {
      final currentDate = DateTime.now();
      final formattedDate = DateFormat('hh:mm a').format(currentDate);

      return formattedDate;
    } else {
      final date = DateTime.parse(widget.args[1][4]);
      final formattedDate = DateFormat('hh:mm a').format(date);
      return formattedDate;
    }
  }

  Future<bool> onWillPop() async {
    await handleBack();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              floating: false,
              toolbarHeight: 6.h,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      handleBack();
                    },
                    icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      btnToolIcon(isUndoEnabled, context,
                          iconUndo(context, isUndoEnabled), () {
                        setState(() {
                          if (widget.args[0] == 'new') {
                            if (textTextController.text == '') {
                              return;
                            } else {
                              changes.undo();
                            }
                          } else {
                            undoController.undo();
                          }
                        });
                      }, (details) {
                        setState(() {
                          if (widget.args[0] == 'new') {
                            if (textTextController.text == '') {
                              return;
                            } else {
                              changes.undo();
                            }
                          } else {
                            undoController.undo();
                          }
                        });
                      }),
                      btnToolIcon(isRedoEnabled, context,
                          iconRedo(context, isRedoEnabled), () {
                        setState(() {
                          if (widget.args[0] == 'new') {
                            changes.redo();
                            if (textTextController.text == '') {
                              return;
                            } else {
                              isUndoEnabled = true;
                            }
                          } else {
                            undoController.redo();
                          }
                        });
                      }, (details) {
                        setState(() {
                          if (widget.args[0] == 'new') {
                            changes.redo();
                            if (textTextController.text == '') {
                              return;
                            } else {
                              isUndoEnabled = true;
                            }
                          } else {
                            if (textTextController.text == widget.args[1][3]) {
                              return;
                            } else {
                              isUndoEnabled = true;
                              undoController.redo();
                              undoController.onRedo.addListener(() {});
                            }
                          }
                        });
                      }),
                      IconButton(
                        onPressed: () {
                          saveNotes();
                        },
                        icon: const FaIcon(FontAwesomeIcons.check),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SliverList(
              delegate:
                  SliverChildBuilderDelegate(childCount: 2, (context, index) {
                return index == 0
                    ? Padding(
                        padding:
                            EdgeInsets.only(left: 6.w, right: 6.w, top: 1.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 1.h),
                              child: SizedBox(
                                height: 4.h,
                                child: TextFormField(
                                  controller: titleTextController,
                                  onTap: () {
                                    if (!currentFocus().hasPrimaryFocus) {
                                      currentFocus().unfocus();
                                    }
                                  },
                                  onTapOutside: (event) {
                                    if (!currentFocus().hasPrimaryFocus) {
                                      currentFocus().unfocus();
                                    }
                                  },
                                  onChanged: (text) {
                                    setState(() {
                                      if (widget.args[0] == 'update') {
                                        noteTitleOnChange = text;
                                      }
                                    });
                                  },
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(fontSize: 24.sp),
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Title',
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontSize: 24.sp),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 1.h),
                              child: Text(
                                '${extractDatefromTimeStamp()}, ${extractTimefromTimeStamp()}',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(fontSize: 10.sp),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding:
                            EdgeInsets.only(left: 6.w, right: 6.w, bottom: 2.h),
                        child: TextFormField(
                          controller: textTextController,
                          undoController: undoController,
                          onTap: () {
                            if (!currentFocus().hasPrimaryFocus) {
                              currentFocus().unfocus();
                            }
                          },
                          onTapOutside: (event) {
                            if (!currentFocus().hasPrimaryFocus) {
                              currentFocus().unfocus();
                            }
                          },
                          onChanged: (text) {
                            setState(() {
                              if (textTextController.text == '') {
                                if (widget.args[0] == 'new') {
                                  isUndoEnabled = false;
                                  isRedoEnabled = false;
                                } else {
                                  isUndoEnabled = true;
                                  isRedoEnabled = true;
                                }
                              } else {
                                isUndoEnabled = true;
                                isRedoEnabled = true;
                              }

                              changes.addGroup([
                                Change(
                                  textTextController.text,
                                  () {
                                    textTextController.text = text;
                                  },
                                  (oldValue) {
                                    if (widget.args[0] == 'new') {
                                      textTextController.text = oldValue;
                                      if (oldValue.length - 1 ==
                                              noteTextChanges.first.length ||
                                          oldValue.length ==
                                              noteTextChanges.first.length) {
                                        textTextController.text = '';
                                        isUndoEnabled = false;
                                      }
                                    } else {
                                      textTextController.text = oldValue;
                                      if (oldValue.length ==
                                          textTextController.text.length) {
                                        isUndoEnabled = true;
                                      }
                                    }
                                  },
                                ),
                              ]);
                            });
                          },
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(fontSize: 15.sp),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          autofocus: widget.args[0] == 'new' ? true : false,
                          toolbarOptions: const ToolbarOptions(
                            copy: true,
                            cut: true,
                            paste: true,
                            selectAll: true,
                          ),
                          decoration: InputDecoration.collapsed(
                            hintText: 'Write here',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontSize: 15.sp),
                          ),
                        ),
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
