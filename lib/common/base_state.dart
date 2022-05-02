part of 'base_cubit.dart';

abstract class BaseState extends Equatable {
  const BaseState();

  @override
  List<Object> get props => [];
}

class BaseInitial extends BaseState {}

class BaseLoading extends BaseState {}

class BaseEmpty extends BaseState {}

class BaseListSuccess<T> extends BaseState {
  final List<T> list;
  const BaseListSuccess({
    required this.list,
  });

  @override
  List<Object> get props => [list];
}

class BaseEditSuccess extends BaseState {
  final String? id;
  BaseEditSuccess({
    required this.id,
  });
}

class BaseFailure extends BaseState {
  final String errorMsg;
  final int errorCode;
  const BaseFailure({
    required this.errorMsg,
    required this.errorCode,
  });

  @override
  List<Object> get props => [errorCode, errorMsg];
}
