import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
const request = "https://api.hgbrasil.com/finance?format=json&key=6b73526f";

void main() async {

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.yellow,
    ),
  ));
}

Future<Map> getData() async{
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged(String text){
  double real = double.parse(text);
  dolarController.text = (real/dolar).toStringAsPrecision(2);
  euroController.text = (real/euro).toStringAsPrecision(2);
  }
  void _dolarChanged(String text){
    double dolar = double.parse(text);
    realController.text = (dolar*this.dolar).toStringAsPrecision(2);
    euroController.text = (dolar/euro).toStringAsPrecision(2);
  }
  void _euroChanged(String text){
    double euro = double.parse(text);
    realController.text = (euro*this.euro).toStringAsPrecision(2);
    dolarController.text = ((euro*this.euro)/dolar).toStringAsPrecision(2);
  }

  @override
  double dolar;
  double euro;

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Conversor de Moedas",
            style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.yellow,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text("Carregando Dados...",
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                        textAlign: TextAlign.center,)
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text("Erro ao carregar Dados",
                          style: TextStyle(color: Colors.amber, fontSize: 25.0),
                          textAlign: TextAlign.center,)
                    );
                  }
                  else {
                    dolar =
                    snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on, size: 130.0,
                              color: Colors.amber),
                          buildTextField("Reais",  "R\$ ", realController, _realChanged),
                          Divider(),
                          buildTextField("Dólar",  "US\$ ", dolarController, _dolarChanged),
                          Divider(),
                         buildTextField("Euros",  "€ ", euroController, _euroChanged),
                        ],
                      ),
                    );
                  }
              }
            })
    );
  }
  Widget buildTextField(String label, String prefix, TextEditingController controlador, Function f){
    return(
    TextField(
      controller: controlador,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.amber),
          border: OutlineInputBorder(),
          prefixText: prefix,
        ),
        style: TextStyle(color: Colors.amber, fontSize: 21.5),
      onChanged: f,
      keyboardType: TextInputType.number,
    )
    );
  }
}


