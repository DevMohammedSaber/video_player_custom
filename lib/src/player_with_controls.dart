import 'package:video_player_custom/chewie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'notifiers/index.dart';

class PlayerWithControls extends StatelessWidget {
  const PlayerWithControls({super.key});

  @override
  Widget build(BuildContext context) {
    final ChewieController chewieController = ChewieController.of(context);

    double calculateAspectRatio(BuildContext context) {
      final size = MediaQuery.of(context).size;
      final width = size.width;
      final height = size.height;

      return width > height ? width / height : height / width;
    }

    Widget buildPlayerWithControls(
      ChewieController chewieController,
      BuildContext context,
    ) {
      final playerNotifier = context.read<PlayerNotifier>();
      final child = Stack(
        children: [
          if (chewieController.placeholder != null)
            chewieController.placeholder!,
          Center(
            child: AspectRatio(
              aspectRatio:
                  chewieController.aspectRatio ??
                  chewieController.videoPlayerController.value.aspectRatio,
              child: VideoPlayer(chewieController.videoPlayerController),
            ),
          ),
          if (chewieController.overlay != null) chewieController.overlay!,
          if (Theme.of(context).platform != TargetPlatform.iOS)
            Consumer<PlayerNotifier>(
              builder:
                  (
                    BuildContext context,
                    PlayerNotifier notifier,
                    Widget? widget,
                  ) => Visibility(
                    visible: !notifier.hideStuff,
                    child: AnimatedOpacity(
                      opacity: notifier.hideStuff ? 0.0 : 0.8,
                      duration: const Duration(milliseconds: 250),
                      child: const DecoratedBox(
                        decoration: BoxDecoration(color: Colors.black54),
                        child: SizedBox.expand(),
                      ),
                    ),
                  ),
            ),
          if (!chewieController.isFullScreen)
            MaterialControls()
          else
            SafeArea(
              bottom: false,
              child: MaterialControls(),
            ),
        ],
      );

      if (chewieController.zoomAndPan ||
          chewieController.transformationController != null) {
        return InteractiveViewer(
          transformationController: chewieController.transformationController,
          maxScale: chewieController.maxScale,
          panEnabled: chewieController.zoomAndPan,
          scaleEnabled: chewieController.zoomAndPan,
          onInteractionUpdate: chewieController.zoomAndPan
              ? (_) => playerNotifier.hideStuff = true
              : null,
          onInteractionEnd: chewieController.zoomAndPan
              ? (_) => playerNotifier.hideStuff = false
              : null,
          child: child,
        );
      }

      return child;
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Center(
          child: SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: AspectRatio(
              aspectRatio: calculateAspectRatio(context),
              child: buildPlayerWithControls(chewieController, context),
            ),
          ),
        );
      },
    );
  }
}
