import 'package:ez_search_ui/common/global.dart';
import 'package:ez_search_ui/constants/api_endpoints.dart';
import 'package:ez_search_ui/modules/usermenu/usermenu.model.dart';

import 'hydratedBaseCubit.dart';

class UserMenuListCubit extends HydratedBaseCubit<UserMenuModel> {
  UserMenuListCubit()
      : super(UserMenuModel.fromMap, UserMenuModel.toMap,
            globalValues: Global.userMenus);

  void getAll() {
    super.getAllListData(ApiPaths.userMenuSearch);
  }
}
