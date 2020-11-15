import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useReturnListener(
    BuildContext context, RouteObserver observer, Function onDidPopNext) {
  final route = ModalRoute.of(context);
  useEffect(() {
    final routeAwareHandler = RouteAwareHandler(onDidPopNext: () {
      onDidPopNext?.call();
    });
    observer.subscribe(routeAwareHandler, route);
    return () {
      observer.unsubscribe(routeAwareHandler);
    };
  }, [observer]);
}

class RouteAwareHandler implements RouteAware {
  final Function onDidPop;
  final Function onDidPopNext;
  final Function onDidPush;
  final Function onDidPushNext;

  RouteAwareHandler(
      {this.onDidPop, this.onDidPopNext, this.onDidPush, this.onDidPushNext});

  @override
  void didPop() {
    onDidPop?.call();
  }

  @override
  void didPopNext() {
    onDidPopNext?.call();
  }

  @override
  void didPush() {
    onDidPush?.call();
  }

  @override
  void didPushNext() {
    onDidPushNext?.call();
  }
}
