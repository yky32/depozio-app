part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHome extends HomeEvent {
  const LoadHome();
}

class RefreshHome extends HomeEvent {
  const RefreshHome();
}

class UpdateScrollOffset extends HomeEvent {
  final double scrollOffset;

  const UpdateScrollOffset(this.scrollOffset);

  @override
  List<Object?> get props => [scrollOffset];
}
