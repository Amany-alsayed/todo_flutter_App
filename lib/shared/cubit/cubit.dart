import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/states.dart';

import '../../moduls/todo_app/archived_tasks/archived_tasks.dart';
import '../../moduls/todo_app/done_tasks/done_tasks.dart';
import '../../moduls/todo_app/new_tasks/new_tasks.dart';


class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(IntialState());
  static AppCubit get(context)=> BlocProvider.of(context);
  int currentIndex=0;
  List<Widget> screens=[
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String>titles=[
    "New Tasks",
    "done Tasks",
    "Archived Tasks",
  ];

void changIndex(int index){
  currentIndex=index;
  emit( AppChangeBottomNavBarState());
}
  late Database database;
  List<Map>newtasks=[];
  List<Map>donetasks=[];
  List<Map>archivedtasks=[];


  void createDatabase() {
      openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database,version){
        print('on created');
        database.execute('create table tasks(id INTEGER PRIMARY KEY,title TEXT, date TEXT, time TEXT, status TEXT )').then((value){
          print("table is created");
        }).catchError((onError){
          print('error when created table ${onError.toString()}');
        });
      },
      onOpen: (database){
        getDataFromDatabase(database);

        print('on open');
      },
    ).then((value){
       database=value;
       emit( AppCreateDatabaseState());

      });
  }
   insertToDatabase(
      {required String title,
        required String date,
        required String time}) async{
     await database.transaction((txn) async {
      txn.rawInsert('insert into tasks(title,date,time,status)values("$title","$date","$time","new")')
          .then((value){

        print('insert one row');
        emit( AppInsertDatabaseState());
        getDataFromDatabase(database) ;
      }).catchError((onError){
        print('error when inserting row ${onError.toString()}');
      });

    });
  }
  void getDataFromDatabase(database){
    newtasks=[];
    donetasks=[];
    archivedtasks=[];
    database.rawQuery( 'select * from tasks').then((value)
    {
      value.forEach((element) {
        if(element['status']=='new'){
          newtasks.add( element);
        }
        else if(element['status']=='done'){
          donetasks.add( element);
        }
        else {
          archivedtasks.add( element);
        }
      });
      emit( AppGetDatabaseState());
    });

  }
  void update({required String status,required int id}){
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', ['${ status }',id ]).
       then((value){
         print('Successfully Updated');
         getDataFromDatabase(database) ;
         emit(AppUpdateDatabaseState());

    });

  }
  void delete({required int id}){
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).
    then((value){
      print('Successfully delete');
      getDataFromDatabase(database) ;
      emit(AppDeleteDatabaseState());

    });

  }
  bool isBottomSheetShow=false;
  IconData icon=Icons.edit;
  void changeBottomSheetShow({
    required bool isShow,
    required IconData ficon,})
  {
    isBottomSheetShow=isShow;
    icon=ficon;
    emit(AppChangeBottomNavSheetState());
  }

}

