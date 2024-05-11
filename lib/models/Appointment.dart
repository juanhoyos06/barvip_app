class Appointment {
  late String address;
  late String date;
  late String hour;
  late Map<String, dynamic> services;
  late double price;
  late String suggestion;
  late String id;
  late String idClient;
  late String idBarber;

  Appointment(
      {required this.address,
      required this.date,
      required this.hour,
      required this.services,
      required this.price,
      required this.suggestion,
      required this.idClient,
      required this.idBarber,
      this.id = ""});

  Appointment.empty() {
    address = "";
    date = "";
    hour = "";
    services = {};
    price = 0.0;
    suggestion = "";
    idClient = "";
    idBarber = "";
    id = "";
  }
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'date': date,
      'hour': hour,
      'service': services,
      'price': price,
      'suggestion': suggestion,
      'idClient': idClient,
      'idBarber': idBarber
    };
  }
}
