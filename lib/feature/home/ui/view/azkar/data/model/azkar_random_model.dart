import 'package:equatable/equatable.dart';

class AzkarRandomModel  extends Equatable {
  final String dikr;

  const AzkarRandomModel({required this.dikr});

  factory AzkarRandomModel.fromJson(Map<String, dynamic> json) {
    return AzkarRandomModel(dikr: json['dikr'] ?? '');
  }
  @override
  List<Object?> get props => [dikr];
}
