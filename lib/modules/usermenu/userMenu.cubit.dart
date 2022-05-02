import 'package:ez_search_ui/common/base_cubit.dart';
import 'package:ez_search_ui/constants/api_endpoints.dart';
import 'package:ez_search_ui/modules/usermenu/usermenu.model.dart';

class UserMenuCubit extends BaseCubit<UserMenuModel> {
  UserMenuCubit() : super(UserMenuModel.fromMap, UserMenuModel.toMap);
  void getAll() {
    super.getAllListData(ApiPaths.userMenuSearch);
  }
}
