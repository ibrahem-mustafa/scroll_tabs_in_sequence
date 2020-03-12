import 'package:chrome_tabs_tabs_clone/widgets/tab_widget.dart';
import 'package:chrome_tabs_tabs_clone/widgets/tabs_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Chrome Tabs Clone'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  double initDragStartPoint;
  double tabHeight;
  double minTop;
  double maxTop;

  List<TabWidget> tabs;

  @override
  void initState() {
    super.initState();

    minTop = 10;
  }

  @override
  Widget build(BuildContext context) {
    tabHeight = MediaQuery.of(context).size.height * .75;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: TabsPreviewWidget(
        maxSpaceBetweenTwoTabs: tabHeight * .20,
        minTabHeight: tabHeight,
        minTapTop: 10,
        context: context,
        tabsContent: <Widget>[
          Text('tab 1'),
          Text('tab 2'),
          Text('tab 3'),
          Text('tab 4'),
          Text('tab 5'),
          Text('tab 6'),
          Text('tab 7'),
          Text('tab 8'),
          Text('tab 9'),
          Text('tab 10'),
          Text('tab 11'),
          Text('tab 12'),
        ],
      ),
    );
  }
}
