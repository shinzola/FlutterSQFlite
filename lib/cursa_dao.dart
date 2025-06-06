import 'package:dbestudante/DatabaseHelper.dart';
import 'package:dbestudante/cursa.dart';
import 'package:sqflite/sqflite.dart';

class CursaDao {
  final Databasehelper _dbHelper = Databasehelper();

  //Incluir no banco
  Future<void> incluirCursar(Cursa c) async {
    final db = await _dbHelper.database;
    await db.insert(
      "cursa",
      c.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Editar no banco
  Future<void> editarCursar(Cursa c) async {
    final db = await _dbHelper.database;
    await db.update(
      "cursa",
      c.toMap(),
      where: "id = ?",
      whereArgs: [c.id],
    );
  }

  //excluir
  Future<void> deleteCursar(int index) async {
    final db = await _dbHelper.database;
    await db.delete(
      "cursa",
      where: "id = ?",
      whereArgs: [index],
    );
  }

  Future<List<Cursa>> listarCursa() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
       SELECT 
        cursa.id AS id,                
        cursa.idEstudante AS idEstudante,
        cursa.idDisciplina AS idDisciplina,
        estudante.nome AS nomeEstudante,
        disciplina.nome AS nomeDisciplina,
        disciplina.professor
      FROM cursa
      INNER JOIN estudante ON cursa.idEstudante = estudante.id
      INNER JOIN disciplina ON cursa.idDisciplina = disciplina.id
    ''');
    return List.generate(maps.length, (index) {
      return Cursa.fromMap(maps[index]);
    });
  }
}
