class AzkarRandomModel {
  final String dikr;

  AzkarRandomModel({required this.dikr});

  factory AzkarRandomModel.fromJson(Map<String, dynamic> json) {
    return AzkarRandomModel(dikr: json['dikr'] ?? '');
  }
}
