import 'package:chrome_tabs_tabs_clone/widgets/sequence_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class SequenceList extends StatefulWidget {
  final BuildContext context;
  final List<Widget> tabsContent;
  final double minTabHeight;
  final double minTabWidth;
  final double maxSpaceBetweenTwoTabs;
  final double minSpaceBetweenTwoTabs;

  SequenceList({
    @required this.context,
    @required this.tabsContent,
    @required this.minTabHeight,
    @required this.maxSpaceBetweenTwoTabs,
    @required this.minSpaceBetweenTwoTabs,
    this.minTabWidth,
  });
  @override
  _TabsPreviewWidgetState createState() => _TabsPreviewWidgetState();
}

class _TabsPreviewWidgetState extends State<SequenceList>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  MediaQueryData mq;
  double dragStartPoint;
  double distance = 0;

  bool forwardDrag;
  List<SequenceItem> tabs = [];
  List<AnimationController> animatedTabs = [];
  double animationLastStep = 0;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _animationController.addListener(() {
      if (animationLastStep == 0) {
        animationLastStep = _animation.value;
      }
      for (int i = tabs.length - 1; i >= 0; i--) {
        if (shouldUpdatePosition(i, forwardDrag, _animation.value)) {
          tabs[i].updatePosition(_animation.value);
        }
      }
      animationLastStep = _animation.value;
    });

    mq = MediaQuery.of(widget.context);
    buildTabs(widget.tabsContent);
  }

  void buildTabs(List<Widget> tabsContent) {
    this.tabs.clear();
    widget.tabsContent.asMap().forEach((i, tabContent) {
      tabs.add(
        SequenceItem(
          linkedItemData: () {
            return i > 0 ? tabs[i - 1].data : null;
          },
          maxSpaceBetweenTwoTabs: widget.maxSpaceBetweenTwoTabs,
          minSpaceBetweenTwoTabs: widget.minSpaceBetweenTwoTabs,
          child: tabContent,
          maxTop: widget.maxSpaceBetweenTwoTabs * (i + 1),
          minTop: widget.minSpaceBetweenTwoTabs * (i + 1),
          minWidth: widget.minTabWidth ?? mq.size.width * .75,
          height: widget.minTabHeight,
          isFirst: i == 0,
        ),
      );
    });
  }

  void runAnimation({
    @required Velocity velocity,
    @required double height,
    @required double distance,
    double sensitivity = .8,
  }) {
    // animation.animate();
    final unitsPerSecondY = velocity.pixelsPerSecond.dy / height;
    final unitsPerSecond = Offset(0.0, unitsPerSecondY);

    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(mass: 30, stiffness: 1, damping: 1);

    final simulation = SpringSimulation(spring, 0, 1, unitVelocity);

    // print((1 - (1/unitsPerSecondY  +1)));
    // print(velocity.pixelsPerSecond.dy / distance);
    // print(unitsPerSecondY.abs());
    // print({'animationDistance': distance * (1 - (1 / (unitsPerSecondY + 1)))});
    _animation = _animationController.drive(Tween(
      begin: 0,
      end: distance * (1 - (1 / (unitsPerSecondY.abs() + 1))) * sensitivity,
    ));

    _animationController.animateWith(simulation).whenCompleteOrCancel(() {
      animationLastStep = 0;
    });
  }

  bool shouldUpdatePosition(int index, bool forward, double distance) {
    if (index == 0) return false;

    if (forward) {
      double space = tabs[1].data.top + distance - tabs[0].data.top;

      if (space >= widget.maxSpaceBetweenTwoTabs) {
        return false;
      }

      if (index == tabs.length - 1) return true;

      space = (tabs[index + 1].data.top) - tabs[index].data.top;
      if (space <= widget.maxSpaceBetweenTwoTabs) return false;

      return true;
    } else {
      if (tabs[index].data.top > widget.minSpaceBetweenTwoTabs * (index + 1))
        return true;

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
            (details.localPosition.dy - dragStartPoint);
        forwardDrag = diffPosition > 0;

        if ((diffPosition > 0 && distance < 0) || (diffPosition < 0 && distance > 0)) {
          distance = 0;
        }

        print({details.localPosition.dy: distance});
        print(diffPosition);
        
        dragStartPoint = details.localPosition.dy;

        distance += diffPosition;
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
