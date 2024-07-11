
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../Common/footer.dart';
import '../Drawer/drawer.dart';
import '../common/theme.dart';
import 'MusicBloc/music_bloc.dart';
import 'MusicBloc/music_event.dart';
import 'MusicBloc/music_state.dart';

class MusicPage extends StatelessWidget {
  const MusicPage({super.key});

  static provider() {
    return BlocProvider(
      create: ((context) => MusicBloc()..add(MusicEventLoading())),
      child: const MusicPage(),
    );
  }



  @override
  Widget build(BuildContext context) {

    if (kDebugMode) {
     // print("hien thi $item.name");
    }
    return BlocConsumer<MusicBloc, MusicState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: const Text("Music"),
              backgroundColor: appTheme.primaryColor,
            ),
            drawer: MyDrawer.provider(),
            bottomNavigationBar: const NavigationBottom(),
            body: Padding(
                padding: const EdgeInsets.all(5),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height:
                              MediaQuery.of(context).size.width * 9.0 / 16.0,
                          child: (state.controller != null)
                              ? AspectRatio(
                                  aspectRatio:
                                      state.controller!.value.aspectRatio,
                                  child: VideoPlayer(state.controller!),
                                )
                              : Container()),
                      ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 400),
                          child: (state.listSongs != null)
                              ? CustomScrollView(
                                  slivers: [
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                          (context, index) => _MyListItem(
                                              index, state, context),
                                          childCount: state.listSongs!.length),
                                    )
                                  ],
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                )),
                      SingleChildScrollView(
                          child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 400),
                        child: //
                            const Column(
                          children: [
                            // ElevatedButton(
                            //   child: const Text("Tắt"),
                            //   onPressed: () {
                            //     context.read<MusicBloc>().add(MusicEventStopService());
                            //   },
                            // ),

                          ],
                        ),
                        //)
                      ))
                    ],
                  ),
                )

                // ),
                ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                context.read<MusicBloc>().add(MusicEventChange());
              },
              child: (state.controller != null)
                  ? Icon(
                      color: Colors.white,
                      state.controller!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    )
                  : Container(),
            ));
      },
      listener: (BuildContext context, MusicState state) {},
    );
  }
}

class _MyListItem extends StatelessWidget {
  final int index;
  final MusicState state;
  final BuildContext context;

  const _MyListItem(this.index, this.state, this.context);

  @override
  Widget build(BuildContext context) {
    var item = state.listSongs!.elementAt(index);

    return GestureDetector(
      onTap: () {
        context.read<MusicBloc>().add(MusicEventChangeSong(index: index));
        if (kDebugMode) {
          print("index $index");
        }
      },
      child: Container(
          margin: const EdgeInsets.only(top: 5),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.blueGrey),
              color: appTheme.primaryColor),
          child: LimitedBox(
              maxHeight: 35,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(index.toString()),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(item.name!),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: const Text('Nghe'),
                        ),
                      )
                    ],
                  ),
                ],
              ))),
    );
  }
}
