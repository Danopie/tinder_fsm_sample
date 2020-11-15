import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tinder_fsm_sample/core/fsm_wrapper.dart';

class FSMListener<STATE> extends HookWidget {
  final Function(BuildContext, STATE state) listener;
  final FSMWrapper<STATE, Object, Object> fsm;
  final Widget child;

  const FSMListener({Key key, this.listener, this.fsm, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      final sub = fsm.state.listen((state) {
        listener?.call(context, state);
      });

      return () {
        sub.cancel();
      };
    }, [fsm]);
    return child;
  }
}
