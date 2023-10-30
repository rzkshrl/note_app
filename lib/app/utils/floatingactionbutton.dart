import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_app/app/routes/routing_constant.dart';
import 'package:sizer/sizer.dart';

Widget showFAB(
  AnimationController cAniFAB2,
  AnimationController cAniFAB,
) {
  return Padding(
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
                child: GestureDetector(
                  onTap: () {
                    cAniFAB.forward();
                    cAniFAB2.forward();

                    Future.delayed(const Duration(milliseconds: 100), () {
                      cAniFAB.reverse();
                      cAniFAB2.reverse();
                    });

                    Future.delayed(const Duration(milliseconds: 101))
                        .then((value) {
                      Navigator.of(context)
                          .pushReplacementNamed(textEditorNewViewRoute);
                    });
                  },
                  onLongPressDown: (details) {
                    cAniFAB.forward();
                    cAniFAB2.forward();
                  },
                  onLongPressEnd: (details) async {
                    await cAniFAB.reverse();
                    await cAniFAB2.reverse();
                    await Navigator.of(context)
                        .pushReplacementNamed(textEditorNewViewRoute);
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context)
                            .floatingActionButtonTheme
                            .backgroundColor),
                    child: AnimatedBuilder(
                      animation: cAniFAB,
                      builder: (context, child) {
                        return ScaleTransition(
                          scale: Tween(begin: 1.05, end: 1.4).animate(cAniFAB),
                          child: child,
                        );
                      },
                      child: Center(
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
  );
}
