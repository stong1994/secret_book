import 'package:flutter/material.dart';
import 'package:secret_book/model/info.dart';

class AppState {
  final Info info;

  AppState({
    required this.info,
  });
}

/// The [AppStateNotifier] holds the state of the app and notifies
/// the listeners when the state changes.
class AppStateNotifier extends ValueNotifier<AppState> {
  AppStateNotifier({required AppState state}) : super(state);

  get info => value.info;

  void refresh() {
    notifyListeners();
  }

  void updatePushEventSwitch(bool isPush) {
    value.info.autoPushEvent = isPush;
    notifyListeners();
  }

  // void addAccount(Future<Account?> account) {}
}

/// The [AppBloc] is an [InheritedWidget] that holds the [Info] instances.
// ignore: must_be_immutable
class AppBloc extends InheritedWidget {
  AppStateNotifier appState;

  AppBloc({
    super.key,
    required this.appState,
    required Widget child,
  }) : super(child: child);

  static AppBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppBloc>()!;
  }

  @override
  bool updateShouldNotify(covariant AppBloc oldWidget) => true;
}
