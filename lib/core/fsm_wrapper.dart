import 'package:fsm/fsm.dart';

abstract class FSMWrapper<STATE, EVENT, SIDE_EFFECT> {
  StateMachine<STATE, EVENT, SIDE_EFFECT> machine;

  FSMWrapper() {
    machine = StateMachine<STATE, EVENT, SIDE_EFFECT>.create(
        (g) => createStateMachine(g));
  }

  void createStateMachine(GraphBuilder<STATE, EVENT, SIDE_EFFECT> g);

  Stream<STATE> get state => machine.state;

  STATE get currentState => machine.currentState;

  Transition<STATE, EVENT, SIDE_EFFECT> transition(EVENT event){
    return machine.transition(event);
  }

  void dispose() {}
}
