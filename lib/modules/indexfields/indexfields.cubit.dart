import 'package:ez_search_ui/common/base_cubit.dart';
import 'package:ez_search_ui/constants/api_endpoints.dart';
import 'package:ez_search_ui/modules/indexfields/indexfields.model.dart';

class IndexFieldListCubit extends BaseCubit<IndexFieldModel> {
  IndexFieldListCubit() : super(IndexFieldModel.fromMap, IndexFieldModel.toMap);
  void getAll() {
    super.getAllListData(ApiPaths.ListIndexFields);
  }
}
