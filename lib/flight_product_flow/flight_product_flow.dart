import 'package:flutter/material.dart';
import 'package:fsm/fsm.dart';
import 'package:tinder_fsm_sample/model/flight.dart';

class FlightProductFlowCoordinator extends StatefulWidget {
  @override
  _FlightProductFlowCoordinatorState createState() => _FlightProductFlowCoordinatorState();
}

class _FlightProductFlowCoordinatorState extends State<FlightProductFlowCoordinator> {

  @override
  void initState() {
    final machine = StateMachine<FlightProductFlowState, Event, SideEffect>.create((g) => g
      ..initialState(FlightSelect())
      ..state<FlightSelect>((b) => b
        ..on<OnSelectFlightCompleted>(
                (FlightSelect s, OnSelectFlightCompleted e) => b.transitionTo(SelectPassengerCount(), LogMelted())))
      ..state<SelectPassengerCount>((b) => b
        ..onEnter((s) => print('Entering ${s.runtimeType} state'))
        ..onExit((s) => print('Exiting ${s.runtimeType} state'))
        ..on<OnPassengerCountSelected>(
                (SelectPassengerCount s, OnPassengerCountSelected e) => b.transitionTo(FlightSelect(), LogFrozen()))
        ..on<OnContactInputDone>(
                (SelectPassengerCount s, OnContactInputDone e) => b.transitionTo(Completed(), LogVaporized())))
      ..state<Completed>((b) => b
        ..on<OnCompleted>(
                (Completed s, OnCompleted e) => b.transitionTo(SelectPassengerCount(), LogCondensed())))
      ..onTransition((t) => t.match((v) => print(v.sideEffect), (_) {})));

    print(machine.currentState is FlightSelect); // TRUE

    print(machine.currentState is SelectPassengerCount); // TRUE

    machine.transition(OnPassengerCountSelected());
    print(machine.currentState is FlightSelect); // TRUE

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


abstract class FlightProductFlowState {}

class FlightSelect extends FlightProductFlowState {}

class SelectPassengerCount extends FlightProductFlowState {}

class InputContactInfo extends FlightProductFlowState {}

class Completed extends FlightProductFlowState {}

abstract class Event {}

class OnSelectFlightCompleted extends Event {
  final Flight flight;
  
  OnSelectFlightCompleted(this.flight);
}

class OnPassengerCountSelected extends Event {}

class OnContactInputDone extends Event {}

class OnCompleted extends Event {}

abstract class SideEffect {}

class LogMelted extends SideEffect {}

class LogFrozen extends SideEffect {}

class LogVaporized extends SideEffect {}

class LogCondensed extends SideEffect {}
