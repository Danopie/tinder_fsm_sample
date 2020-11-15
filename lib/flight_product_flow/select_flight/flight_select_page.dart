import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tinder_fsm_sample/core/fsm_builder.dart';
import 'package:tinder_fsm_sample/core/hooks.dart';
import 'package:tinder_fsm_sample/flight_product_flow/flight_product_flow.dart';
import 'package:tinder_fsm_sample/flight_product_flow/select_flight/select_flight_fsm.dart';
import 'package:tinder_fsm_sample/model/flight.dart';

class FlightSelectPage extends HookWidget {
  FlightSelectPage();

  @override
  Widget build(BuildContext context) {
    useReturnListener(context, useProvider(routeObserverProvider), () {
      context.read(selectFlightFSMProvider).transition(OnUserGoBack());
    });
    return Scaffold(
      body: FSMBuilder<FlightSelectState>(
        fsm: useProvider(selectFlightFSMProvider),
        builder: (context, state) {
          if (state is FlightListing) {
            return _buildFlightList(context, state.flights);
          } else if (state is FlightSelectCompleted) {
            return _buildFlightList(context, state.flights);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  ListView _buildFlightList(BuildContext context, List<Flight> flights) {
    return ListView.builder(
      itemCount: flights.length,
      itemBuilder: (context, index) => InkWell(
          onTap: () {
            context.read(selectFlightFSMProvider).transition(
                  OnUserSelectFlight(flights[index]),
                );
          },
          child: ListTile(
            title: Text("${flights[index]}"),
          )),
    );
  }
}
