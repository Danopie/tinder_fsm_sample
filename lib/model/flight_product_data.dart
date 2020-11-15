import 'package:meta/meta.dart';
import 'package:tinder_fsm_sample/model/flight.dart';

@sealed
class FlightProductData {
  final Flight selectedFlight;
  final int passengerCount;

  FlightProductData({this.selectedFlight, this.passengerCount});
}
