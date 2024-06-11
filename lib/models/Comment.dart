class Comment {
  late String idBarber;
  late String comment;
  late String date;

  Comment({
    required this.idBarber,
    required this.comment,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {'idBarber': idBarber, 'comment': comment, 'date': date};
  }

  Comment.empty() {
    idBarber = '';
    comment = '';

    date = '';
  }

  fromJson(Map<String, dynamic> json) {
    idBarber = json['idBarber'];
    comment = json['comment'];

    date = json['date'];
  }
}
