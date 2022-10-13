import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/moduls/counter/cubit/cubit.dart';
import 'package:todoapp/moduls/counter/cubit/states.dart';

class CounterScreen extends StatelessWidget {
  int count=0;

  @override
  Widget build(BuildContext context) 
  {

    return BlocProvider(
      create: (BuildContext context)=>ConterCubit(),
      child: BlocConsumer<ConterCubit, CounterStates>(
        listener: (context, state){},
        builder: (context, state){
          return Scaffold(
            appBar: AppBar(
              title: Text(
                  'counter'
              ),
            ),
            body: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  TextButton(
                    onPressed: ()
                    {
                      ConterCubit.get(context).minus();
                    },
                    child: Text(
                      'Minus',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.red,
                          color: Colors.black
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: Text(
                      '${ConterCubit.get(context).counter}',
                      style: TextStyle(
                        fontSize: 100,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: ()
                    {
                      ConterCubit.get(context).plus();
                    },
                    child: Text(
                      'Plus',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


