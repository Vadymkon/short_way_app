import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:short_way_app/classes/query_class.dart';

import '../classes/tasker_bloc/tasker_bloc.dart';

class ProcessScreen extends StatelessWidget {
  const ProcessScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text('Process Screen'),
      ),
      body: Center(child: Column(children: [
        const Text(
            'All calculations has finished, you can send your results to server'),
        BlocBuilder<TaskerBloc, TaskerState>(
          builder: (context, state) {
            if (state is TaskerCalculatingState) {
              return CircularProgressIndicator(value: state.percentDone,);
            } else {
              return const Text('no data');
            }
          },
        )
      ],),),
      floatingActionButton: Row(children: [Expanded(
        child: BlocBuilder<TaskerBloc, TaskerState>(
          builder: (context, state) {
            return ElevatedButton(onPressed: () {

              if (state is TaskerResultState) {
                BlocProvider.of<TaskerBloc>(context).add(
                    TaskerOnSendEvent(query: Query(
                        'https://flutter.webspark.dev/flutter/api',
                        state.field.printQueryParams(0),
                        'POST')));

              }
            }, child: const Text('Send results to server'));
          },
        ),
      )
      ],),
    );
  }
}