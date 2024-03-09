import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:short_way_app/classes/query_class.dart';

import '../cell_class.dart';
import '../field.dart';

part 'tasker_event.dart';
part 'tasker_state.dart';

class TaskerBloc extends Bloc<TaskerEvent, TaskerState> {
  TaskerBloc() : super(TaskerLoadingState()) {
    on<TaskerOnCalculateEvent>(_onCalculate);
    on<TaskerOnSendEvent>(_onSend);
  }



  final _httpInitializer = Dio();

  _onSend(TaskerOnSendEvent event, Emitter<TaskerState> emit) async {
      Query query = event.query;

      emit(TaskerLoadingState(query: query)); // change state to processing
      //get response
      final res = query.method == 'GET' ? await _httpInitializer.get(
          query.apiURL, queryParameters: query.parameters) :
      await _httpInitializer.post(
          query.apiURL, queryParameters: query.parameters);

      emit(TaskerLoadingState(resCode: res.statusCode!,
          response: res.data,
          errorMessage: res.statusMessage ?? '',
          query: query)); //return state info

  }

  _onCalculate(TaskerOnCalculateEvent event, Emitter<TaskerState> emit) async {
    if (state is TaskerLoadingState) {
      TaskerLoadingState loadingState = state as TaskerLoadingState;

      //get data
      String id = loadingState.response[0]['data'][0]['id'];
      List<String> field = loadingState.response[0]['data'][0]['field'];
      int x_start = loadingState.response[0]['data'][0]['start']['x'];
      int y_start = loadingState.response[0]['data'][0]['start']['y'];
      int x_end = loadingState.response[0]['data'][0]['end']['x'];
      int y_end = loadingState.response[0]['data'][0]['end']['y'];
      //make field
      Field field_A = Field(
          id, field, Cell(x_start, y_start, 4), Cell(x_end, y_end, 4));

      //algorithm

      //start data-structure
      field_A.field[x_start][y_start].tryNewCost(0, null);
      field_A.field[x_start][y_start].stateIndex = 0; //put state into cell
      field_A.field[x_end][y_end].stateIndex = 1; //put state into cell

      //cycle WHILE for queue of CELLs.
      // In any new CELL we add range of neighbours to queue
      //                          * (check it by their options: visited, edge of table, blocked)
      // try make new cost for their neighbours

      // end of it, just went for closest way cells of endpoint while we met startpoint

      List<Cell> queue = const[];
      queue.add(field_A.field[x_start][y_start]);//startpoint
      double progress = 1;
      while(queue.isNotEmpty)
        {
          ++progress;
          Cell currCell = queue.first;
          queue.removeAt(0); //remove First
          currCell.isVisited = true;

          List<Cell> neighbors = field_A.getAvaliableNeighboursOfCell(currCell);
          neighbors.forEach((nBour) {
            int newCost = currCell.getCost() + 1;
            if (newCost < nBour.getCost()) {
              nBour.tryNewCost(newCost, currCell);
              queue.add(nBour);
            }
          });
          emit(TaskerCalculatingState(percentDone: progress / pow(field_A.field.length, 2) )); //percentage upgrade
        }

        //end of ALGORITHM

      //get solutions method
      List<List<Cell>> findAllPaths(Cell currentCell, List<Cell> currentPath) {
        List<List<Cell>> allPaths = [];

        List<Cell> updatedPath = List.from(currentPath);
        updatedPath.add(currentCell);

        if (currentCell.stateIndex == 0) {
          allPaths.add(updatedPath);
          return allPaths;
        }

        for (Cell neighborCell in currentCell.closest_cells) {
          List<List<Cell>> pathsFromNeighbor = findAllPaths(neighborCell, updatedPath);
          allPaths.addAll(pathsFromNeighbor);
        }

        if (allPaths.isNotEmpty && allPaths[0].contains(currentCell)) {
          currentCell.stateIndex = 3;
        }

        return allPaths;
      }

      List<List<Cell>> allPaths = findAllPaths(field_A.field[x_end][y_end], []);
      field_A.solutions = allPaths;

      emit(TaskerCalculatingState(percentDone: 100)); //in the finish we said about it
      await Future.delayed(const Duration(seconds: 1)); //TODO: check it (async)
      emit(TaskerResultState(field: field_A));
    }
  }


}