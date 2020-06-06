import 'package:flutter/material.dart';
import '../widget/clicky_button.dart';
import './Input_form.dart';
import 'package:provider/provider.dart';
import '../providers/data_providers.dart';
import '../widget/video_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _isInit = true;
  var imageMode = true;
  ImageCards lastOne;
  @override
  void didChangeDependencies() {
    if (!_isInit) {
      return;
    }
    print('ye bar bar set state pe run nahi hona tha ........');
    Provider.of<DataProviders>(context, listen: false).fetchData();
    //   .then((value) {
    // var videoList = Provider.of<DataProviders>(context,listen: false)
    //     .imageData
    //     .where((element) => !element.isImage)
    //     .toList();
    // if (!imageMode) {
    //   _controller = VideoPlayerController.network(
    //     '${videoList[videoList.length - 1].imageUrl}',
    //   );
    //   _initializeVideoPlayerFuture = _controller.initialize();
    //   _controller.play();
    // }
    //  });

    _isInit = false;
    super.didChangeDependencies();
  }

  // @override
  // void dispose() {
  //   _controller.dispose();

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var elements = Provider.of<DataProviders>(context)
        .imageData
        .where((element) => element.isImage)
        .toList();
    if (!imageMode) {
      elements = Provider.of<DataProviders>(context)
          .imageData
          .where((element) => !element.isImage)
          .toList();
      lastOne = elements.length<1 ? null : elements[elements.length - 1];
    }
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: Colors.orange[600],
              backgroundImage: AssetImage('assets/images/om2.png'),
            ),
            Text('गुरुकृपा आश्रम'),
            CircleAvatar(
              backgroundColor: Colors.orange[600],
              backgroundImage: AssetImage('assets/images/om2.png'),
            )
          ],
        ),
        backgroundColor: Colors.orange[600],
        elevation: 0,
        //leading: Image.asset('assets/images/om2.png'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.red[400]
            // image: DecorationImage(
            //     image: AssetImage('assets/images/gorakhnath.jpg'))
            ),
        child: Column(
          children: [
            Expanded(
                child: Container(
                    child: Stack(
              children: [
                ...elements
                    .map((e) => Draggable(
                          axis: Axis.vertical,
                          onDragEnd: (drag) {
                            elements
                                .removeWhere((element) => element.id == e.id);
                            Provider.of<DataProviders>(context, listen: false)
                                .removeItem(e.id);
                            // for (int i = 0; i < elements.length; i++) {
                            print(
                                '${Provider.of<DataProviders>(context, listen: false).imageData.contains(e)}???????????????????????');
                            // }
                            setState(() {
                              print('Run huaa h...');
                            });
                            if (elements.length == 0) {
                              Provider.of<DataProviders>(context, listen: false)
                                  .fetchData()
                                  .then((value) => setState(() {}));
                            }
                            print('${elements.length}');
                          },
                          childWhenDragging: !imageMode
                              ? VideoWidget(e, lastOne)
                              : Container(
                                  width: width,
                                  child: Image(
                                      image: NetworkImage('${e.imageUrl}')),
                                  height: 600,
                                ),
                          feedback: Card(
                            elevation: 0,
                            color: Colors.orange[600],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: !imageMode
                                ? VideoWidget(e, lastOne)
                                : Container(
                                    child: Image(
                                        image: NetworkImage('${e.imageUrl}')),
                                    width: width,
                                    height: 600,
                                  ),
                          ),
                          child: Card(
                            elevation: 0,
                            color: Colors.orange[600],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: !imageMode
                                ? VideoWidget(e, lastOne)
                                : Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: width*(3/4),
                                          child: Image(
                                              fit: BoxFit.fitWidth,
                                              image: NetworkImage(
                                                  '${e.imageUrl}')),
                                          width: width,
                                        ),
                                        SizedBox(height: 10,),
                                        Container(
                                          width: width-2,
                                          child: Text('${e.description}',
                                         // overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 20,color: Colors.red[600]),),
                                        )
                                      ],
                                    ),
                                  ),
                          ),
                        ))
                    .toList()
              ],
            ))),
            RaisedButton(
              elevation: 20,
              highlightElevation: 0.0,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          //title: Text('Choose one'),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        InputForm.routeName,
                                        arguments: true);
                                  },
                                  child: Text('चित्र')),
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        InputForm.routeName,
                                        arguments: false);
                                  },
                                  child: Text('चलचित्र'))
                            ],
                          ),
                        ));
              },
              child: Text('सर्जन करें'),
            ),
            Container(
              height: 70,
              color: Colors.orange[600],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ClickyButton(
                      color: Colors.yellow,
                      child: Text('चित्र'),
                      onPressed: () {
                        setState(() {
                          _isInit = true;
                          imageMode = true;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ClickyButton(
                      child: Text('चलचित्र'),
                      onPressed: () {
                        _isInit = false;
                        setState(() {
                          imageMode = false;
                        });
                      },
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
