part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeRefreshing extends HomeState {
  const HomeRefreshing();
}

class HomeLoaded extends HomeState {
  final DateTime refreshTimestamp;

  HomeLoaded({DateTime? refreshTimestamp})
    : refreshTimestamp = refreshTimestamp ?? DateTime.now();

  @override
  List<Object?> get props => [refreshTimestamp];
}

class HomeError extends HomeState {
  final String error;

  const HomeError({required this.error});

  @override
  List<Object?> get props => [error];
}
