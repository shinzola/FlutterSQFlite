class Cursa {
  int? id;
  int? idEstudante;
  int? idDisciplina;
  String? nomeEstudante;
  String? nomeDisciplina;
  String? professor;

  Cursa({
    this.id,
    this.idEstudante,
    this.idDisciplina,
    this.nomeEstudante,
    this.nomeDisciplina,
    this.professor,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "idEstudante": idEstudante,
      "idDisciplina": idDisciplina,
    };
  }

  factory Cursa.fromMap(Map<String, dynamic> map) {
    return Cursa(
      id: map['id'],
      idEstudante: map['idEstudante'],
      idDisciplina: map['idDisciplina'],
      nomeEstudante: map['nomeEstudante'],
      nomeDisciplina: map['nomeDisciplina'],
      professor: map['professor'],
    );
  }
}
