import 'package:fsm/fsm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tinder_fsm_sample/core/fsm_wrapper.dart';
import 'package:tinder_fsm_sample/flight_product_flow/enter_passenger_count/enter_passenger_count_fsm.dart';
import 'package:tinder_fsm_sample/flight_product_flow/select_flight/select_flight_fsm.dart';
import 'package:tinder_fsm_sample/model/flight.dart';

final flightProductFlowFSM = Provider.autoDispose((ref) => FlightProductFlowFSM(
    selectFlightFSM: ref.read(selectFlightFSMProvider),
    passengerCountFSM: ref.read(enterPassengerCountFSMProvider)));

class FlightProductFlowFSM extends FSMWrapper<FlightProductFlowState,
    FlightProductFlowEvent, FlightProductFlowSideEffect> {
  final SelectFlightFSM selectFlightFSM;
  final EnterPassengerCountFSM passengerCountFSM;

  FlightProductFlowFSM({this.selectFlightFSM, this.passengerCountFSM}) {
    selectFlightFSM.state.listen((selectFlightState) {
      if (selectFlightState is FlightSelectCompleted) {
        machine.transition(
            OnSelectFlightCompleted(selectFlightState.selectedFlight));
      }
    });

    passengerCountFSM.state.listen((passengerCountState) {
      if (passengerCountState is PassengerCountCompeted) {
        machine.transition(OnPassengerCountSelected(
            passengerCountState.selectedPassengerCount));
      }
    });
  }

  @override
  void createStateMachine(
      GraphBuilder<FlightProductFlowState, FlightProductFlowEvent,
              FlightProductFlowSideEffect>
          g) {
    g
      ..initialState(FlightSelect())
      ..state<FlightSelect>(
        (b) => b
          ..on<OnSelectFlightCompleted>(
            (FlightSelect s, OnSelectFlightCompleted e) => b.transitionTo(
              PassengerCountSelect(),
            ),
          ),
      )
      ..state<PassengerCountSelect>(
        (b) => b
          ..on<OnPassengerCountSelected>(
            (PassengerCountSelect s, OnPassengerCountSelected e) =>
                b.transitionTo(
              ContactInfoInput(),
            ),
          )
          ..on<OnUserGoBack>(
            (PassengerCountSelect s, OnUserGoBack e) => b.transitionTo(
              FlightSelect(),
            ),
          ),
      )
      ..state<ContactInfoInput>(
        (b) => b
          ..on<OnContactInputDone>(
            (ContactInfoInput s, OnContactInputDone e) => b.transitionTo(
              FlightProductFlowCompleted(),
            ),
          )
          ..on<OnUserGoBack>(
            (ContactInfoInput s, OnUserGoBack e) => b.transitionTo(
              PassengerCountSelect(),
            ),
          ),
      )
      ..state<FlightProductFlowCompleted>(
        (b) {},
      );
  }

  @override
  void handleSideEffect(FlightProductFlowSideEffect sideEffect) {}
}

abstract class FlightProductFlowState {}

class FlightSelect extends FlightProductFlowState {}

class PassengerCountSelect extends FlightProductFlowState {}

class ContactInfoInput extends FlightProductFlowState {}

class FlightProductFlowCompleted extends FlightProductFlowState {}

abstract class FlightProductFlowEvent {}

class OnSelectFlightCompleted extends FlightProductFlowEvent {
  final Flight flight;

  OnSelectFlightCompleted(this.flight);
}

class OnPassengerCountSelected extends FlightProductFlowEvent {
  final int passengerCount;

  OnPassengerCountSelected(this.passengerCount);
}

class OnContactInputDone extends FlightProductFlowEvent {}

class OnCompleted extends FlightProductFlowEvent {}

class OnUserGoBack extends FlightProductFlowEvent {}

abstract class FlightProductFlowSideEffect {}
