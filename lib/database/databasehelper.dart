import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter_sqlite/models/note.dart';

class DatabaseHelper{

  String table_name="note_table";
  String note_id="id";
  String note_name="name";
  String note_email="email";
  String note_desc="desc";

 static DatabaseHelper _databaseHelper;
 static Database _database;
 DatabaseHelper._createInstance();

  factory DatabaseHelper()
  {
    if(_databaseHelper==null)
      _databaseHelper=DatabaseHelper._createInstance();

    return _databaseHelper;
  }

  Future<Database> get database async
  {
      if(_database==null)
        _database=await initialeDatabase();
      return _database;
  }


  Future<Database> initialeDatabase() async{

    Directory directory=await getApplicationDocumentsDirectory();
    String path=directory.path+'notes.db';
    var notesDatabase=openDatabase(path,version: 1,onCreate: _createDB);
    return notesDatabase;
  }

  void _createDB(Database db,int version) async
  {
       await db.execute('CREATE TABLE ${table_name}(${note_id} INTEGER0 PRIMARY KEY  AUTOINCREMENT,${note_name} TEXT,${note_email} TEXT,${note_desc} TEXT)');
  }

  Future<List<Map<String,dynamic>>> getAllNotes() async{
    Database db=await this.database;
    var result=db.rawQuery('SELECT * FROM ${table_name}');
    return result;
  }

  Future<int> insertNote(Note note) async{
    Database db=await this.database;
    var result=db.insert(table_name,note.toMap());
    return result;
  }

 Future<int> updateNote(int id,Note note) async{
    Database db=await this.database;
    var result= db.rawUpdate('UPDATE ${table_name} SET ${note_name}=?,${note_email}=?,${note_desc}=? WHERE ${note_id}=?',[note.name,note.email,note.description,id]);
    return result;
  }

  Future<int> deleteNote(int id) async{
    Database db=await this.database;
    var result=db.delete(table_name,where: '${note_id}=?',whereArgs: [id]);
    return result;
  }

  Future<int> getNoteCount() async{
    Database db=await this.database;
    List<Map<String,dynamic>> result=await db.query('SELECT 8 FROM ${table_name}');
    int res=Sqflite.firstIntValue(result);
    return res;
  }

  Future<List<Note>> getListNote() async{
    List<Note> notes=List<Note>();
    List<Map<String,dynamic>> result=await this.getAllNotes();
    for(Map<String,dynamic> mp in result)
      {
         notes.add(Note.toNote(mp));

      }
    return notes;
  }


}