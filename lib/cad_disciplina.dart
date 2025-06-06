import 'package:dbestudante/disciplina.dart';
import 'package:dbestudante/disciplina_dao.dart';
import 'package:flutter/material.dart';

class cad_disciplina extends StatefulWidget {
  const cad_disciplina({super.key});

  @override
  State<cad_disciplina> createState() => _DisciplinaState();
}

class _DisciplinaState extends State<cad_disciplina> {
  final _disciplinaDAO = DisciplinaDao();
  Disciplina? _disciplinaAtual;

  final _controllerNome = TextEditingController();
  final _controllerProfessor = TextEditingController();
  List<Disciplina> _listaDisciplinas = [];
  @override
  void initState() {
    _loadDisciplinas();
    super.initState();
  }

  _loadDisciplinas() async {
    List<Disciplina> temp = await _disciplinaDAO.listarDisciplina();
    setState(() {
      _listaDisciplinas = temp;
    });
  }

  _salvarOUEditar() async {
    print(_disciplinaAtual);
    if (_disciplinaAtual == null &&
        _controllerNome.text != "" &&
        _controllerProfessor.text != "") {
      //novo estudante
      await _disciplinaDAO.incluirDisciplina(Disciplina(
          nome: _controllerNome.text, professor: _controllerProfessor.text));
    } else if (_disciplinaAtual != null) {
      //atualizar estudante
      _disciplinaAtual!.nome = _controllerNome.text;
      _disciplinaAtual!.professor = _controllerProfessor.text;
      await _disciplinaDAO.editarDisciplina(_disciplinaAtual!);
    }
    _controllerNome.clear();
    _controllerProfessor.clear();
    setState(() {
      _loadDisciplinas();
      _disciplinaAtual = null;
    });
  }

  _apagarDisciplina(int index) async {
    await _disciplinaDAO.deleteDisciplina(index);
    _loadDisciplinas();
  }

  _editarDisciplina(Disciplina d) async {
    await _disciplinaDAO.editarDisciplina(d);
    _loadDisciplinas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cadastrar Disciplina"),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 18.0),
          backgroundColor: Colors.deepPurple,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _controllerNome,
                decoration: InputDecoration(
                  labelText: "Nome da Disciplina",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _controllerProfessor,
                decoration: InputDecoration(
                  labelText: "Professor responsável",
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
                child: _disciplinaAtual == null
                    ? Text("Salvar")
                    : Text("Atualizar"),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _listaDisciplinas.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                          "Aluno: ${_listaDisciplinas[index].nome ?? 'N/A'}"),
                      subtitle: Text(
                          "Matricula: ${_listaDisciplinas[index].professor ?? 'N/A'}"),
                      // Adicionar mais detalhes ou botões de ação se necessário
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          if (_listaDisciplinas[index].id != null) {
                            _apagarDisciplina(_listaDisciplinas[index].id!);
                          }
                        },
                      ),
                      onTap: () {
                        setState(() {
                          _disciplinaAtual = _listaDisciplinas[index];
                          _controllerNome.text = _disciplinaAtual!.nome;
                          _controllerProfessor.text =
                              _disciplinaAtual!.professor;
                          _editarDisciplina(_disciplinaAtual!);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
