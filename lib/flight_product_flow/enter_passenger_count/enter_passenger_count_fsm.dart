import 'package:equatable/equatable.dart';
import 'package:fsm/fsm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tinder_fsm_sample/core/fsm_wrapper.dart';

final enterPassengerCountFSMProvider = Provider.autoDispose<EnterPassengerCountFSM>(
  (ref) {
    return EnterPassengerCountFSM()..transition(OnInit());
  },
);

class EnterPassengerCountFSM extends FSMWrapper<PassengerCountState,
    PassengerCountEvent, PassengerCountSideEffect> {
  @override
  void createStateMachine(
      GraphBuilder<PassengerCountState, PassengerCountEvent,
              PassengerCountSideEffect>
          g) {
    g
      ..initialState(UninitializedState())
      ..state<UninitializedState>(
        (b) => b
          ..on<OnInit>(
            (UninitializedState s, OnInit e) => b.transitionTo(
              PassengerCountLoading(),
              LoadPassengerThreshold(),
            ),
          ),
      )
      ..state<PassengerCountLoading>(
        (b) => b
          ..on<OnPassengerCountThresholdLoaded>(
            (PassengerCountLoading s, OnPassengerCountThresholdLoaded e) =>
                b.transitionTo(
              PassengerCountIdle(e.minPassengerCount, e.maxPassengerCount),
            ),
          ),
      )
      ..state<PassengerCountIdle>(
        (b) => b
          ..on<OnUserSelectPassengerCount>(
            (PassengerCountIdle s, OnUserSelectPassengerCount e) {
              return b.transitionTo(
                PassengerCountCompeted(s.minPassengerCount, s.maxPassengerCount,
                    e.selectedPassengerCount),
              );
            },
          ),
      )
      ..state<PassengerCountCompeted>(
        (b) => b
          ..on<OnUserGoBack>(
            (s, e) => b.transitionTo(
              PassengerCountIdle(s.minPassengerCount, s.maxPassengerCount),
            ),
          ),
      );
  }

  @override
  Future<void> handleSideEffect(PassengerCountSideEffect sideEffect) async {
    if (sideEffect is LoadPassengerThreshold) {
      await Future.delayed(Duration(seconds: 1));
      machine.transition(OnPassengerCountThresholdLoaded(1, 4));
    }
  }
}

abstract class PassengerCountState extends Equatable {}

class UninitializedState extends PassengerCountState {
  @override
  List<Object> get props => [];
}

class PassengerCountLoading extends PassengerCountState {
  @override
  List<Object> get props => [];
}

class PassengerCountIdle extends PassengerCountState {
  final int minPassengerCount;
  final int maxPassengerCount;

  PassengerCountIdle(this.minPassengerCount, this.maxPassengerCount);

  @override
  List<Object> get props => [minPassengerCount, maxPassengerCount];
}

class PassengerCountCompeted extends PassengerCountState {
  final int minPassengerCount;
  final int maxPassengerCount;
  final int selectedPassengerCount;

  PassengerCountCompeted(this.minPassengerCount, this.maxPassengerCount,
      this.selectedPassengerCount);

  @override
  List<Object> get props =>
      [minPassengerCount, maxPassengerCount, selectedPassengerCount];
}

abstract class PassengerCountEvent extends Equatable {}

class OnInit extends PassengerCountEvent {
  @override
  List<Object> get props => [];
}

class OnPassengerCountThresholdLoaded extends PassengerCountEvent {
  final int minPassengerCount;
  final int maxPassengerCount;

  OnPassengerCountThresholdLoaded(
      this.minPassengerCount, this.maxPassengerCount);

  @override
  List<Object> get props => [minPassengerCount, maxPassengerCount];
}

class OnUserSelectPassengerCount extends PassengerCountEvent {
  final int selectedPassengerCount;

  OnUserSelectPassengerCount(this.selectedPassengerCount);

  @override
  List<Object> get props => [selectedPassengerCount];
}

class OnUserGoBack extends PassengerCountEvent {
  @override
  List<Object> get props => [];
}

abstract class PassengerCountSideEffect {}

class LoadPassengerThreshold extends PassengerCountSideEffect {}
