// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:ez_search_ui/constants/api_endpoints.dart';
import 'package:ez_search_ui/constants/app_messages.dart';
import 'package:ez_search_ui/constants/app_values.dart';
import 'package:ez_search_ui/exceptions/custom_exception.model.dart';
import 'package:ez_search_ui/main.dart';
import 'package:ez_search_ui/modules/indexes/indexes.repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class IndexListCubit extends BaseCubit<IndexModel> {
//   IndexListCubit() : super(IndexModel.fromMap, IndexModel.toMap);
//   void getAll() {
//     super.getAllListData(ApiPaths.ListIndexes);
//   }
// }

class IndexListCubit extends Cubit<IndexState> {
  IndexListCubit() : super(IndexInitial());

  IndexRepo repo = IndexRepo();

  Future<void> getIndexes() async {
    emit(IndexLoading());
    try {
      var repo = IndexRepo();
      print("getIndexes");
      List<String> list = await repo.getIndexes(ApiPaths.ListIndexes);
      if (list == null) {
        emit(IndexEmpty());
      } else {
        emit(IndexSuccess(list: list));
      }
    } on CustomException catch (e, s) {
      if (e is UnauthorizedException) {
        MyApp.isAuthenticated = false;
      }
      print("CustomException: $e $s ");
      emit(IndexFailure(errorMsg: e.toString(), errorCode: e.statusCode));
    } on SocketException catch (e, s) {
      //TODO: Handling socket exception
      print("SocketException|: $s $e");
      emit(const IndexFailure(
          errorMsg: AppMessages.noInternetMsg, errorCode: 4));
    } catch (e, s) {
      print("catch section: $s $e");
      emit(const IndexFailure(
          errorCode: AppValues.unknowErrorCode,
          errorMsg: AppMessages.unknownErrMsg));
    }
  }
}

abstract class IndexState extends Equatable {
  const IndexState();

  @override
  List<Object> get props => [];
}

class IndexInitial extends IndexState {}

class IndexEmpty extends IndexState {}

class IndexSuccess extends IndexState {
  final List<String> list;
  const IndexSuccess({
    required this.list,
  });

  @override
  List<Object> get props => list;
}

class IndexLoading extends IndexState {}

class IndexFailure extends IndexState {
  final String errorMsg;
  final int errorCode;
  const IndexFailure({
    required this.errorMsg,
    required this.errorCode,
  });
}
