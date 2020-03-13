import 'package:flutter/material.dart';

class SequenceItemData {
  // final String title;
  final SequenceItemData linkedItemData;
  final double maxSpaceBetweenTwoTabs;
  final double minSpaceBetweenTwoTabs;
  final double minTop;
  final double maxTop;
  bool isFirst;
  bool _canMove;
  double _top;

  SequenceItemData({
    // @required this.title,
    @required this.minTop,
    @required this.maxTop,
    @required this.isFirst,
    @required this.linkedItemData,
    @required this.maxSpaceBetweenTwoTabs,
    @required this.minSpaceBetweenTwoTabs,

  }) {
    this._top = minTop;
    this._canMove = !isFirst;
  }

  double get top => this._top;

  double toMoveRegardingMaxSpaceBTT(
      double itemTop, double linkedItemTop, double distance) {
    double toMove = distance;
    if (linkedItemTop != null) {
        double space = itemTop - linkedItemTop;

      if (distance > 0) {
        if (space != maxSpaceBetweenTwoTabs && space + distance > maxSpaceBetweenTwoTabs) {
          toMove = distance - (space - maxSpaceBetweenTwoTabs);
        }
      } else if (distance < 0) {
        if (space + distance < minSpaceBetweenTwoTabs) {
          toMove = distance - (space - minSpaceBetweenTwoTabs);
        }
      }
    } else {
      print('it is null');
      return 0;
    }
    
    // print({'toMove': toMove});
    return toMove;
  }

  double validMoveDistance(double distance) {
    double validDistance = distance;

    if (distance > 0 && _top + distance > maxTop) {
      validDistance = distance - ((_top + distance) - maxTop);
    } else if (distance < 0 && _top + distance < minTop) {
      validDistance = distance - ((_top + distance) - minTop);
    }
    // print({'validDistance': validDistance});
    return validDistance;
  }

  bool _moveState(bool forward) {
    this._canMove = ((forward && this.top < this.maxTop) ||
            (!forward && this.top > this.minTop)) &&
        !this.isFirst;
    return this._canMove;
  }

  double updateTop(double distance) {
    if (_moveState(distance > 0)) {
      this._top += validMoveDistance(toMoveRegardingMaxSpaceBTT(
        this._top,
        linkedItemData?.top,
        distance,
      ));
    }
    return this._top;
  }

  
}
