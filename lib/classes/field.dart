import 'cell_class.dart';


class Field {
  final String id;
  late final List<List<Cell>> field;
  late final List<List<Cell>> solutions;

  Field(this.id, List<String> field, Cell start, Cell end) {
    /*
   "field": [
        ".X.",
        ".X.",
        "..."
      ],
     */

    //initialize field FROM STRING
    int row = 0;
    field.forEach((line) {
      ++row;
      this.field.add([]);
      for (int column = 0; column < line.length; column++) {
        int stateOfCell = 4;
        if (line[column] == 'X')
          stateOfCell = 2;
        else if (row == start.x && column == start.y)
          stateOfCell = 0;
        else if (row == end.x && column == end.y) stateOfCell = 1;

        this.field.last.add(Cell(row, column, stateOfCell));
      }
    });
  }

  List<Cell> getAvaliableNeighboursOfCell(Cell currCell)
  {
    List<Cell> neighbours = const [];

    //any Cell can have only 8 neighbours
    /*
      [x-1,y-1] [x, y-1] [x+1,y-1]
        [x-1,y] [curr]   [x+1,y]
      [x-1,y+1] [x, y+1] [x+1,y+1]

     */


    //the reason cells can't be neighbours are:
    //                        *blocked
    //                        *visited
    //                        *rangeout of field (edges +- 1)

    //get whole list of cells for rangeout
    List<Cell> allCells = const [];
    field.forEach((CellsInRow) {allCells.addAll(CellsInRow);});


    if (allCells.contains(field[currCell.x-1][currCell.y-1])) neighbours.add(field[currCell.x-1][currCell.y-1]);
    if (allCells.contains(field[currCell.x-1][currCell.y])) neighbours.add(field[currCell.x-1][currCell.y]);
    if (allCells.contains(field[currCell.x-1][currCell.y+1])) neighbours.add(field[currCell.x-1][currCell.y+1]);
    if (allCells.contains(field[currCell.x][currCell.y-1])) neighbours.add(field[currCell.x][currCell.y-1]);
    // if (allCells.contains(field[currCell.x][currCell.y])) neighbours.add(field[currCell.x][currCell.y]);
    if (allCells.contains(field[currCell.x][currCell.y+1])) neighbours.add(field[currCell.x][currCell.y+1]);
    if (allCells.contains(field[currCell.x+1][currCell.y-1])) neighbours.add(field[currCell.x+1][currCell.y-1]);
    if (allCells.contains(field[currCell.x+1][currCell.y])) neighbours.add(field[currCell.x+1][currCell.y]);
    if (allCells.contains(field[currCell.x+1][currCell.y+1])) neighbours.add(field[currCell.x+1][currCell.y+1]);

    //check visited and blocked
    neighbours.forEach((nCell) {if (nCell.isVisited || nCell.stateIndex == 2) neighbours.remove(nCell); });

    return neighbours;
  }


  String printShortSolution(int whichSolution)
  {
    String res = '';
    solutions[whichSolution].forEach((Cell element) {
      res += "(${element.x},${element.y})->";
    });
    res.substring(0, res.length - 2); // remove ->
    return res;
  }

  Map<String,dynamic> printQueryParams(int whichSolution)
  {
    /*
     {
    "id": "7d785c38-cd54-4a98-ab57-44e50ae646c1",
    "result": {
      "steps": [
        {
          "x": "0",
          "y": "0"
        },
        {
          "x": "0",
          "y": "1"
        }
      ],
      "path": "(0,0)->(0,1)"
    }
  }
     */
    Map result = {};
    List<Map<String,String>> steps = [];
    solutions[whichSolution].forEach((Cell currCell) {
      steps.add({'x':currCell.x.toString(), 'y':currCell.y.toString()});
    });
    result['steps'] = steps;
    result['path'] = printShortSolution(whichSolution);

    Map<String,dynamic> queryParams = {};
    queryParams['id'] = id;
    queryParams['result'] = result;

    return queryParams;
  }
}