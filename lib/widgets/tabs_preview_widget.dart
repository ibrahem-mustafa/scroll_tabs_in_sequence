import 'package:chrome_tabs_tabs_clone/widgets/tab_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class TabsPreviewWidget extends StatefulWidget {
  final BuildContext context;
  final List<Widget> tabsContent;
  final double minTabHeight;
  final double minTabWidth;
  final double minTapTop;
  final double maxTapTop;
  final double maxSpaceBetweenTwoTabs;

  TabsPreviewWidget({
    @required this.context,
    @required this.tabsContent,
    @required this.minTabHeight,
    @required this.maxSpaceBetweenTwoTabs,
    @required this.minTapTop,
    this.minTabWidth,
    this.maxTapTop,
  });
  @override
  _TabsPreviewWidgetState createState() => _TabsPreviewWidgetState();
}

class _TabsPreviewWidgetState extends State<TabsPreviewWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  MediaQueryData mq;
  double dragStartPoint;
  double distance = 0;

  bool forwardDrag;
  List<TabWidget> tabs = [];
  List<AnimationController> animatedTabs = [];
  double animationLastStep = 0;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    _animationController.addListener(() {
      if (animationLastStep == 0) {
        animationLastStep = _animation.value;
      }
      for (int i = tabs.length - 1; i >= 0; i--) {
        if (shouldUpdatePosition(i, forwardDrag, _animation.value - animationLastStep)) {
          tabs[i].updatePosition(_animation.value - animationLastStep);
        }
      }
      animationLastStep =  _animation.value;
    });



    mq = MediaQuery.of(widget.context);
    buildTabs(widget.tabsContent);
  }

  void buildTabs(List<Widget> tabsContent) {
    this.tabs.clear();
    widget.tabsContent.asMap().forEach((i, tabContent) {
      tabs.add(
        TabWidget(
          child: tabContent,
          maxTop: widget.maxTapTop ?? widget.maxSpaceBetweenTwoTabs * i + 1,
          minTop: widget.minTapTop * (i + 1),
          minWidth: widget.minTabWidth ?? mq.size.width * .75,
          height: widget.minTabHeight,
          maxSpaceBetweenTabs: widget.maxSpaceBetweenTwoTabs,
        ),
      );
    });
  }

  void runAnimation({
    @required Velocity velocity,
    @required double height,
    @required double distance,
    double sensitivity = 1,
  }) {
    final unitsPerSecondY = velocity.pixelsPerSecond.dy / height;
    final unitsPerSecond = Offset(0.0, unitsPerSecondY);

    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(mass: 30, stiffness: 1, damping: 1);

    final simulation = SpringSimulation(spring, 0, sensitivity, unitVelocity);

    // print((1 - (1/unitsPerSecondY  +1)));
    // print(velocity.pixelsPerSecond.dy / distance);
    print(distance * (1 - (1/(unitsPerSecondY + 1))));
    _animation = _animationController.drive(Tween(
      begin: 0,
      end: distance * (1 - (1/(unitsPerSecondY + 1))),
    ));

    _animationController.animateWith(simulation).whenCompleteOrCancel(() {
      animationLastStep = 0;
    });
  }

  bool shouldUpdatePosition(int index, bool forward, double distance) {
    if (index == 0) return false;

    if (forward) {
      double space = tabs[1].top - tabs[0].top;

      if (space >= widget.maxSpaceBetweenTwoTabs) {
        return false;
      }

      if (index == tabs.length - 1) return true;

      space = (tabs[index + 1].top) - tabs[index].top;
      print('=================================================');
      print(index);
      print(space);
      print(widget.maxSpaceBetweenTwoTabs);
      print('=================================================');
      if (space <= widget.maxSpaceBetweenTwoTabs ) return false;

      return true;
    } else {
      if (tabs[index].top > widget.minTapTop * (index + 1)) return true;

      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (details) {
        if (_animationController.isAnimating) {
          _animationController.stop();
        }
        dragStartPoint = details.localPosition.dy.floorToDouble();
        distance = 0;
      },
      onVerticalDragDown: (details) {
        if (_animationController.isAnimating) {
          _animationController.stop();
        }

        distance = 0;
      },
      onVerticalDragUpdate: (details) {
        double diffPosition =
            (details.localPosition.dy - dragStartPoint).floorToDouble();
        dragStartPoint += diffPosition;
        distance += diffPosition;
        forwardDrag = diffPosition > 0;
        // tabs[tabs.length - 1].updatePosition(diffPosition);
        for (int i = tabs.length - 1; i >= 0; i--) { 
          if (shouldUpdatePosition(i, forwardDrag, diffPosition)) {
            tabs[i].updatePosition(diffPosition);
          }
        }
      },
      onVerticalDragEnd: (details) {
        

        runAnimation(
            height: mq.size.height,
            distance: distance,
            velocity: details.velocity);
        
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.green,
        child: Stack(
          alignment: Alignment.topCenter,
          children: tabs,
        ),
      ),
    );
  }
}
