import 'package:dbestudante/estudante.dart';
import 'package:flutter/material.dart';

class pag1 extends StatefulWidget {
  const pag1({super.key});

  @override
  State<pag1> createState() => _pag1State();
}

class _pag1State extends State<pag1> {
  final _controllerNome = TextEditingController();
  final _controllerMatricula = TextEditingController();
  List<Estudante> _listaEstudantes = [
    Estudante(nome: "Fulano", matricula: "123456"),
    Estudante(nome: "Ciclano", matricula: "789123"),
    Estudante(nome: "Jorge", matricula: "7654321")
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRUD Estudante"),
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controllerNome,
              decoration: InputDecoration(
                labelText: "Nome",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controllerMatricula,
              decoration: InputDecoration(
                labelText: "Matricula",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(onPressed: () {}, child: Text("Salvar")),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _listaEstudantes.length,
              itemBuilder: (context, index) {
                //colocar a logica para criar cada item a partir da lista Estudantes
                return ListTile(
                  title: Text(_listaEstudantes[index].nome),
                  subtitle: Text(_listaEstudantes[index].matricula),
                  trailing:
                      IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
