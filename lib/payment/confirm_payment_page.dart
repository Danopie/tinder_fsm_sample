import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:tinder_fsm_sample/core/fsm_builder.dart';
import 'package:tinder_fsm_sample/core/hooks.dart';
import 'package:tinder_fsm_sample/flight_product_flow/flight_product_flow.dart';
import 'package:tinder_fsm_sample/payment/payment_flow_fsm.dart';

class ConfirmPaymentPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useReturnListener(context, useProvider(routeObserverProvider), () {
      context.read(paymentFlowFSM).transition(OnUserGoBack());
    });

    return Scaffold(
      body: FSMBuilder<PaymentFlowState>(
        fsm: useProvider(paymentFlowFSM),
        builder: (context, state) {
          if (state is LoadingPaymentData) {
            return _buildLoading("Loading payment data...");
          } else if (state is VerifyingPaymentData) {
            return _buildLoading("Verifying payment data...");
          } else if (state is PendingForConfirm) {
            return Container(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Flight: ${state.data.flight.routeName}"),
                        Text("Passenger Count: ${state.data.passengerCount}"),
                      ],
                    ),
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            context
                                .read(paymentFlowFSM)
                                .transition(OnUserConfirmPayment());
                          },
                          child: Text("Confirm"))),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildLoading(String s) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(s),
          Container(
            height: 12,
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
