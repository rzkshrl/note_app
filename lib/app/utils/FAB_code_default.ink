floatingActionButton: Padding(
        padding: EdgeInsets.only(right: 3.w, bottom: 2.h),
        child: AnimatedBuilder(
            animation: cAniFAB2,
            builder: (context, child) {
              return ScaleTransition(
                scale: Tween(begin: 1.2, end: 1.13).animate(cAniFAB2),
                child: SizedBox(
                  width: 10.w,
                  child: FloatingActionButton(
                    onPressed: () async {
                      handleButtonClickFAB();
                      // navService.routeTo(textEditorViewRoute);
                      Future.delayed(const Duration(milliseconds: 101)).then(
                          (value) => Navigator.of(context)
                              .pushReplacementNamed(textEditorViewRoute));
                    },
                    shape: const CircleBorder(),
                    highlightElevation: 0,
                    child: GestureDetector(
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
                        child: const FaIcon(
                          FontAwesomeIcons.plus,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),