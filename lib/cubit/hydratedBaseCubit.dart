import 'dart:io';

import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:ez_search_ui/common/base_cubit.dart';
import 'package:ez_search_ui/common/base_repo.dart';
import 'package:ez_search_ui/constants/app_messages.dart';
import 'package:ez_search_ui/constants/app_values.dart';
import 'package:ez_search_ui/exceptions/custom_exception.model.dart';
import 'package:ez_search_ui/helper/RepoHelper.dart';

class HydratedBaseCubit<T> extends HydratedCubit<BaseState> {
  HydratedBaseCubit(this.jsonDeserialize, this.jsonSerialize,
      {this.globalValues})
      : super(BaseInitial());
  Map<String, T>? globalValues;
  final T Function(Map<String, dynamic>) jsonDeserialize;
  final Map<String, dynamic> Function(T) jsonSerialize;

  RepoHelper repo = RepoHelper();
  // final BaseRepo baseRepo;
  BaseRepo baseRepo = BaseRepo();

  void emitInitialSuccess(List<T> list) {
    if (globalValues != null) {
      for (var element in list) {
        var res = jsonSerialize(element);
        globalValues![res["id"]] = element;
      }
    }

    emit(BaseListSuccess(list: list));
  }

  Future<void> getAllListData(String relativeUrl) async {
    emit(BaseLoading());
    try {
      // var token = await RepoHelper.getValue(ApiValues.authTokenHeader);
      List<T> items = await baseRepo.getAllList<T>(relativeUrl, jsonDeserialize,
          globalValues: globalValues);
      emit(BaseListSuccess<T>(list: items));
    } on CustomException catch (e, s) {
      print("CustomException|HydratedBaseCubit: $s");
      if (e is NoDataFoundException) {
        //  if (items.isEmpty) {
        emit(BaseEmpty());
        // return;
        // }
      } else {
        emit(BaseFailure(errorMsg: e.toString(), errorCode: e.statusCode));
      }
      // emit(BaseFailure(errorMsg: e.toString(), errorCode: e.errorCode));
    } on SocketException catch (e, s) {
      //TODO: Handling socket exception
      print("SocketException|HydratedBaseCubit: $s");
      emit(
          const BaseFailure(errorMsg: AppMessages.noInternetMsg, errorCode: 4));
    } catch (e, s) {
      print("catch|HydratedBaseCubit: $s");
      emit(const BaseFailure(
          errorCode: AppValues.unknowErrorCode,
          errorMsg: AppMessages.unknownErrMsg));
    }
  }

  Future<void> createOrUpdate(String relativeUrl, T data) async {
    emit(BaseLoading());
    try {
      String? id =
          await baseRepo.createOrUpdate(relativeUrl, jsonSerialize(data));
      emit(BaseEditSuccess(id: id));
    } on CustomException catch (e, s) {
      print("STACK TRACE: $s");
      emit(BaseFailure(errorMsg: e.toString(), errorCode: e.statusCode));
    } on SocketException catch (e, s) {
      //TODO: Handling socket exception
      print("STACK TRACE: $s");
      emit(
          const BaseFailure(errorMsg: AppMessages.noInternetMsg, errorCode: 4));
    } catch (e, s) {
      print("STACK TRACE: $s");
      emit(const BaseFailure(
          errorCode: AppValues.unknowErrorCode,
          errorMsg: AppMessages.unknownErrMsg));
    }
  }

  @override
  BaseState? fromJson(Map<String, dynamic> json) {
    // print('From json called ${T.runtimeType}' + T.runtimeType.toString());
    //print(jsonDeserialize);
    //print(json);
    List<dynamic>? data = json['list'];
    // print(data);
    if (data != null) {
      //print('Inside dat!= null if');
      List<T> success = [];
      for (var element in data) {
        success.add(jsonDeserialize(element as Map<String, dynamic>));
      }
      //print('Before success;');
      return BaseListSuccess<T>(list: success);
    }
    return null;
    // throw UnimplementedError();
  }

  @override
  Map<String, dynamic>? toJson(BaseState state) {
    // print('TO json called  ${myFunc<T>}' + T.runtimeType.toString());
    if (state is BaseListSuccess<T>) {
      List<Map<String, dynamic>> res = [];
      for (var element in state.list) {
        res.add(jsonSerialize(element));
      }
      return {'list': res};
    }
    return null;
  }
}
