import 'package:fsm/fsm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tinder_fsm_sample/core/fsm_wrapper.dart';
import 'package:tinder_fsm_sample/model/flight_purchase_data.dart';

final paymentFlowFSM = Provider<PaymentFlowFSM>(
  (ref) {
    print('create paymentFlowFSM');
    return PaymentFlowFSM();
  },
);

class PaymentFlowFSM extends FSMWrapper<PaymentFlowState, PaymentFlowEvent,
    PaymentFlowSideEffect> {
  @override
  void createStateMachine(
      GraphBuilder<PaymentFlowState, PaymentFlowEvent, PaymentFlowSideEffect>
          g) {
    g
      ..initialState(
        UninitializedState(),
      )
      ..state<UninitializedState>(
        (b) => b
          ..on<OnInit>(
            (s, e) => b.transitionTo(
              LoadingPaymentData(e.data),
              LoadPaymentData(),
            ),
          ),
      )
      ..state<LoadingPaymentData>(
        (b) => b
          ..on<OnPaymentDataLoaded>(
            (s, e) => b.transitionTo(
              VerifyingPaymentData(s.data),
              VerifyPaymentData(),
            ),
          ),
      )
      ..state<VerifyingPaymentData>(
        (b) => b
          ..on<OnPaymentDataVerified>(
            (s, e) => b.transitionTo(
              PendingForConfirm(s.data),
            ),
          ),
      )
      ..state<PendingForConfirm>(
        (b) => b
          ..on<OnUserConfirmPayment>(
            (s, e) => b.transitionTo(
              ChargingPurchase(),
              ChargePurchase(),
            ),
          ),
      )
      ..state<ChargingPurchase>(
        (b) => b
          ..on<OnPurchaseCharged>(
            (s, e) => b.transitionTo(
              VerifyingReceipt(),
              VerifyReceipt(),
            ),
          ),
      )
      ..state<VerifyingReceipt>(
        (b) => b
          ..on<OnReceiptVerified>(
            (s, e) => b.transitionTo(
              PaymentCompleted(),
            ),
          ),
      )
      ..state<PaymentCompleted>(
        (b) => b,
      );
  }

  @override
  Future<void> handleSideEffect(PaymentFlowSideEffect sideEffect) async {
    if (sideEffect is LoadPaymentData) {
      await Future.delayed(Duration(seconds: 1));
      transition(OnPaymentDataLoaded());
    } else if (sideEffect is VerifyPaymentData) {
      await Future.delayed(Duration(seconds: 1));
      transition(OnPaymentDataVerified());
    } else if (sideEffect is ChargePurchase) {
      await Future.delayed(Duration(seconds: 1));
      transition(OnPurchaseCharged());
    } else if (sideEffect is VerifyReceipt) {
      await Future.delayed(Duration(seconds: 1));
      transition(OnReceiptVerified());
    }
  }
}

abstract class PaymentFlowState {}

class UninitializedState extends PaymentFlowState {}

class LoadingPaymentData extends PaymentFlowState {
  final FlightPurchaseData data;

  LoadingPaymentData(this.data);
}

class VerifyingPaymentData extends PaymentFlowState {
  final FlightPurchaseData data;

  VerifyingPaymentData(this.data);
}

// Show flight info and passenger count

class PendingForConfirm extends PaymentFlowState {
  final FlightPurchaseData data;

  PendingForConfirm(this.data);
}

// Show a processing dialog
class ChargingPurchase extends PaymentFlowState {}

class VerifyingReceipt extends PaymentFlowState {}

// Go to purchase success screen

class PaymentCompleted extends PaymentFlowState {}

abstract class PaymentFlowEvent {}

class OnInit extends PaymentFlowEvent {
  final FlightPurchaseData data;

  OnInit(this.data);
}

class OnPaymentDataLoaded extends PaymentFlowEvent {}

class OnPaymentDataVerified extends PaymentFlowEvent {}

class OnUserConfirmPayment extends PaymentFlowEvent {}

class OnPurchaseCharged extends PaymentFlowEvent {}

class OnReceiptVerified extends PaymentFlowEvent {}

class OnUserGoBack extends PaymentFlowEvent {}

abstract class PaymentFlowSideEffect {}

class LoadPaymentData extends PaymentFlowSideEffect {}

class VerifyPaymentData extends PaymentFlowSideEffect {}

class ChargePurchase extends PaymentFlowSideEffect {}

class VerifyReceipt extends PaymentFlowSideEffect {}
