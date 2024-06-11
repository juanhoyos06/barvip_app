class Qualify {
  late String idClient;
  late String idBarber;
  late String qualify;
  late String date;

  Qualify({
    required this.idClient,
    required this.idBarber,
    required this.qualify,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {'idClient': idClient, 'idBarber': idBarber, 'qualify': qualify, 'date': date};
  }

  Qualify.empty() {
    idClient = '';
    idBarber = '';
    qualify = '';
    date = '';
  }

  fromJson(Map<String, dynamic> json) {
    idClient = json['idClient'];
    idBarber = json['idBarber'];
    qualify = json['qualify'];

    date = json['date'];
  }
}
