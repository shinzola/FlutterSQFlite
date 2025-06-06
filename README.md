# Sistema de Vínculos Acadêmicos (Flutter + SQFlite)
Um aplicativo simples desenvolvido em Flutter que demonstra a implementação completa de operações CRUD (Criar, Ler, Atualizar, Deletar) utilizando um banco de dados local com o pacote sqflite. O projeto gerencia três entidades interligadas: Estudantes, Disciplinas e os Vínculos (Cursa) entre eles, representando uma relação N:N.

📋 Funcionalidades Principais
O aplicativo é dividido em três seções principais, cada uma com sua própria tela e funcionalidades CRUD:

## Gestão de Estudantes:

Cadastrar novos estudantes.
Visualizar a lista de todos os estudantes cadastrados.
Editar as informações de um estudante existente.
Excluir um estudante do banco de dados.
Gestão de Disciplinas:

Cadastrar novas disciplinas.
Visualizar a lista de todas as disciplinas.
Editar as informações de uma disciplina existente.
Excluir uma disciplina.
Gestão de Vínculos (Cursa):

Criar um novo vínculo (matricular) um aluno já existente em uma disciplina já existente.
Visualizar a lista de todos os vínculos (ex: "Aluno X cursa Disciplina Y").
Editar um vínculo, trocando o aluno ou a disciplina.
Excluir um vínculo (desmatricular o aluno da disciplina).

## 🛠️ Tecnologias Utilizadas
Flutter: Framework para desenvolvimento de interfaces de usuário multiplataforma.
Dart: Linguagem de programação utilizada pelo Flutter.
sqflite: Plugin para acesso a bancos de dados SQLite.
