import 'package:flutter/material.dart';

class TabWidget extends StatefulWidget {
  final double maxSpaceBetweenTabs;
  final double height;
  final double minWidth;
  final double maxTop;
  final double minTop;
  final bool fullScreen;
  final Widget child;
  TabWidget({
    @required this.minWidth,
    @required this.minTop,
    @required this.maxTop,
    @required this.height,
    @required this.child,
    @required this.maxSpaceBetweenTabs,
    this.fullScreen = false,
  });

  final _TabWidgetState _state = _TabWidgetState();

  void updatePosition(double distance) =>
      _state.updatePotion(distance.floorToDouble());

  void setTopPosition(double top) => _state.setTopPosition(top);

  double get top => _state.top;

  @override
  _TabWidgetState createState() => _state;
}

class _TabWidgetState extends State<TabWidget>
    with SingleTickerProviderStateMixin {
  double tabHeight;
  double minTop;
  double maxTop;
  double top;

  @override
  void initState() {
    super.initState();
    tabHeight = widget.height;
    minTop = widget.minTop;
    maxTop = widget.maxTop;
    top = minTop;
  }

  double calcValidDistance(double distance) {
    double validDistance = 0;
    if (distance > 0) {
      if (top + distance > maxTop) {
        validDistance = distance - ((top + distance) - maxTop);
      }else {
        validDistance = distance;
      }
    } else if (distance < 0) {
      if (top + distance < minTop) {
        validDistance = distance - ((top + distance) - minTop);
      } else {
        validDistance = distance;
      }
    }
   
    return validDistance;
  }

  void updatePotion(double distance) {
   
   setState(() {
     top += calcValidDistance(distance);
   });
   
  }

  void setTopPosition(double position) {
    setState(() {
      top = position;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      child: Card(
        elevation: 4,
        child: Container(
          width: MediaQuery.of(context).size.width * .75,
          height: tabHeight,
          color: Colors.lime,
          child: widget.child,
        ),
      ),
    );
  }
}
