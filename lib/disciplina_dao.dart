import 'package:dbestudante/DatabaseHelper.dart';
import 'package:dbestudante/disciplina.dart';
import 'package:sqflite/sqflite.dart';

class DisciplinaDao {
  final Databasehelper _dbHelper = Databasehelper();

  //Incluir no banco
  Future<void> incluirDisciplina(Disciplina d) async {
    final db = await _dbHelper.database;
    await db.insert(
      "disciplina",
      d.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Editar no banco
  Future<void> editarDisciplina(Disciplina d) async {
    final db = await _dbHelper.database;
    await db.update(
      "disciplina",
      d.toMap(),
      where: "id = ?",
      whereArgs: [d.id],
    );
  }

  //excluir
  Future<void> deleteDisciplina(int index) async {
    final db = await _dbHelper.database;
    await db.delete(
      "disciplina",
      where: "id = ?",
      whereArgs: [index],
    );
  }

  Future<List<Disciplina>> listarDisciplina() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query("disciplina");
    return List.generate(maps.length, (index) {
      return Disciplina.fromMap(maps[index]);
    });
  }
}
