class NoteModel {
  String? text;
  String? date;
  int? id;

  NoteModel.update(this.text, this.date, this.id);

  NoteModel(this.text, this.date);

  NoteModel.map(dynamic obj) {
    text = obj['name'];
    date = obj['date'];
    id = obj['id'];
  }

  NoteModel.fromMap(Map<String, dynamic> map) {
    text = map['name'];
    date = map['date'];
    id = map['id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};

    map['name'] = text;
    map['date'] = date;

    if (id != null) map['id'] = id;

    return map;
  }
}
