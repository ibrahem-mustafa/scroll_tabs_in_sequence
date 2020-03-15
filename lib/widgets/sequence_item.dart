import 'package:chrome_tabs_tabs_clone/models/sequence_item_data_mode.dart';
import 'package:flutter/material.dart';

class SequenceItem extends StatefulWidget {
  // final String title;
  final Widget child;
  final double maxTop;
  final double minTop;
  final double maxSpaceBetweenTwoTabs;
  final double minSpaceBetweenTwoTabs;
  final double minWidth;
  final double height;
  final bool isFirst;
  final SequenceItemData Function() linkedItemData;
  BoxDecoration decoration;
  SequenceItem({
    // @required this.title,
    @required this.child,
    @required this.maxTop,
    @required this.minTop,
    @required this.maxSpaceBetweenTwoTabs,
    @required this.minSpaceBetweenTwoTabs,
    @required this.linkedItemData,
    @required this.minWidth,
    @required this.height,
    @required this.isFirst,
    this.decoration,
  });

  final _TabWidgetState _state = _TabWidgetState();

  void updatePosition(double distance) =>
      _state.updatePotion(distance);


  SequenceItemData get data => _state.itemData;

  @override
  _TabWidgetState createState() => _state;
}

class _TabWidgetState extends State<SequenceItem>
    with SingleTickerProviderStateMixin {
  double tabHeight;
  double top;

  SequenceItemData itemData;

  @override
  void initState() {
    tabHeight = widget.height;
    itemData = SequenceItemData(
      isFirst: widget.isFirst,
      maxTop: widget.maxTop,
      minTop: widget.minTop,
      linkedItemData: widget.linkedItemData(),
      maxSpaceBetweenTwoTabs: widget.maxSpaceBetweenTwoTabs,
      minSpaceBetweenTwoTabs: widget.minSpaceBetweenTwoTabs
    );
    top = itemData.top;

    super.initState();
  }

  void updatePotion(double distance) {
    setState(() {
      top = itemData.updateTop(distance);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      child: Container(
        decoration: widget.decoration,
        width: widget.minWidth ?? MediaQuery.of(context).size.width * .75,
        height: tabHeight,
        child: widget.child,
      ),
    );
  }
}
