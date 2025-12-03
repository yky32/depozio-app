import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:depozio/core/network/logger.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial()) {
    LoggerUtil.i('HomeBloc initialized');
    on<LoadHome>(_handleLoadHome);
    on<RefreshHome>(_handleRefreshHome);
  }

  Future<void> _handleLoadHome(LoadHome event, Emitter<HomeState> emit) async {
    LoggerUtil.d('📥 LoadHome event received');
    emit(const HomeLoading());

    try {
      // Simulate data loading
      await Future.delayed(const Duration(milliseconds: 800));

      LoggerUtil.d('📖 Loading home data...');
      // In the future, load actual data here

      emit(HomeLoaded(refreshTimestamp: DateTime.now()));
      LoggerUtil.d('📤 State emitted: HomeLoaded');
    } catch (e, stackTrace) {
      LoggerUtil.e(
        '❌ Error loading home data',
        error: e,
        stackTrace: stackTrace,
      );
      emit(HomeError(error: e.toString()));
    }
  }

  Future<void> _handleRefreshHome(
    RefreshHome event,
    Emitter<HomeState> emit,
  ) async {
    LoggerUtil.d(
      '🔄 RefreshHome event received, current state: ${state.runtimeType}',
    );

    if (state is HomeLoaded) {
      // Emit refreshing state to show skeleton
      emit(const HomeRefreshing());

      try {
        // Small delay to show skeleton effect
        await Future.delayed(const Duration(milliseconds: 300));

        LoggerUtil.d('📖 Refreshing home data...');
        // In the future, refresh actual data here

        emit(HomeLoaded(refreshTimestamp: DateTime.now()));
        LoggerUtil.d('📤 State emitted: HomeLoaded (refreshed)');
      } catch (e, stackTrace) {
        LoggerUtil.e(
          '❌ Error refreshing home data',
          error: e,
          stackTrace: stackTrace,
        );
        emit(HomeError(error: e.toString()));
      }
    } else if (state is HomeRefreshing) {
      // Already refreshing, just update the data
      try {
        LoggerUtil.d('📖 Refreshing home data...');
        // In the future, refresh actual data here

        emit(HomeLoaded(refreshTimestamp: DateTime.now()));
        LoggerUtil.d('📤 State emitted: HomeLoaded (refreshed)');
      } catch (e, stackTrace) {
        LoggerUtil.e(
          '❌ Error refreshing home data',
          error: e,
          stackTrace: stackTrace,
        );
        emit(HomeError(error: e.toString()));
      }
    } else {
      // If not loaded, trigger load
      LoggerUtil.d('⚠️ Not loaded yet, triggering LoadHome');
      add(const LoadHome());
    }
  }
}
