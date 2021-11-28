import 'package:flutter/material.dart';

GlobalKey myKey = GlobalKey();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var buttonColor = Colors.blueAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: buttonColor),
            key: myKey,
            onPressed: () {
              RenderBox renderBox =
                  myKey.currentContext!.findRenderObject()! as RenderBox;
              final tapLocationOffset = renderBox.localToGlobal(Offset.zero);
              final Size buttonSize = renderBox.size;
              //Todo: Show the popup
              Navigator.of(context).push(PageRouteBuilder(
                  opaque: false,
                  transitionDuration: const Duration(seconds: 0),
                  pageBuilder: (context, animation1, animation2) {
                    return OverPopupPage(
                      showOffset: tapLocationOffset,
                      buttonSize: buttonSize,
                      didChooseItem: (color) {
                        setState(() {
                          buttonColor = color;
                        });
                      },
                    );
                  }));
            },
            child: const Text("Popup Menu 1")),
      ),
    );
  }
}

class OverPopupPage extends StatefulWidget {
  final Offset showOffset;
  final Size buttonSize;
  final Function didChooseItem;

  const OverPopupPage(
      {Key? key,
      required this.showOffset,
      required this.buttonSize,
      required this.didChooseItem})
      : super(key: key);

  @override
  _OverPopupPageState createState() => _OverPopupPageState();
}

class _OverPopupPageState extends State<OverPopupPage> {
  final List<Color> listColor = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.orangeAccent
  ];

  var opacity = 0.0;
  var heightPop = 0.0;
  var widthPop = 0.0;

  void _show(bool isVisible) {
    setState(() {
      opacity = isVisible ? 1.0 : 0.0;
      heightPop = isVisible ? 200.0 : 0.0;
      widthPop = isVisible ? 160.0 : 0.0;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _show(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(child: GestureDetector(
            onTap: () {
              _show(false);
              Navigator.of(context).pop();
            },
          )),
          Positioned(
              top: widget.showOffset.dy + 30.0,
              left: widget.showOffset.dx,
              child: AnimatedOpacity(
                opacity: opacity,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
                child: AnimatedContainer(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset:
                              const Offset(0, 2), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0)),
                  height: heightPop,
                  width: widthPop,
                  duration: const Duration(milliseconds: 300),
                  child: ListView(
                    padding: const EdgeInsets.all(8.0),
                    scrollDirection: Axis.vertical,
                    children: listColor
                        .map(
                          (color) => InkWell(
                              onTap: () {
                                _show(false);
                                Navigator.of(context).pop();
                                widget.didChooseItem(color);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(children: [
                                  CircleAvatar(
                                    backgroundColor: color,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text('${color.value}'),
                                ]),
                              )),
                        )
                        .toList(),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
