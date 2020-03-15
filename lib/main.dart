import 'package:chrome_tabs_tabs_clone/widgets/sequence_list.dart';
import 'package:flutter/material.dart';

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
      home: MyHomePage(title: 'Sequence Scroll'),
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
  double tabHeight;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    tabHeight = MediaQuery.of(context).size.height * .75;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SequenceList(
              itemDecoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black12,
                  ),
                  
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              minTabWidth: MediaQuery.of(context).size.width * .9,
              minTabHeight: tabHeight,
              maxSpaceBetweenTwoTabs: tabHeight * .25,
              minSpaceBetweenTwoTabs: 5,
              context: context,
              tabsContent: List.generate(
                10,
                (i) => Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 60,
                    width: 60,
                    child: RaisedButton(
                      child: Text(i.toString()),
                      onPressed: () => print('hello from $i'),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}
