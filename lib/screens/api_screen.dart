import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:short_way_app/classes/query_class.dart';
import 'package:short_way_app/screens/error.dart';
import 'package:short_way_app/screens/process_screen.dart';

import '../classes/tasker_bloc/tasker_bloc.dart';

class ApiScreen extends StatelessWidget {
  const ApiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: const Text('Home Screen'),
      ),
      body: SafeArea(
        child: Center(child:
        Column(
          children: [
            Text('Set valid API base URL in order to continue',
              style: TextStyle(fontSize: 18),),
            // Icon(CupertinoIcons.arrow_down_right_arrow_up_left),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              child:
              TextField(controller: controller),
            )
          ],),),
      ),
      floatingActionButton: Row(children: [Expanded(
        child: BlocBuilder<TaskerBloc, TaskerState>(
          builder: (context, state) {
            return ElevatedButton(onPressed: () {
              BlocProvider.of<TaskerBloc>(context).add(TaskerOnSendEvent(
                  query: Query.withQuery(controller.text, 'GET')));
              if (state is TaskerLoadingState)
                if (state.resCode == 200) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProcessScreen(),
                    ),
                  );
                } else {
                  errorMessage(context, 'error' + state.errorMessage);
                }

            }, child: const Text('Start counting process'));
          },
        ),
      )
      ],),
    );
  }
}

/*

 */