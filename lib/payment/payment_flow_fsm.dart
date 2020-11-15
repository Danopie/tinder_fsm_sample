import 'package:fsm/fsm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tinder_fsm_sample/core/fsm_wrapper.dart';

final paymentFlowFSM = Provider.autoDispose((ref) => PaymentFlowFSM());

class PaymentFlowFSM extends FSMWrapper<PaymentFlowState, PaymentFlowEvent,
    PaymentFlowSideEffect> {
  @override
  void createStateMachine(
      GraphBuilder<PaymentFlowState, PaymentFlowEvent, PaymentFlowSideEffect>
          g) {
    g
      ..initialState(
        UninitializedState(),
      );
  }

  @override
  void handleSideEffect(PaymentFlowSideEffect sideEffect) {}
}

abstract class PaymentFlowState {}

class UninitializedState extends PaymentFlowState {}

abstract class PaymentFlowEvent {}

abstract class PaymentFlowSideEffect {}
