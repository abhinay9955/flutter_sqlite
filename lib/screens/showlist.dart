import 'package:flutter/material.dart';
import 'package:flutter_sqlite/database/databasehelper.dart';
import 'package:flutter_sqlite/models/note.dart';
import 'package:flutter_sqlite/screens/update.dart';
import 'package:sqflite/sqlite_api.dart';

import 'insert.dart';
enum ConfirmAction{CANCEL,OK}
class ShowList extends StatefulWidget {
  @override
  _ShowListState createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {

  DatabaseHelper databaseHelper=DatabaseHelper();
  List<Note> notes;
  int count;
  @override
  Widget build(BuildContext context) {

    if(notes==null)
      notes=List<Note>();

    updateListView();


    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>InsertNote(updateListView)));

      },child: Icon(Icons.add,color: Colors.white,),backgroundColor: Colors.grey,),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Colors.grey,

      body: ListView(

        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Notes',style: TextStyle(fontSize: 30.0,color: Colors.white),textAlign: TextAlign.center,),
          ),

          Container(

            height: MediaQuery.of(context).size.height-111,
            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(70.0))),
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: notes.length!=0? ListView.builder(itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(elevation: 10.0,child: ListTile(
                         title: InkWell(child: Text(this.notes[index].name.toUpperCase()),onTap: (){_ackAlert(context, this.notes[index]);},),
                         subtitle: InkWell(child: Text(this.notes[index].email.toLowerCase()),onTap: (){_ackAlert(context, this.notes[index]);}),
                         leading: Icon(Icons.note),
                         trailing: SizedBox(width: 60.0,height: 60.0
                         ,child:Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: <Widget>[
                             InkWell(child: Icon(Icons.edit,color: Colors.black,),onTap:(){
                               Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateNote(this.notes[index],updateListView)));
                             }),
                             InkWell(child:Icon(Icons.delete,color: Colors.black,),onTap: (){

                               _asyncConfirmDialog(this.notes[index].id,context);
                             },),
                           ],
                         ))
                  ),),
                );
              },
              itemCount: this.notes.length,):Center(child: Text("Sorry No Notes found"),),
            ),

          )
        ],
        
      ),
    );
  }

  void _deleteNote(int id,BuildContext context)
  {
    Future<Database> dbfuture=databaseHelper.initialeDatabase();
    dbfuture.then((database){
      databaseHelper.deleteNote(id).then((res){
        if(res!=0)
          {
            print("Deleted Succcessfully");
            updateListView();
          }
        else
          print("Unable to delete");

      });

    });
  }

  Future<ConfirmAction> _asyncConfirmDialog(int id,BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Note?'),
          content: const Text(
              'This will delete the note'),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('OK'),
              onPressed: () {
                _deleteNote(id,context);
                Navigator.of(context).pop(ConfirmAction.OK);
              },
            )
          ],
        );
      },
    );
  }

  void updateListView()
  {
    Future<Database> dbfuture=databaseHelper.initialeDatabase();
    dbfuture.then((database){
         Future<List<Note>> resfuture=databaseHelper.getListNote();
         resfuture.then((noteList){
           setState(() {
             notes=noteList;
            // count=notes.length;
           });
         });
    });
  }

  Future<void> _ackAlert(BuildContext context,Note note) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 500.0,
          child: AlertDialog(
            title: Text('NOTE'),
            content:
                  Text("Description: \n\n ${note.description}"),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

}
