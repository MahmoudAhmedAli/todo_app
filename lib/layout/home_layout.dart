import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/moduls/archive_tasks/archive_tasks_screen.dart';
import 'package:todoapp/moduls/done_tasks/done_tasks_screen.dart';
import 'package:todoapp/moduls/new_tasks/new_tasks_screen.dart';
import 'package:todoapp/shared/components/component.dart';
import 'package:todoapp/shared/components/constants.dart';
import 'package:todoapp/shared/cubiit/cubit.dart';
import 'package:todoapp/shared/cubiit/states.dart';

class HomeLayout extends StatelessWidget
{

  var scaffoldKey=GlobalKey<ScaffoldState>();
  var formKey=GlobalKey<FormState>();

  var titleController=TextEditingController();
  var timeController=TextEditingController();
  var dateController=TextEditingController();






  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener:(BuildContext context, AppStates state){
          if(state is AppIsertDatabaseState)
          {
            Navigator.pop(context);
          }
        } ,
        builder: (BuildContext context, AppStates state)
        {
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                AppCubit.get(context).titles[AppCubit.get(context).currentindex],
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) =>AppCubit.get(context).screens[AppCubit.get(context).currentindex],
              fallback: (context) => Center(child: CircularProgressIndicator()) ,

            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () //async
              {
                if(AppCubit.get(context).isBootomShown)
                {
                  if(formKey.currentState!.validate()){
                    AppCubit.get(context).insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                    );



                  }
                }else
                {
                  scaffoldKey.currentState?.showBottomSheet(
                        (context) => Container(
                      color: Colors.grey[100],
                      padding: EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            defaltFormField(
                              controller: titleController,
                              type: TextInputType.text,
                              validate: (value){
                                if(value!.isEmpty){
                                  return 'title must not be embty';
                                }

                              },
                              label: 'Task Title',
                              prefix: Icons.title,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            defaltFormField(
                              controller: timeController,
                              type: TextInputType.datetime,

                              onTap: (){
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value){
                                  timeController.text=value!.format(context).toString();
                                  // print(value?.format(context));
                                });
                              },
                              validate: (value){
                                if(value!.isEmpty){
                                  return 'time must not be embty';
                                }

                              },
                              label: 'Task Time',
                              prefix: Icons.watch_later_outlined,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),

                            defaltFormField(
                              controller: dateController,
                              type: TextInputType.datetime,

                              onTap: (){
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2022-12-10'),
                                ).then((value){
                                  print(DateFormat.yMMMd().format(value!));
                                  dateController.text=DateFormat.yMMMd().format(value);
                                });
                              },
                              validate: (value){
                                if(value!.isEmpty){
                                  return 'date must not be embty';
                                }

                              },
                              label: 'Task Date',
                              prefix: Icons.calendar_today,
                            ),


                          ],
                        ),
                      ),
                    ),

                  ).closed.then((value)
                  {
                    AppCubit.get(context).changeBottomSheetState(
                        isShow: false,
                        icon:Icons.edit,
                    );

                  });

                  AppCubit.get(context).changeBottomSheetState(
                      isShow: true,
                      icon:Icons.add,

                  );

                }

              },
              child: Icon(
                AppCubit.get(context). fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(


              type: BottomNavigationBarType.fixed,

              currentIndex: AppCubit.get(context).currentindex,
              onTap: (index){


                 AppCubit.get(context).changeIndex(index);



              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },

      ),
    );
  }
  Future<String>getname() async
  {
    return 'mahmoud Ahmed';
  }

}
