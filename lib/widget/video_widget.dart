import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_providers.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  ImageCards element;
  ImageCards lastOne;
  VideoWidget(this.element, this.lastOne);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController _controller;
  

  Future<void> _initializeVideoPlayerFuture;
  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (!_isInit) {
      return;
    }
    _controller = VideoPlayerController.network(
      '${widget.element.imageUrl}',
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.pause();
    print('${widget.lastOne.description} 33333333333333333333333333333333');
    
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    //_initializeVideoPlayerFuture
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.element.id == widget.lastOne.id && widget.lastOne!=null) {
      _controller.play();
      print('${widget.element.description}///////////////////////////////');
    }

    print('build again......t...t..t...t.');
    // _controller.dispose();
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // if(_controller.value.isPlaying){
            //   _controller.pause();
            // }
            // else{
            //   _controller.play();
            // }
            _controller.initialize();
            _controller.pause();
            print('hogo........play');
          },
          child: Container(
            height: 525,
            child: Column(
              children: [
                Container(
                    width: width,
                    child: FutureBuilder(
                      future: _initializeVideoPlayerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return AspectRatio(
                            aspectRatio: 16 / 12,
                            child: VideoPlayer(_controller),
                          );
                        } else {
                          return Center(
                              child: Container(
                                  height: width * (9 / 16),
                                  child: CircularProgressIndicator()));
                        }
                      },
                    )),
                Expanded(
                    child:
                        Container(child: Text('${widget.element.description}')))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
