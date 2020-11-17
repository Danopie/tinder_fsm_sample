import 'package:fsm/fsm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tinder_fsm_sample/core/fsm_wrapper.dart';
import 'package:tinder_fsm_sample/flight_product_flow/enter_passenger_count/enter_passenger_count_fsm.dart';
import 'package:tinder_fsm_sample/flight_product_flow/select_flight/select_flight_fsm.dart';
import 'package:tinder_fsm_sample/model/flight.dart';
import 'package:tinder_fsm_sample/payment/payment_flow_fsm.dart';

final flightProductFlowFSM = Provider.autoDispose(
  (ref) {
    print('create flightProductFlowFSM');
    return FlightProductFlowFSM(
      selectFlightFSM: ref.watch(selectFlightFSMProvider),
      passengerCountFSM: ref.watch(enterPassengerCountFSMProvider),
      paymentFlowFSM: ref.watch(paymentFlowFSM),
    );
  },
);

class FlightProductFlowFSM extends FSMWrapper<FlightProductFlowState,
    FlightProductFlowEvent, FlightProductFlowSideEffect> {
  final SelectFlightFSM selectFlightFSM;
  final EnterPassengerCountFSM passengerCountFSM;
  final PaymentFlowFSM paymentFlowFSM;

  FlightProductFlowFSM(
      {this.selectFlightFSM, this.passengerCountFSM, this.paymentFlowFSM}) {
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

    paymentFlowFSM.state.listen((paymentFlowState) {
      if (paymentFlowState is PaymentCompleted) {
        machine.transition(OnFlightPaymentCompleted(
            machine.currentState.flight, machine.currentState.passengerCount));
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
              PassengerCountSelect(flight: e.flight),
            ),
          ),
      )
      ..state<PassengerCountSelect>(
        (b) => b
          ..on<OnPassengerCountSelected>(
            (PassengerCountSelect s, OnPassengerCountSelected e) =>
                b.transitionTo(
              FlightPaymentProcess(
                  flight: s.flight, passengerCount: e.passengerCount),
            ),
          )
          ..on<OnUserGoBack>(
            (PassengerCountSelect s, OnUserGoBack e) => b.transitionTo(
              FlightSelect(),
            ),
          ),
      )
      ..state<FlightPaymentProcess>(
        (b) => b
          ..on<OnUserGoBack>(
            (s, e) => b.transitionTo(
              PassengerCountSelect(flight: s.flight),
            ),
          )
          ..on<OnFlightPaymentCompleted>(
            (s, e) => b.transitionTo(
              FlightProductFlowCompleted(
                flight: e.flight,
                passengerCount: s.passengerCount,
              ),
            ),
          ),
      )
      ..state<FlightProductFlowCompleted>(
        (b) => b,
      );
  }

  @override
  void handleSideEffect(FlightProductFlowSideEffect sideEffect) {}
}

abstract class FlightProductFlowState {
  final Flight flight;
  final int passengerCount;

  FlightProductFlowState({this.flight, this.passengerCount});
}

class FlightSelect extends FlightProductFlowState {}

class PassengerCountSelect extends FlightProductFlowState {
  PassengerCountSelect({Flight flight}) : super(flight: flight);
}

class FlightPaymentProcess extends FlightProductFlowState {
  FlightPaymentProcess({Flight flight, int passengerCount})
      : super(flight: flight, passengerCount: passengerCount);
}

class FlightProductFlowCompleted extends FlightProductFlowState {
  FlightProductFlowCompleted({Flight flight, int passengerCount})
      : super(
          flight: flight,
          passengerCount: passengerCount,
        );
}

abstract class FlightProductFlowEvent {}

class OnSelectFlightCompleted extends FlightProductFlowEvent {
  final Flight flight;

  OnSelectFlightCompleted(this.flight);
}

class OnPassengerCountSelected extends FlightProductFlowEvent {
  final int passengerCount;

  OnPassengerCountSelected(this.passengerCount);
}

class OnFlightPaymentCompleted extends FlightProductFlowEvent {
  final Flight flight;
  final int passengerCount;

  OnFlightPaymentCompleted(this.flight, this.passengerCount);
}

class OnUserGoBack extends FlightProductFlowEvent {}

abstract class FlightProductFlowSideEffect {}
