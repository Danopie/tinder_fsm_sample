import 'package:equatable/equatable.dart';
import 'package:fsm/fsm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tinder_fsm_sample/core/fsm_wrapper.dart';
import 'package:tinder_fsm_sample/model/flight.dart';

final selectFlightFSMProvider = Provider.autoDispose<SelectFlightFSM>(
  (ref) {
    return SelectFlightFSM()..transition(OnInit());
  },
);

class SelectFlightFSM extends FSMWrapper<FlightSelectState, FlightSelectEvent,
    FlightSelectSideEffect> {
  @override
  void createStateMachine(
      GraphBuilder<FlightSelectState, FlightSelectEvent, FlightSelectSideEffect>
          g) {
    g
      ..initialState(UninitializedState())
      ..state<UninitializedState>((b) => b
        ..on<OnInit>(
          (UninitializedState s, OnInit e) => b.transitionTo(
            LoadingFlights(),
            LoadFlights(),
          ),
        ))
      ..state<LoadingFlights>(
        (b) => b
          ..on<OnFlightLoadSuccess>(
            (LoadingFlights s, OnFlightLoadSuccess e) => b.transitionTo(
              FlightListing(flights: e.flights),
            ),
          )
          ..on<OnFlightLoadFailed>(
            (LoadingFlights s, OnFlightLoadFailed e) => b.transitionTo(
              LoadingError(message: ""),
            ),
          ),
      )
      ..state<FlightListing>(
        (b) => b
          ..on<OnUserSelectFlight>(
            (FlightListing s, OnUserSelectFlight e) => b.transitionTo(
              FlightSelectCompleted(s.flights, e.flight),
            ),
          ),
      )
      ..state<FlightSelectCompleted>((b) {})
      ..state<LoadingError>((b) => b
        ..onEnter((s) => print('Entering ${s.runtimeType} state'))
        ..onExit((s) => print('Exiting ${s.runtimeType} state')))
      ..onTransition(
        (t) {
          t.match((v) => _handleSideEffects(v.sideEffect), (_) {});
        },
      );
  }

  Future<void> _handleSideEffects(
    FlightSelectSideEffect v,
  ) async {
    if (v is LoadFlights) {
      final flights = List<Flight>.generate(
          10, (index) => Flight("ID $index", "Flight No.$index"));
      await Future.delayed(Duration(seconds: 1));
      machine.transition(OnFlightLoadSuccess(flights));
    }
  }
}

abstract class FlightSelectState extends Equatable {}

class UninitializedState extends FlightSelectState {
  @override
  List<Object> get props => [];
}

class LoadingFlights extends FlightSelectState {
  @override
  List<Object> get props => [];
}

class FlightListing extends FlightSelectState {
  final List<Flight> flights;

  FlightListing({this.flights});

  @override
  List<Object> get props => [flights];
}

class LoadingError extends FlightSelectState {
  final String message;

  LoadingError({this.message});

  @override
  List<Object> get props => [message];
}

class FlightSelectCompleted extends FlightSelectState {
  final List<Flight> flights;
  final Flight selectedFlight;

  FlightSelectCompleted(this.flights, this.selectedFlight);

  @override
  List<Object> get props => [flights];
}

abstract class FlightSelectEvent extends Equatable {}

class OnInit extends FlightSelectEvent {
  @override
  List<Object> get props => [];
}

class OnUserSelectFlight extends FlightSelectEvent {
  final Flight flight;

  OnUserSelectFlight(this.flight);

  @override
  List<Object> get props => [flight];
}

class OnFlightLoadSuccess extends FlightSelectEvent {
  final List<Flight> flights;

  OnFlightLoadSuccess(this.flights);

  @override
  List<Object> get props => [flights];
}

class OnFlightLoadFailed extends FlightSelectEvent {
  @override
  List<Object> get props => [];
}

class FlightSelectSideEffect {}

class LoadFlights extends FlightSelectSideEffect {}
