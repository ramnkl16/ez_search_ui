import 'package:ez_search_ui/common/base_cubit.dart';
import 'package:ez_search_ui/constants/api_endpoints.dart';
import 'package:ez_search_ui/modules/indexes/indexes.model.dart';

class IndexListCubit extends BaseCubit<IndexModel> {
  IndexListCubit() : super(IndexModel.fromMap, IndexModel.toMap);
  void getAll() {
    super.getAllListData(ApiPaths.userSearch);
  }
}
