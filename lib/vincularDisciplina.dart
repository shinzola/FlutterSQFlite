import 'package:dbestudante/cursa.dart';
import 'package:dbestudante/cursa_dao.dart';
import 'package:dbestudante/estudante.dart';
import 'package:dbestudante/estudante_dao.dart';
import 'package:dbestudante/disciplina.dart';
import 'package:dbestudante/disciplina_dao.dart';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class vincularDisciplina extends StatefulWidget {
  const vincularDisciplina({super.key});

  @override
  State<vincularDisciplina> createState() => _vincularDisciplinaState();
}

class _vincularDisciplinaState extends State<vincularDisciplina> {
  Cursa? _vinculoAtual;
  final EstudanteDao _estudanteDao = EstudanteDao();
  final DisciplinaDao _disciplinaDao = DisciplinaDao();
  final CursaDao _cursaDao = CursaDao(); // Para salvar o vínculo

// Listas para popular os dropdowns e guardar seleções
  List<Estudante> _listaTodosAlunos = [];
  Estudante? _alunoSelecionado;
  bool _isLoadingAlunos = true;

  List<Disciplina> _listaTodasDisciplinas = [];
  Disciplina? _disciplinaSelecionada;
  bool _isLoadingDisciplinas = true;

// Lista para exibir os vínculos já existentes (como você já tinha)
  List<Cursa> _listaDeVinculosExistentes = [];
  bool _isLoadingVinculos = true;

  final _controllerAluno = TextEditingController();
  final _controllerDisciplina = TextEditingController();
  List<Cursa> _listCursa = [];
  @override
  void initState() {
    _isLoadingAlunos = true;
    _isLoadingDisciplinas = true;
    _isLoadingVinculos = true;

    _carregarDadosDaTela();
  }

  Future<void> _carregarDadosDaTela() async {
    // Define todos os carregamentos como true inicialmente
    setState(() {
      _isLoadingAlunos = true;
      _isLoadingDisciplinas = true;
      _isLoadingVinculos =
          true; // Se também for carregar os vínculos existentes
    });
    try {
      // Carrega alunos
      _listaTodosAlunos = await _estudanteDao.listarEstudantes();
    } catch (e) {
      print("Erro ao carregar Estudantes: $e");
      // Tratar erro
    } finally {
      if (mounted) setState(() => _isLoadingAlunos = false);
    }

    try {
      // Carrega disciplinas
      _listaTodasDisciplinas = await _disciplinaDao.listarDisciplina();
    } catch (e) {
      print("Erro ao carregar disciplinas: $e");
      // Tratar erro
    } finally {
      if (mounted) setState(() => _isLoadingDisciplinas = false);
    }

    try {
      // Carrega vínculos existentes (opcional, mas útil para exibir)
      _listaDeVinculosExistentes = await _cursaDao.listarCursa();
    } catch (e) {
      print("Erro ao carregar vínculos existentes: $e");
      // Tratar erro
    } finally {
      if (mounted) setState(() => _isLoadingVinculos = false);
    }
  }

  Future<void> _salvarVinculo() async {
    if (_alunoSelecionado == null || _disciplinaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, selecione um aluno e uma disciplina.')),
      );
      return;
    }

