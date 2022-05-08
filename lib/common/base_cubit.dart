import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:ez_search_ui/common/base_repo.dart';
import 'package:ez_search_ui/constants/app_messages.dart';
import 'package:ez_search_ui/constants/app_values.dart';
import 'package:ez_search_ui/exceptions/custom_exception.model.dart';
import 'package:ez_search_ui/helper/RepoHelper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'base_state.dart';

class BaseCubit<T> extends Cubit<BaseState> {
  BaseCubit(this.jsonDeserialize, this.jsonSerialize, {this.globalValues})
      : super(BaseInitial());
  RepoHelper repo = RepoHelper();

  final T Function(Map<String, dynamic>) jsonDeserialize;
  final Map<String, dynamic> Function(T) jsonSerialize;
  Map<String, T>? globalValues;
  // final BaseRepo baseRepo;
  BaseRepo baseRepo = BaseRepo();

  void emitInitialSuccess(List<T> list) {
    emit(BaseListSuccess(list: list));
  }

  Future<void> getAllListData(String relativeUrl) async {
    emit(BaseLoading());
    try {
      // print("inside try|$relativeUrl");
      // var token = await RepoHelper.getValue(ApiValues.authTokenHeader);
      List<T> items = await baseRepo.getAllList<T>(relativeUrl, jsonDeserialize,
          globalValues: globalValues);
      //print("after getalllistdata $items");
      emit(BaseListSuccess<T>(list: items));
    } on CustomException catch (e, s) {
      print("CustomException|basecubit: $e $s");
      if (e is NoDataFoundException) {
        //  if (items.isEmpty) {
        emit(BaseEmpty());
        // return;
        // }
      } else {
        emit(BaseFailure(errorMsg: e.toString(), errorCode: e.statusCode));
      }
    } on SocketException catch (e, s) {
      //TODO: Handling socket exception
      print("SocketException|basecubit: $e $s");
      emit(
          const BaseFailure(errorMsg: AppMessages.noInternetMsg, errorCode: 4));
    } catch (e, s) {
      print("catch|basecubit: $e $s");
      emit(const BaseFailure(
          errorCode: AppValues.unknowErrorCode,
          errorMsg: AppMessages.unknownErrMsg));
    }
  }

  Future<void> createOrUpdate(String relativeUrl, T data) async {
    emit(BaseLoading());
    try {
      // print("save data ${jsonSerialize(data)}");
      String? id =
          await baseRepo.createOrUpdate(relativeUrl, jsonSerialize(data));
      emit(BaseEditSuccess(id: id));
    } on CustomException catch (e, s) {
      print("CustomException $s");
      emit(BaseFailure(errorMsg: e.toString(), errorCode: e.statusCode));
    } on SocketException catch (e, s) {
      //TODO: Handling socket exception
      print("SocketException: $s");
      emit(
          const BaseFailure(errorMsg: AppMessages.noInternetMsg, errorCode: 4));
    } catch (e, s) {
      print("catch block: $s");
      emit(const BaseFailure(
          errorCode: AppValues.unknowErrorCode,
          errorMsg: AppMessages.unknownErrMsg));
    }
  }
}
