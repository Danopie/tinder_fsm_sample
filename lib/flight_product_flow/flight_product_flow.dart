import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:tinder_fsm_sample/core/fsm_builder.dart';
import 'package:tinder_fsm_sample/flight_product_flow/enter_passenger_count/enter_passenger_count_page.dart';
import 'package:tinder_fsm_sample/flight_product_flow/flight_product_flow_fsm.dart';
import 'package:tinder_fsm_sample/flight_product_flow/select_flight/flight_select_page.dart';

class FlightProductFlowCoordinator extends StatefulHookWidget {
  @override
  _FlightProductFlowCoordinatorState createState() =>
      _FlightProductFlowCoordinatorState();
}

final routeObserverProvider = ScopedProvider<RouteObserver>(null);

class _FlightProductFlowCoordinatorState
    extends State<FlightProductFlowCoordinator> {
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
            pages: [
              if (state is FlightSelect ||
                  state is PassengerCountSelect ||
                  state is ContactInfoInput)
                MaterialPage(child: FlightSelectPage()),
              if (state is PassengerCountSelect || state is ContactInfoInput)
                MaterialPage(child: PassengerCountPage()),
              if (state is ContactInfoInput)
                MaterialPage(
                  child: Scaffold(
                    body: Center(child: Text("Contact input")),
                  ),
                ),
            ],
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
