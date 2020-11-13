import 'package:flutter/material.dart';
import 'package:tinder_fsm_sample/core/fsm_wrapper.dart';

class FSMBuilder<STATE> extends StatelessWidget {
  final Function(BuildContext, STATE state) builder;
  final FSMWrapper<STATE, Object, Object> fsm;

  const FSMBuilder({Key key, this.builder, this.fsm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<STATE>(
      stream: fsm.state,
      initialData: fsm.currentState,
      builder: (context, snapshot) => builder(context, snapshot.data),
    );
  }
}
