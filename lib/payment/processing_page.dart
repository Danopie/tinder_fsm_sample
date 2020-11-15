import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:tinder_fsm_sample/core/fsm_builder.dart';
import 'package:tinder_fsm_sample/payment/payment_flow_fsm.dart';

class ProcessingPaymentPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return FSMBuilder<PaymentFlowState>(
      fsm: useProvider(paymentFlowFSM),
      builder: (context, state) {
        return Material(
          child: Center(
              child: Card(
            child: Container(
              padding: EdgeInsets.all(24),
              child: Text(_getTitle(state)),
            ),
          )),
        );
      },
    );
  }

  String _getTitle(PaymentFlowState state) {
    if (state is ChargingPurchase) {
      return "Charging Purchase";
    } else if (state is VerifyingReceipt) {
      return "Verifying receipt";
    } else {
      return "";
    }
  }
}
