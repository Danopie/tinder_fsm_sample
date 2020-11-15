import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:tinder_fsm_sample/core/fsm_builder.dart';
import 'package:tinder_fsm_sample/flight_product_flow/flight_product_flow_fsm.dart';

class PaymentFlowCoordinator extends StatefulHookWidget {
  @override
  _PaymentFlowCoordinatorState createState() => _PaymentFlowCoordinatorState();
}

final routeObserverProvider = ScopedProvider<RouteObserver>(null);

class _PaymentFlowCoordinatorState extends State<PaymentFlowCoordinator> {
  final _observer = RouteObserver();

  @override
  Widget build(BuildContext context) {
    return FSMBuilder(
      fsm: useProvider(flightProductFlowFSM),
      builder: (context, state) {
        return ProviderScope(
          overrides: [
            routeObserverProvider.overrideWithValue(_observer),
          ],
          child: Navigator(
            observers: [_observer],
            pages: [],
            onPopPage: (route, result) {
              context.read(flightProductFlowFSM).transition(OnUserGoBack());

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
