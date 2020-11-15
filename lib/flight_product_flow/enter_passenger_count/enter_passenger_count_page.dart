import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tinder_fsm_sample/core/fsm_builder.dart';
import 'package:tinder_fsm_sample/core/hooks.dart';
import 'package:tinder_fsm_sample/flight_product_flow/enter_passenger_count/enter_passenger_count_fsm.dart';
import 'package:tinder_fsm_sample/flight_product_flow/flight_product_flow.dart';

class PassengerCountPage extends HookWidget {
  PassengerCountPage();

  @override
  Widget build(BuildContext context) {
    useReturnListener(context, useProvider(routeObserverProvider), () {
      context.read(enterPassengerCountFSMProvider).transition(OnUserGoBack());
    });

    return Scaffold(
      body: FSMBuilder<PassengerCountState>(
        fsm: useProvider(enterPassengerCountFSMProvider),
        builder: (_, state) {
          if (state is PassengerCountIdle) {
            return _buildPassengerCountPicker(
                context, state.minPassengerCount, state.maxPassengerCount);
          } else if (state is PassengerCountCompeted) {
            return _buildPassengerCountPicker(
                context, state.minPassengerCount, state.maxPassengerCount);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildPassengerCountPicker(BuildContext context, int min, int max) {
    return HookBuilder(builder: (context) {
      final countTextController = useTextEditingController();
      return Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("$min"),
                Container(
                  width: 100,
                  child: TextField(
                    controller: countTextController,
                  ),
                ),
                Text("$max"),
              ],
            ),
          ),
          RaisedButton(
            onPressed: () {
              context.read(enterPassengerCountFSMProvider).transition(
                  OnUserSelectPassengerCount(
                      int.tryParse(countTextController.text)));
            },
            child: Text("Confirm"),
          ),
        ],
      );
    });
  }
}
