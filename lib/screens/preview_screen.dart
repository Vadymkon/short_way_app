import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../classes/cell_class.dart';
import '../classes/field.dart';
import '../classes/tasker_bloc/tasker_bloc.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(''),
      ),
      body: const Center(child: Column(children: [
        FieldWidget(),
      ],),),
    );
  }
}

class FieldWidget extends StatelessWidget {
  const FieldWidget({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskerBloc, TaskerState>(

      builder: (context, state) {
        Field field = Field('id', [''], Cell(0,0,0), Cell(0,0,0));
        if (state is TaskerResultState) {
          field = state.field;
        }
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: field.field[0].length,
          ),
          itemCount: field.field.length * field.field[0].length,
          itemBuilder: (BuildContext context, int index) {
            int row = index ~/ field.field[0].length;
            int col = index % field.field[0].length;

            Color cellColor = cellColors[field.field[row][col].stateIndex] ?? Colors.white;

            return Container(
              color: cellColor,
              child: Center(
                child: Text(
                    '($row, $col)'), // Добавьте текст или другие элементы
              ),
            );
          },
        );
      },
    );
  }
}