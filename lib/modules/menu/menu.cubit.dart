import 'package:ez_search_ui/common/base_cubit.dart';
import 'package:ez_search_ui/constants/api_endpoints.dart';
import 'package:ez_search_ui/modules/menu/menu.model.dart';

class MenuCubit extends BaseCubit<MenuModel> {
  MenuCubit() : super(MenuModel.fromMap, MenuModel.toMap);
  void getAll() {
    super.getAllListData(ApiPaths.menuSearch);
  }
}
