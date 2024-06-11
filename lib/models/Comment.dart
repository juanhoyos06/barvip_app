class Comment {
  late String idClient;
  late String idBarber;
  late String comment;
  late String date;

  Comment({
    required this.idClient,
    required this.idBarber,
    required this.comment,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'idClient': idClient,
      'idBarber': idBarber,
      'comment': comment,
      'date': date
    };
  }

  Comment.empty() {
    idClient = '';
    idBarber = '';
    comment = '';
    date = '';
  }

  fromJson(Map<String, dynamic> json) {
    idClient = json['idClient'];
    idBarber = json['idBarber'];
    comment = json['comment'];
    date = json['date'];
  }
}
