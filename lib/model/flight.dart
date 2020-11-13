import 'package:equatable/equatable.dart';

class Flight extends Equatable {
  final String id;
  final String routeName;

  Flight(this.id, this.routeName);

  @override
  List<Object> get props => [id, routeName];
}
