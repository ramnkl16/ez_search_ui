import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:ez_search_ui/common/base_repo.dart';
import 'package:ez_search_ui/common/base_cubit.dart';
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

  @override
  fromJson(Map<String, dynamic> json) {
    print('From json called ${T.runtimeType}' + T.runtimeType.toString());
    print(jsonDeserialize);
    print(json);
    List<dynamic>? data = json['list'];
    print(data);
    if (data != null) {
      print('Inside dat!= null if');
      List<T> success = [];
      for (var element in data) {
        success.add(jsonDeserialize(element as Map<String, dynamic>));
      }
      print('Before success;');
      return BaseListSuccess<T>(list: success);
    }
    return null;
    // throw UnimplementedError();
  }

  @override
  Map<String, dynamic>? toJson(state) {
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
