// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:ez_search_ui/common/base_cubit.dart';
import 'package:ez_search_ui/constants/api_endpoints.dart';
import 'package:ez_search_ui/constants/app_messages.dart';
import 'package:ez_search_ui/constants/app_values.dart';
import 'package:ez_search_ui/exceptions/custom_exception.model.dart';
import 'package:ez_search_ui/main.dart';
import 'package:ez_search_ui/modules/indexes/indexes.cubit.dart';
import 'package:ez_search_ui/modules/indexes/indexes.repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class IndexListCubit extends BaseCubit<IndexModel> {
//   IndexListCubit() : super(IndexModel.fromMap, IndexModel.toMap);
//   void getAll() {
//     super.getAllListData(ApiPaths.ListIndexes);
//   }
// }

class IndexFieldListCubit extends Cubit<IndexState> {
  IndexFieldListCubit() : super(IndexInitial());

  IndexRepo repo = IndexRepo();

  Future<void> getIndexeFields(String indexName) async {
    emit(IndexLoading());
    try {
      var repo = IndexRepo();
      // print("getIndexeFields | $indexName");
      List<String> list =
          await repo.getIndexes(ApiPaths.listIndexFields, indexName);
      if (list == null) {
        emit(IndexEmpty());
      } else {
        emit(IndexSuccess(list: list));
      }
    } on CustomException catch (e, s) {
      // if (e is UnauthorizedException) {
      //   isAuthenticated = false;
      // }
      // print("CustomException: $e $s ");
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
