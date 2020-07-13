import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _infoText = "Informe seus dados";
  TextEditingController weightController = new TextEditingController();
  TextEditingController heightController = new TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _resetFields() {
    weightController.text = "";
    heightController.text = "";
    setState(() {
      _infoText = "Informe seus dados";
    });
  }

  void _calculate() {

    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text);
      double res = weight / (height * height);
      if (res < 18.6) {
        _infoText = "Abaixo do peso (IMC = ${res.toStringAsPrecision(3)})";
      } else if (res >= 18.6 && res < 24.9) {
        _infoText = "Peso ideal (IMC = ${res.toStringAsPrecision(3)})";
      } else if (res >= 24.9 && res < 29.9) {
        _infoText =
        "levemente acima do peso (IMC = ${res.toStringAsPrecision(3)})";
      } else if (res >= 29.9 && res < 34.9) {
        _infoText = "Obesidade Grau I (IMC = ${res.toStringAsPrecision(3)})";
      } else if (res >= 34.9 && res < 39.9) {
        _infoText = "Obesidade Grau II (IMC = ${res.toStringAsPrecision(3)})";
      } else if (res >= 39.9) {
        _infoText = "Obesidade Grau III (IMC = ${res.toStringAsPrecision(3)})";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text("Calculadora de IMC"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetFields,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body:
      SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.person_outline,
                size: 100.0,
                color: Colors.blue,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Peso (kg)",
                    labelStyle: TextStyle(
                      color: Colors.blue,
                    )),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue, fontSize: 25),
                controller: weightController,
                validator: (value) {
                  if(value.isEmpty){
                  return "Insira seu Peso!";
                  }
                }
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Altura (m)",
                    labelStyle: TextStyle(
                      color: Colors.blue,
                    )),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue, fontSize: 25),
                controller: heightController,
                  validator: (value) {
                    if(value.isEmpty){
                      return "Insira a sua altura!";
                    }
                  }
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child:
                Container(
                  height: 40.0,
                  child: RaisedButton(
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                        _calculate();
                      }
                    },
                    child: Text("Calcular",
                        style: TextStyle(color: Colors.white, fontSize: 25.0)),
                    color: Colors.pink,
                  ),
                ),
              ),
              Text(
                  _infoText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blue, fontSize: 25.0)
              )
            ],
          ),
        )
      ),
    );
  }
}
