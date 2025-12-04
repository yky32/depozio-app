import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:depozio/features/deposit/data/models/category_entity.dart';
import 'package:depozio/core/network/logger.dart';
import 'package:depozio/core/services/app_setting_service.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(_getInitialState()) {
    LoggerUtil.i('TransactionBloc initialized');
    on<UpdateAmount>(_handleUpdateAmount);
    on<SelectCategory>(_handleSelectCategory);
    on<SelectCurrency>(_handleSelectCurrency);
    on<UpdateDescription>(_handleUpdateDescription);
    on<SelectTransactionDate>(_handleSelectTransactionDate);
    on<ResetTransaction>(_handleResetTransaction);
  }

  static TransactionState _getInitialState() {
    AppSettingService.init();
    final defaultCurrency = AppSettingService.getDefaultCurrency();
    return TransactionFormState(currencyCode: defaultCurrency);
  }

  void _handleUpdateAmount(
    UpdateAmount event,
    Emitter<TransactionState> emit,
  ) {
    LoggerUtil.d('💰 UpdateAmount event received: ${event.amount}');
    final currentState = state;
    if (currentState is TransactionFormState) {
      emit(
        currentState.copyWith(
          amount: event.amount,
        ),
      );
    } else {
      AppSettingService.init();
      final defaultCurrency = AppSettingService.getDefaultCurrency();
      emit(
        TransactionFormState(
          amount: event.amount,
          currencyCode: defaultCurrency,
        ),
      );
    }
  }

  void _handleSelectCategory(
    SelectCategory event,
    Emitter<TransactionState> emit,
  ) {
    LoggerUtil.d('📁 SelectCategory event received: ${event.category.name}');
    final currentState = state;
    if (currentState is TransactionFormState) {
      emit(
        currentState.copyWith(
          selectedCategory: event.category,
        ),
      );
    } else {
      AppSettingService.init();
      final defaultCurrency = AppSettingService.getDefaultCurrency();
      emit(
        TransactionFormState(
          selectedCategory: event.category,
          currencyCode: defaultCurrency,
        ),
      );
    }
  }

  void _handleSelectCurrency(
    SelectCurrency event,
    Emitter<TransactionState> emit,
  ) {
    LoggerUtil.d('💱 SelectCurrency event received: ${event.currencyCode}');
    final currentState = state;
    if (currentState is TransactionFormState) {
      emit(
        currentState.copyWith(
          currencyCode: event.currencyCode,
        ),
      );
    } else {
      emit(
        TransactionFormState(
          currencyCode: event.currencyCode,
        ),
      );
    }
  }

  void _handleUpdateDescription(
    UpdateDescription event,
    Emitter<TransactionState> emit,
  ) {
    LoggerUtil.d('📝 UpdateDescription event received: ${event.description}');
    final currentState = state;
    if (currentState is TransactionFormState) {
      emit(
        currentState.copyWith(
          description: event.description,
        ),
      );
    } else {
      AppSettingService.init();
      final defaultCurrency = AppSettingService.getDefaultCurrency();
      emit(
        TransactionFormState(
          description: event.description,
          currencyCode: defaultCurrency,
        ),
      );
    }
  }

  void _handleSelectTransactionDate(
    SelectTransactionDate event,
    Emitter<TransactionState> emit,
  ) {
    LoggerUtil.d('📅 SelectTransactionDate event received: ${event.transactionDt}');
    final currentState = state;
    if (currentState is TransactionFormState) {
      emit(
        currentState.copyWith(
          transactionDt: event.transactionDt,
        ),
      );
    } else {
      AppSettingService.init();
      final defaultCurrency = AppSettingService.getDefaultCurrency();
      emit(
        TransactionFormState(
          transactionDt: event.transactionDt,
          currencyCode: defaultCurrency,
        ),
      );
    }
  }

  void _handleResetTransaction(
    ResetTransaction event,
    Emitter<TransactionState> emit,
  ) {
    LoggerUtil.d('🔄 ResetTransaction event received');
    AppSettingService.init();
    final defaultCurrency = AppSettingService.getDefaultCurrency();
    emit(TransactionFormState(
      currencyCode: defaultCurrency,
      transactionDt: null,
    ));
  }
}

