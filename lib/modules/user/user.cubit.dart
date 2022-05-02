import 'package:ez_search_ui/common/base_cubit.dart';
import 'package:ez_search_ui/constants/api_endpoints.dart';
import 'package:ez_search_ui/modules/user/user.model.dart';

class UserListCubit extends BaseCubit<UserModel> {
  UserListCubit() : super(UserModel.fromMap, UserModel.toMap);
  void getAll() {
    super.getAllListData(ApiPaths.userSearch);
  }
}
