import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../classes/cell_class.dart';
import '../classes/field.dart';
import '../classes/tasker_bloc/tasker_bloc.dart';

class ResListScreen extends StatelessWidget {
  const ResListScreen({super.key});

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
      body: Center(child: Column(children: [
        BlocBuilder<TaskerBloc, TaskerState>(
          builder: (context, state) {
            Field field = Field('id', [''], Cell(0,0,1),Cell(0,0,1));
            List solutions = [];
            if (state is TaskerResultState) {
              solutions = state.field.solutions;
              field = state.field;
            }

            return ListView.builder(
              itemCount: solutions.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Center(
                    child: Text(
                      field.printShortSolution(index),
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                );
              },);
          },
        ),
      ],),),
    );
  }
}