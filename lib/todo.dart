class Todo {
  int id;
  String title;
  int complete;

  Todo({this.id, this.title, this.complete = 0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'complete': complete,
    };
  }
}