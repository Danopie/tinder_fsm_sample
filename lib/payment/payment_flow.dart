import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:tinder_fsm_sample/core/fsm_builder.dart';
import 'package:tinder_fsm_sample/model/flight_purchase_data.dart';
import 'package:tinder_fsm_sample/payment/confirm_payment_page.dart';
import 'package:tinder_fsm_sample/payment/payment_completed_page.dart';
import 'package:tinder_fsm_sample/payment/payment_flow_fsm.dart';
import 'package:tinder_fsm_sample/payment/processing_page.dart';

class PaymentFlowCoordinator extends StatefulHookWidget {
  final FlightPurchaseData data;

  PaymentFlowCoordinator({this.data});

  @override
  _PaymentFlowCoordinatorState createState() => _PaymentFlowCoordinatorState();
}

final routeObserverProvider = ScopedProvider<RouteObserver>(null);

class _PaymentFlowCoordinatorState extends State<PaymentFlowCoordinator> {
  final _observer = RouteObserver();

  @override
  void didChangeDependencies() {
    context.read(paymentFlowFSM).transition(OnInit(widget.data));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FSMBuilder<PaymentFlowState>(
      fsm: useProvider(paymentFlowFSM),
      builder: (context, state) {
        return ProviderScope(
          overrides: [
            routeObserverProvider.overrideWithValue(_observer),
          ],
          child: Navigator(
            observers: [_observer],
            pages: [
              if (state is LoadingPaymentData ||
                  state is VerifyingPaymentData ||
                  state is PendingForConfirm)
                MaterialPage(child: ConfirmPaymentPage()),
              if (state is ChargingPurchase || state is VerifyingReceipt)
                MaterialPage(
                  fullscreenDialog: true,
                  child: ProcessingPaymentPage(),
                ),
              if (state is PaymentCompleted)
                MaterialPage(
                  child: PaymentCompletedPage(),
                )
            ],
            onPopPage: (route, result) {
              context.read(paymentFlowFSM).transition(OnUserGoBack());

              if (!route.didPop(result)) {
                return false;
              }

              return true;
            },
          ),
        );
      },
    );
  }
}