    if (_vinculoAtual == null) {
      // Criar novo vínculo
      final novoVinculo = Cursa(
        idEstudante: _alunoSelecionado!.id,
        idDisciplina: _disciplinaSelecionada!.id,
      );

      try {
        await _cursaDao.incluirCursar(novoVinculo);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vínculo criado com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar vínculo: $e')),
        );
      }
    } else {
      // Editar vínculo existente
      final vinculoEditado = Cursa(
        id: _vinculoAtual!.id, // necessário para editar corretamente
        idEstudante: _alunoSelecionado!.id,
        idDisciplina: _disciplinaSelecionada!.id,
      );

      try {
        await _cursaDao.editarCursar(vinculoEditado);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vínculo editado com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao editar vínculo: $e')),
        );
      }
    }
    // Resetar estado após salvar
    setState(() {
      _vinculoAtual = null;
      _alunoSelecionado = null;
      _disciplinaSelecionada = null;
    });
    await _carregarDadosDaTela();
  }

  Future<void> _apagarVinculo(int cursaId) async {
    // Adicionar um diálogo de confirmação é uma boa prática
    await _cursaDao.deleteCursar(cursaId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vínculo apagado com sucesso!')),
    );
    _carregarDadosDaTela(); // Recarrega os dados
  }

  void _carregarVinculoParaEdicao(Cursa vinculo) {
    final alunoParaEdicao = _listaTodosAlunos
        .firstWhereOrNull((aluno) => aluno.id == vinculo.idEstudante);
    final disciplinaParaEdicao = _listaTodasDisciplinas.firstWhereOrNull(
        (disciplina) => disciplina.id == vinculo.idDisciplina);

    setState(() {
      _vinculoAtual = vinculo;
      _alunoSelecionado = alunoParaEdicao;
      _disciplinaSelecionada = disciplinaParaEdicao;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingAlunos || _isLoadingDisciplinas) {
      return Scaffold(
        appBar: AppBar(title: const Text('Vincular Aluno à Disciplina')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar disciplina para aluno"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 18.0),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dropdown para Alunos
            DropdownButtonFormField<Estudante>(
              decoration: const InputDecoration(
                  labelText: 'Selecione o Aluno', border: OutlineInputBorder()),
              value: _alunoSelecionado,
              hint: const Text('Escolha um aluno...'),
              isExpanded: true,
              items: _listaTodosAlunos.map((Estudante estudante) {
                // USA _listaTodosAlunos
                return DropdownMenuItem<Estudante>(
                  value: estudante, // O objeto Aluno inteiro
                  child: Text(estudante.nome), // Exibe o nome do aluno
                );
              }).toList(),
              onChanged: (Estudante? aluno) {
                setState(() {
                  _alunoSelecionado = aluno;
                });
              },
              validator: (value) => value == null ? 'Selecione um aluno' : null,
            ),
            const SizedBox(height: 16),

            // Dropdown para Disciplinas
            DropdownButtonFormField<Disciplina>(
              decoration: const InputDecoration(
                  labelText: 'Selecione a Disciplina',
                  border: OutlineInputBorder()),
              value: _disciplinaSelecionada,
              hint: const Text('Escolha uma disciplina...'),
              isExpanded: true,
              items: _listaTodasDisciplinas.map((Disciplina disciplina) {
                // USA _listaTodasDisciplinas
                return DropdownMenuItem<Disciplina>(
                  value: disciplina, // O objeto Disciplina inteiro
                  child: Text(disciplina.nome), // Exibe o nome da disciplina
                );
              }).toList(),
              onChanged: (Disciplina? disciplina) {
                setState(() {
                  _disciplinaSelecionada = disciplina;
                });
              },
              validator: (value) =>
                  value == null ? 'Selecione uma disciplina' : null,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  _salvarVinculo();
                },
                child: Text(_vinculoAtual == null
                    ? 'Vincular disciplina'
                    : 'Editar vínculo'),
              ),
            ),
            // ListView para exibir vínculos existentes (opcional)
            if (!_isLoadingVinculos && _listaDeVinculosExistentes.isNotEmpty)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Vínculos Existentes:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _listaDeVinculosExistentes.length,
                        itemBuilder: (context, index) {
                          final cursa = _listaDeVinculosExistentes[index];
                          return Card(
                            child: ListTile(
                              title: Text(
                                  "Aluno: ${cursa.nomeEstudante ?? 'N/A'}"),
                              subtitle: Text(
                                  "Disciplina: ${cursa.nomeDisciplina ?? 'N/A'}"),
                              // Adicionar mais detalhes ou botões de ação se necessário
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  if (cursa.id != null) {
                                    _apagarVinculo(cursa.id!);
                                  }
                                },
                              ),
                              onTap: () {
                                final vinculo =
                                    _listaDeVinculosExistentes[index];
                                _carregarVinculoParaEdicao(vinculo);
                                setState(() {
                                  _vinculoAtual =
                                      _listaDeVinculosExistentes[index];
                                  _controllerAluno.text =
                                      _alunoSelecionado!.nome;
                                  _controllerDisciplina.text =
                                      _disciplinaSelecionada!.nome;
                                  (_disciplinaSelecionada!);
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            if (!_isLoadingVinculos && _listaDeVinculosExistentes.isEmpty)
              const Center(child: Text('Nenhum vínculo existente.'))
          ],
        ),
      ),
    );
  }
}
