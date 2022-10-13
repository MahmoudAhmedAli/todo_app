import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/moduls/archive_tasks/archive_tasks_screen.dart';
import 'package:todoapp/moduls/done_tasks/done_tasks_screen.dart';
import 'package:todoapp/moduls/new_tasks/new_tasks_screen.dart';
import 'package:todoapp/shared/cubiit/states.dart';

class AppCubit extends Cubit<AppStates>
{
AppCubit():super(AppInitialState());

static AppCubit get (context)=> BlocProvider.of(context);


int currentindex=0;

List<Widget>screens=[
  NewTasksScreen(),
  DoneTasksScreen(),
  ArchiveTasksScreen(),

];

List<String>titles=[
  'New Tasks',
  'Done Tasks',
  'Archived Tasks',
];

void changeIndex(int index){
  currentindex=index;
  emit(AppChangeBottomNavBarState());
}

late Database database;
List<Map> tasks =[];
List<Map> newTasks =[];
List<Map> doneTasks =[];
List<Map> archiveTasks =[];



void createDatabase() {
   openDatabase(
    'todo.db',
    version: 1,
    onCreate: (database,version)
    {
      print('data base is created');
      database.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)').then((value)
      {
        print('table created');
      }).catchError((error){
        print('Error when creating table ${error.toString()}');
      });
    },
    onOpen: (database)
    {
      getDataFromDatabase(database);
      print('data base is opend');

    },
  ).then((value) {
    database=value;
    emit(AppCreateDatabaseState());
   });
}

 insertToDatabase(
    {
      required String title,
      required String time,
      required String date,
    }
    ) async {
   await database.transaction((txn)
  {
    txn.rawInsert(
        'INSERT INTO tasks(title ,date, time, status) VALUES("$title","$date","$time","new")'
    )
        .then((value) {

      print ('$value inserted successfully');
      emit(AppIsertDatabaseState());

      getDataFromDatabase(database);

    }).catchError((error){

      print('Error when Inserting new Record ${error.toString()}');
    });
    return null;
  });
}

void getDataFromDatabase(database)
{
  newTasks=[];
  doneTasks=[];
  archiveTasks=[];
  emit(AppGetDatabaseLoadingState());
   database.rawQuery('SELECT * FROM tasks ').then((value)
   {

     tasks=value;
     print(tasks);


     tasks.forEach((element) {
      if (element['status']=='new')
        newTasks.add(element);
      else if(element['status']=='done')
        doneTasks.add(element);
      else archiveTasks.add(element);
     });
     emit(AppGetDatabaseState());


   });

}
void updateData({
  required String status,
  required int id,

}) async
{
 database.rawUpdate(
    'UPDATE tasks SET status = ? WHERE id = ?',
    ['$status', id],
).then((value){
  getDataFromDatabase(database);
  emit(AppUpdateDatabaseState());
 });
}

void deleteData({

  required int id,

}) async
{
  database.rawDelete(
      'DELETE FROM tasks WHERE id = ?',
      [id]
  ).then((value){
    getDataFromDatabase(database);
    emit(AppDeleteDatabaseState());
  });
}

bool isBootomShown=false;
IconData fabIcon=Icons.edit;

void changeBottomSheetState({
  required bool isShow,
  required IconData icon,
})
{
  isBootomShown=isShow;
  fabIcon=icon;
emit(AppChangeBotomSheetStatee());
}

}