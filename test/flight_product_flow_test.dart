// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tinder_fsm_sample/flight_product_flow/enter_passenger_count/enter_passenger_count_fsm.dart'
    as passengerCountFSM;
import 'package:tinder_fsm_sample/flight_product_flow/flight_product_flow_fsm.dart';
import 'package:tinder_fsm_sample/flight_product_flow/select_flight/select_flight_fsm.dart'
    as selectFlightFSM;
import 'package:tinder_fsm_sample/model/flight.dart';

void main() {
  selectFlightFSM.SelectFlightFSM selectFlightFsm;
  passengerCountFSM.EnterPassengerCountFSM passengerCountFsm;
  FlightProductFlowFSM sut;

  setUp(() {
    selectFlightFsm = MockSelectFlightFSM();
    passengerCountFsm = MockPassengerCountFSM();
    when(selectFlightFsm.state).thenAnswer((_) => Stream.fromIterable([]));
    when(passengerCountFsm.state).thenAnswer((_) => Stream.fromIterable([]));
    sut = FlightProductFlowFSM(
        selectFlightFSM: selectFlightFsm, passengerCountFSM: passengerCountFsm);
  });

  test('FlightProductFlow_shouldStartWithFlightSelect', () async {
    expect(sut.currentState, isA<FlightSelect>());
  });

  test('FlightProductFlow_shouldShowPassengerCount_whenAFlightIsSelected',
      () async {
    final selectedFlight = Flight("1", "Flight 1");

    sut.transition(OnSelectFlightCompleted(selectedFlight));

    expect(sut.currentState, isA<PassengerCountSelect>());
    expect(sut.currentState.flight, equals(selectedFlight));
  });

  test(
      'FlightProductFlow_shouldShowFlightSelect_whenUserBackFromPassengerCount',
      () async {
    final selectedFlight = Flight("1", "Flight 1");

    sut.transition(OnSelectFlightCompleted(selectedFlight));
    sut.transition(OnUserGoBack());

    expect(sut.currentState, isA<FlightSelect>());
  });

  test('FlightProductFlow_shouldShowPaymentFlow_whenPassengerCountIsSelected',
      () async {
    final selectedFlight = Flight("1", "Flight 1");
    final selectedPassengerCount = 2;

    sut.transition(OnSelectFlightCompleted(selectedFlight));
    sut.transition(OnPassengerCountSelected(selectedPassengerCount));

    expect(sut.currentState, isA<FlightProductFlowCompleted>());
    expect(sut.currentState.flight, equals(selectedFlight));
    expect(sut.currentState.passengerCount, equals(selectedPassengerCount));
  });

  test('FlightProductFlow_shouldShowPassengerCountSelect_whenUserBackPayment',
      () async {
    final selectedFlight = Flight("1", "Flight 1");
    final selectedPassengerCount = 2;

    sut.transition(OnSelectFlightCompleted(selectedFlight));
    sut.transition(OnPassengerCountSelected(selectedPassengerCount));
    sut.transition(OnUserGoBack());

    expect(sut.currentState, isA<PassengerCountSelect>());
  });
}

class MockSelectFlightFSM extends Mock
    implements selectFlightFSM.SelectFlightFSM {}

class MockPassengerCountFSM extends Mock
    implements passengerCountFSM.EnterPassengerCountFSM {}
