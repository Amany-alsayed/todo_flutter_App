
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../shared/component/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
class HomeLayout extends StatelessWidget {


  var scffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(

      create: (BuildContext context) =>
      AppCubit()
        ..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (BuildContext context, AppStates state) {
            if(state is AppInsertDatabaseState){
              Navigator.pop(context);
            }
          },
          builder: (BuildContext context, AppStates state) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              key: scffoldKey,
              appBar: AppBar(
                title: Text(cubit.titles[cubit.currentIndex]),
              ),
              body: cubit.screens[cubit.currentIndex],
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottomSheetShow) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertToDatabase(
                         title: titleController.text,
                         date: dateController.text,
                         time:timeController.text,);

                    }
                  }
                  else {
                    scffoldKey.currentState!.showBottomSheet(
                          (context) =>
                          Container(
                            color: Colors.white,

                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultTextFormField(
                                    controllerType: titleController,
                                    typeOfKeyboard: TextInputType.text,
                                    text: 'Task Title',
                                    prefix: Icons.title,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'title Must No Be Empty';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultTextFormField(
                                      controllerType: dateController,
                                      typeOfKeyboard: TextInputType.datetime,
                                      text: "Task Date",
                                      prefix: Icons.calendar_today,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return "Date Must No Be Empty";
                                        }
                                        return null;
                                      },

                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.parse(
                                              '2025-05-03'),
                                        ).then((value) {
                                          print(DateFormat.yMMMd().format(
                                              value!));
                                          dateController.text =
                                              DateFormat.yMMMd().format(value);
                                        });
                                      }
                                  ),

                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultTextFormField(
                                      controllerType: timeController,
                                      typeOfKeyboard: TextInputType.datetime,
                                      text: "Task Time",
                                      prefix: Icons.access_time,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return "Time Must No Be Empty";
                                        }
                                        return null;
                                      },

                                      onTap: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),

                                        ).then((value) {
                                          timeController.text =
                                              value!.format(context).toString();
                                          print(value.format(context));
                                        });
                                      }
                                  ),
                                ],
                              ),
                            ),
                          ),
                      elevation: 20.0,
                    ).closed.then((value) {
                      cubit.changeBottomSheetShow(isShow: false, ficon:Icons.edit);
                    });
                    cubit.changeBottomSheetShow(isShow: true, ficon:Icons.add);
                  }
                },
                child: Icon(
                  cubit.icon,
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.menu,
                      ),
                      label: 'Tasks'
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.check_circle_outline,
                      ),
                      label: 'Done'
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.archive_outlined,
                      ),
                      label: 'Archived'
                  ),

                ],
              ),
            );
          }
      ),
    );
  }
}
//1. create database
//2. create tables
//3. open database
//4. insert to database
//5. get from database
//6. update in database
//7. delete from database
