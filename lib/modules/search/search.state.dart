part of 'search.cubit.dart';

abstract class SearchState {
  //extends Equatable {
  const SearchState();

  @override
  Object get props => {};
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  // ignore: non_constant_identifier_names
  final SearchResult result;
  const SearchSuccess({
    required this.result,
  });

  @override
  SearchResult get props => result;
}

class SearchEmpty extends SearchState {}

class SearchFailure extends SearchState {
  final String errorMsg;
  final int errorCode;
  const SearchFailure({
    required this.errorMsg,
    required this.errorCode,
  });

  @override
  Object get props => "$errorCode|$errorMsg";
}
