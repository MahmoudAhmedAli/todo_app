import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/shared/components/component.dart';
import 'package:todoapp/shared/components/constants.dart';
import 'package:todoapp/shared/cubiit/cubit.dart';
import 'package:todoapp/shared/cubiit/states.dart';

class NewTasksScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context,state){},
      builder: (context,state){
        var tasks= AppCubit.get(context).newTasks;
        return tasksBulider(
          tasks: tasks,
        );
      },

    );
  }
}
