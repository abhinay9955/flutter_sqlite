import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_sqlite/database/databasehelper.dart';
import 'package:flutter_sqlite/models/note.dart';
import 'package:sqflite/sqlite_api.dart';

class InsertNote extends StatefulWidget {
 Function updateListView;
 InsertNote(this.updateListView);
  @override
  _InsertNoteState createState() => _InsertNoteState();
}

class _InsertNoteState extends State<InsertNote> {
  DatabaseHelper databaseHelper=DatabaseHelper();
  final _formKey=GlobalKey<FormState>();
  String _name,_email,_desc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text("Insert Note",style: TextStyle(fontSize: 20.0,color: Colors.white),),),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FlutterLogo(colors: Colors.green,size: 100.0,),
            ),
            SizedBox(height: 40.0,),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(prefixIcon: Icon(Icons.person),border: OutlineInputBorder(),hintText: "Name"),
                      onSaved: (value){
                        _name=value;
                      },
                      validator: (value){
                        if(value.length<=0)
                          return 'Name cannot be empty';

                      },
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(prefixIcon: Icon(Icons.email),border: OutlineInputBorder(),hintText: "Email"),
                      onSaved: (value){
                        _email=value;
                      },
                      validator: (value){
                        if(value.length<=0)
                          return 'Email cannot be empty';
                        else if(EmailValidator.validate(value)==false)
                          return 'Not a valid email';

                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(prefixIcon: Icon(Icons.note),border: OutlineInputBorder(),hintText: "Description"),
                      maxLength: 225,
                      onSaved: (value){
                        _desc=value;
                      },
                      validator: (value){
                        if(value.length>255)
                          return 'Maximum 255 characters allowed';

                      },
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  RaisedButton(
                    child: Text("Submit",style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold,color: Colors.white),),
                    color: Colors.indigo,
                    onPressed: (){
                      if(_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        Note note=Note(_name,_email,_desc.length>0 || _desc==null?_desc:"No Description Available");
                        insertnote(context,note);
                      }
                    },
                    splashColor: Colors.blue,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void insertnote(BuildContext context,Note note)
  {
    Future<Database> dbfuture=databaseHelper.initialeDatabase();
    dbfuture.then((database){
      databaseHelper.insertNote(note).then((res){
        if(res!=0) { // Scaffold.of(context).showSnackBar(SnackBar(content:Text("Note Deleted Successfully")));
          print("Note inserted Successfuly");
          widget.updateListView();
          Navigator.pop(context);
        }
        else
          //Scaffold.of(context).showSnackBar(SnackBar(content:Text("Unable to delete Note")));
        print("Unable to insert note");
      });
    });
  }
}
