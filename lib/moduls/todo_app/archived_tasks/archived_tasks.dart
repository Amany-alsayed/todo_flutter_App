
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/component/components.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';

class ArchivedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return   BlocConsumer<AppCubit, AppStates>(
      listener:(BuildContext context, AppStates state){

      },
      builder:  (BuildContext context, AppStates state){
        var tasks = AppCubit.get(context).archivedtasks;
        return  taskBuilder(tasks: tasks);
      },
    );
  }
}
