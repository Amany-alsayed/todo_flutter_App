import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../cubit/cubit.dart';

Widget defaultButton({
  double width=double.infinity,
  Color background= Colors.blueAccent,
  bool isuppercase=true,
  double radius=0.0,
  required String text,
  required  function,

})=> Container(
  width:width ,
  decoration:BoxDecoration(
    borderRadius: BorderRadius.circular(radius,),
    color:background,

  ) ,
  clipBehavior: Clip.antiAliasWithSaveLayer,
  child: MaterialButton(
    onPressed:function,
    child: Text(
      isuppercase ? text.toUpperCase():text,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  ),
);
Widget defaultTextFormField({
  required TextEditingController controllerType,
  required TextInputType typeOfKeyboard,
  submittedFunction,
  changedFunction,
  bool obscure=false,
  required String text,
  required IconData prefix,
  IconData? suffix,
  required validate,
  onTap,
  suffixPressed,
  bool isclicable=true,

})=>TextFormField(
  controller:controllerType,
  keyboardType: typeOfKeyboard,
  onFieldSubmitted: submittedFunction,
  onChanged: changedFunction,
  obscureText: obscure,
  validator:validate,
  onTap:onTap ,
  enabled: isclicable,
  decoration:InputDecoration(
    labelText: text,
    prefixIcon: Icon(prefix),
    suffixIcon: suffix!=null ? IconButton(
        onPressed:suffixPressed,
        icon: Icon(suffix),
    ): null,

    border: OutlineInputBorder(),
  ) ,
);
Widget buildTaskItem(Map model,context)=> Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        CircleAvatar(

          radius: 40.0,

          child: Text(

              '${model['time']}'

          ),

        ),

        SizedBox(

          width: 20,

        ),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            children: [

              Text(

                '${model['title']}',

                style: TextStyle(

                  fontSize: 18,

                  fontWeight: FontWeight.bold,

                ),

              ),

              Text(

                '${model['date']}',

                style: TextStyle(

                  fontSize: 15,

                  color: Colors.grey,

                ),

              ),
            ],

          ),

        ),

        SizedBox(

          width: 20,

        ),

        IconButton(

            onPressed:(){

              AppCubit.get(context).update(status:'done', id:model['id']);

            },

            icon: Icon(

              Icons.check_circle,

              color: Colors.teal,

            ),

        ),

        IconButton(

          onPressed:(){

            AppCubit.get(context).update(status:'archived', id:model['id']);

          },

          icon: Icon(

            Icons.archive,

            color: Colors.blueGrey,

          ),

        )

      ],

    ),

  ),
  onDismissed: (direction){
    AppCubit.get(context).delete(id:model['id']);
  },
);
Widget taskBuilder({required List <Map>tasks})=>ConditionalBuilder(
  condition: tasks.length > 0,
  builder:(context)=>ListView.separated(
    itemBuilder:(context,index)=>buildTaskItem(tasks[index],context),
    separatorBuilder:(context,index)=>myDivider(),
    itemCount: tasks.length,
  ),
  fallback: (context)=>Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
            Icons.menu,
            size: 80,
            color:Colors.grey
        ),
        Text(
          'No Tasks Yet, Please Add Some Tasks',
          style: TextStyle(
              fontSize: 15,
              color:Colors.grey,
              fontWeight: FontWeight.bold
          ),
        )
      ],
    ),
  ),

);
Widget myDivider()=>Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20.0,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);
