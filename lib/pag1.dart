import 'package:dbestudante/estudante.dart';
import 'package:dbestudante/estudante_dao.dart';
import 'package:dbestudante/vincularDisciplina.dart';
import 'package:flutter/material.dart';
import 'package:dbestudante/cad_disciplina.dart';

class pag1 extends StatefulWidget {
  const pag1({super.key});

  @override
  State<pag1> createState() => _pag1State();
}

class _pag1State extends State<pag1> {
  final _estudanteDAO = EstudanteDao();
  Estudante? _estudanteAtual;

  final _controllerNome = TextEditingController();
  final _controllerMatricula = TextEditingController();
  List<Estudante> _listaEstudantes = [];

  @override
  void initState() {
    _loadEstudantes();
    super.initState();
  }

  _loadEstudantes() async {
    List<Estudante> temp = await _estudanteDAO.listarEstudantes();
    setState(() {
      _listaEstudantes = temp;
    });
  }

  _salvarOUEditar() async {
    if (_estudanteAtual == null) {
      //novo estudante
      await _estudanteDAO.incluirEstudante(Estudante(
          nome: _controllerNome.text, matricula: _controllerMatricula.text));
    } else {
      //atualizar estudante
      _estudanteAtual!.nome = _controllerNome.text;
      _estudanteAtual!.matricula = _controllerMatricula.text;
      await _estudanteDAO.editarEstudante(_estudanteAtual!);
    }
    _controllerNome.clear();
    _controllerMatricula.clear();
    setState(() {
      _loadEstudantes();
      _estudanteAtual = null;
    });
  }

  _apagarEstudante(int index) async {
    await _estudanteDAO.deleteEstudante(index);
    _loadEstudantes();
  }

  _editarEstudante(Estudante e) async {
    await _estudanteDAO.editarEstudante(e);
    _loadEstudantes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRUD Estudante"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 18.0),
        backgroundColor: Colors.deepPurple,
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
            child: ElevatedButton(
              onPressed: () {
                _salvarOUEditar();
              },
              child:
                  _estudanteAtual == null ? Text("Salvar") : Text("Atualizar"),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _listaEstudantes.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title:
                        Text("Aluno: ${_listaEstudantes[index].nome ?? 'N/A'}"),
                    subtitle: Text(
                        "Matricula: ${_listaEstudantes[index].matricula ?? 'N/A'}"),
                    // Adicionar mais detalhes ou botões de ação se necessário
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {
                        if (_listaEstudantes[index].id != null) {
                          _apagarEstudante(_listaEstudantes[index].id!);
                        }
                      },
                    ),
                    onTap: () {
                      setState(() {
                        _estudanteAtual = _listaEstudantes[index];
                        _controllerNome.text = _estudanteAtual!.nome;
                        _controllerMatricula.text = _estudanteAtual!.matricula;
                        _editarEstudante(_estudanteAtual!);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 60), // empurra pra cima
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => cad_disciplina()));
                  },
                  child: Text("Cadastrar disciplina"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => vincularDisciplina()));
                  },
                  child: Text("Adicionar disciplina"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
