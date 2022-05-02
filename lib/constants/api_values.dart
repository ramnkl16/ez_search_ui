class ApiValues {
  static const String authTokenHeader = 'x-auth';
  static const String nsIdHeader = 'x-ns';

  static const String authTokenTime = 'auth_time';
  static const String dataVal = 'data';
  static const String idVal = 'id';
  static const String dateTimeVal = 'datetime';
  static const String nsIdVal = 'NamespaceID';

  static const String serverErrMsg = 'Something went wrong, Please try again';
  static const String unauthErrMsg = 'You are not authorized to view this page';
  static const String notFoundErrMsg =
      'Resource you are trying to access is not found';

  static const String badReqErrPrefix = 'Invalid Request: ';
  static const String notFoundErrPrefix = 'Not found: ';
  static const String serverErrPrefix = 'Internal Server Error: ';

  static const int emptyDataErrCode = 105;

  //Handling menu permission bit values
  static const int createPermission = 1;
  static const int readPermission = 2;
  static const int updatePermission = 4;
  static const int deletePermission = 8;
  static const int inheritPermission = 16;

  // static const String badRequestMsg = ''

  //Menu Permission ref types
  static const String nsRefType = 'NS';
  static const String groupRefType = 'GR';
  static const String userRefType = 'UR';

  static const String globalNSId = 'PLATFORM';

  static const String slotIdDtFmt = 'yMdHm';

  static const String regDtTimeFmt = 'yyyy-MM-dd HH:mm:ss';
  static const String regDtOnlyFmt = 'yyyy-MM-dd';
  static const String slotDtFmtTZ = 'yyyy-MM-ddTHH:mm:ssZ';
  static const String hrMinAmDtFmt = 'hh:mm a';

  //Booking Status
  static const int slotAvailable = 0;
  static const int slotBlocked = 4;
  static const int slotConfirmed = 1;
  static const int slotConfirmationPending = 2;
  static const int slotCancelled = 3;

  //Flags
  static const int removeBlockedSlotFlag = 1;
  static const int activeFlagTrue = 1;
  static const int activeFlagFalse = 0;

  static const int isPublicFlagTrue = 1;
  static const int isPublicFlagFalse = 0;

  static const int noRecordFoundStatus = 452;
}
