import 'dart:io';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:ez_search_ui/common/base_cubit.dart';
import 'package:ez_search_ui/constants/api_endpoints.dart';
import 'package:ez_search_ui/constants/app_messages.dart';
import 'package:ez_search_ui/constants/app_values.dart';
import 'package:ez_search_ui/exceptions/custom_exception.model.dart';
import 'package:ez_search_ui/modules/rptquery/rptquery.model.dart';
import 'package:ez_search_ui/modules/rptquery/rptquery.repo.dart';
part 'rptquery.state.dart';

class RptQueryCubit extends BaseCubit<RptQueryModel> {
  RptQueryCubit() : super(RptQueryModel.fromMap, RptQueryModel.toMap);
  void getAll() {
    super.getAllListData(ApiPaths.rptQuerySearch);
  }
}

class RptQuerySaveCubit extends Cubit<RptQueryState> {
  RptQuerySaveCubit() : super(RptQueryInitial());
  RptQueryRepo rptRepo = RptQueryRepo();
  Future<void> createOrUpdateRptQuery(RptQueryModel model) async {
    emit(RptQueryLoading());
    try {
      await rptRepo.createOrUpdateQueryDef(model);
      emit(RptQuerySaveSuccess(id: model.id));
    } on CustomException catch (e, s) {
      print("CustomException: $s");
      emit(RptQueryFailure(errorMsg: e.toString(), errorCode: e.statusCode));
    } on SocketException catch (e, s) {
      print("SocketException: $s");
      emit(RptQueryFailure(errorMsg: AppMessages.noInternetMsg, errorCode: 4));
    } catch (e, s) {
      print("catch section: $s");
      emit(RptQueryFailure(
          errorMsg: AppMessages.unknownErrMsg,
          errorCode: AppValues.unknowErrorCode));
    }
  }
}
