import 'package:flutter/material.dart';

class Cell {
  final int x;
  final int y;
  late final int stateIndex;

  /*
  0 - start cell
  1 - end cell
  2 - blocked cell
  3 - short-way cell
  4 - empty cell
   */

  //for Dijkstra algorithm data:
  bool isVisited = false;
  int _cost = 10001; //infinity
  late List<Cell> closest_cells;

  tryNewCost(int cost, Cell? closest_cell) {
    //try to make new cost
    if (cost <= _cost) { // if new cost is lower than
      _cost = cost; //change cost state
      if (cost == _cost)  closest_cells.clear(); // clear
      if (closest_cell != null) closest_cells.add(closest_cell);  //add it into
      else closest_cells = []; //empty in that way
    }
  }

  int getCost () {return _cost;}


  Cell(this.x, this.y,this.stateIndex );
}

Map<int,Color> cellColors = {
  0 : const Color(0xff64FFDA),
  1 : const Color(0xff009688),
  2 : const Color(0xff000000),
  3 : const Color(0xff4CAF50),
  4 : const Color(0xffFFFFFF),

};

