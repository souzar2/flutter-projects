import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

    void main(){
    runApp(MaterialApp(
      home: Home(),
    ));
    }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _toDoController = TextEditingController();
  List _toDoList = [];
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPas;

  @override

  void initState(){
    super.initState();
    _readData().then((data){
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _toDoController.text;
      _toDoController.text = "";
      newToDo["ok"] = false;
      _toDoList.add(newToDo);
      _saveData();
    });
  }

  Future<Null> refresh() async{
    await Future.delayed(Duration(seconds: 1));
   setState(() {
     _toDoList.sort((a, b) {
       if (a["ok"] && !b["ok"]) {
         return 1;
       }
       else if (!a["ok"] && b["ok"]) {
         return -1;
       }
       else {
         return 0;
       }
     });

     _saveData();

   });
   return null;
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
          backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17, 1, 7, 1),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.blueGrey, fontSize: 20),
                    controller: _toDoController,
                    decoration: InputDecoration(
                      labelText: "Nova Tarefa",
                      labelStyle: TextStyle(color: Colors.green, fontSize: 18),
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
                RaisedButton(
                  color: Colors.green,
                  //child: Text("+", style: TextStyle(fontSize: 10),),


                  textColor: Colors.white,
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                  child: Icon(Icons.add, size: 26,),
                  /*shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.green),
                  ),*/
                  onPressed: _addToDo,
                ),

              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(onRefresh: refresh,
            child: ListView.builder(
                padding: EdgeInsets.only(top: 10),
                itemCount: _toDoList.length,
                itemBuilder: buildItem),)
          )
        ],
      )
    );
  }

  Widget buildItem(context, index){
  return Dismissible(
    key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
    background: Container(
      color: Colors.red,
      child: Align(
        alignment: Alignment(0.9,0.0),
        child: Icon(Icons.delete, color: Colors.white,),
      )
    ),
    direction: DismissDirection.startToEnd,
    child: CheckboxListTile(
      checkColor: Colors.white,
      activeColor: Colors.green,
      title: Text(_toDoList[index]["title"], style: TextStyle(fontSize: 20, color: Colors.grey),),
      value: _toDoList[index]["ok"],
      secondary: CircleAvatar(
        backgroundColor: Colors.green,
          child: Icon(_toDoList[index]["ok"]?
          Icons.check : Icons.error,color: Colors.white,),

      ),
      onChanged: (c){
        setState(() {
          _toDoList[index]["ok"] = c;
          _saveData();
        });
      },
    ),
    onDismissed: (direction) {
      setState(() {
        _lastRemoved = Map.from(_toDoList[index]);
        _lastRemovedPas = index;
        _toDoList.removeAt(index);
        _saveData();


        final snack = SnackBar(
          content: Text("\"${_lastRemoved["title"]}\" removed"),
          action: SnackBarAction(label: "Desfazer",
          onPressed: (){
            setState(() {
              _toDoList.insert(_lastRemovedPas, _lastRemoved);
              _saveData();
            });
          },
          ),
          duration: Duration(seconds: 2),
        );

        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(snack);
      });

    },
  );
  }

  Future<File> _getFile() async{
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.path");
  }
  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final File = await _getFile();
    return File.writeAsString(data);
  }
  Future<String> _readData() async{
    try{
      final file = await _getFile();
          return file.readAsString();
    }
    catch(e){
      return null;
    }
  }
}


