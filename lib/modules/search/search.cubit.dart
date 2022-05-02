import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

import 'package:ez_search_ui/constants/app_messages.dart';
import 'package:ez_search_ui/constants/app_values.dart';
import 'package:ez_search_ui/exceptions/custom_exception.model.dart';
import 'package:ez_search_ui/main.dart';

import 'package:ez_search_ui/modules/search/SearchResult.dart';
import 'package:ez_search_ui/modules/search/search.repo.dart';

part 'search.state.dart';

class NavigationSearchCubit extends SearchCubit {}

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  Future<void> getAllSearchs(String req) async {
    emit(SearchLoading());
    try {
      var repo = SearchRepo();
      print("gtallserchs| $req");
      SearchResult search = await repo.getSearchData(req);
      if (search.resultRow == null) {
        emit(SearchEmpty());
      } else {
        emit(SearchSuccess(result: search));
      }
    } on CustomException catch (e, s) {
      if (e is UnauthorizedException) {
        MyApp.isAuthenticated = false;
      }
      print("CustomException: $e $s ");
      emit(SearchFailure(errorMsg: e.toString(), errorCode: e.statusCode));
    } on SocketException catch (e, s) {
      //TODO: Handling socket exception
      print("SocketException|: $s $e");
      emit(SearchFailure(errorMsg: AppMessages.noInternetMsg, errorCode: 4));
    } catch (e, s) {
      print("catch section: $s $e");
      emit(SearchFailure(
          errorCode: AppValues.unknowErrorCode,
          errorMsg: AppMessages.unknownErrMsg));
    }
  }
}
