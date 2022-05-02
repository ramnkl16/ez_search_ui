part of 'rptquery.cubit.dart';

abstract class RptQueryState {
  //extends Equatable {
  const RptQueryState();

  @override
  Object get props => {};
}

class RptQueryInitial extends RptQueryState {}

class RptQueryLoading extends RptQueryState {}

class RptQueryEmpty extends RptQueryState {}

class RptQueryFailure extends RptQueryState {
  final String errorMsg;
  final int errorCode;
  const RptQueryFailure({
    required this.errorMsg,
    required this.errorCode,
  });

  @override
  Object get props => "$errorCode|$errorMsg";
}

class RptQuerySaveSuccess extends RptQueryState {
  // ignore: non_constant_identifier_names
  final String id;
  RptQuerySaveSuccess({
    required this.id,
  });

  @override
  String get props => id;
}
