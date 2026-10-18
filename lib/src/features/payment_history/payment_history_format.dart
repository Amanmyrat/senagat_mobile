import 'package:senagat_mobile/src/features/pay/model/paymet_history_model.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';

String paymentHistoryTitle(String type) {
  switch (type) {
    case 'tmcell':
      return 'TM CELL';
    case 'charity':
      return 'charity';
    case 'belet':
      return 'belet';
    case 'astu iptv':
      return 'IP TV';
    case 'astu phone':
      return 'astu_phone';
    case 'cdma':
      return 'CDMA';
    case 'astu internet':
      return 'astu_internet';
    case 'telecom':
      return 'telecom_internet';
    case 'alem_iptv':
    case 'alem_tv':
      return 'ÄlemTv';
    default:
      return type;
  }
}

String paymentServiceNameTm(String type) {
  switch (type) {
    case 'tmcell':
      return 'TM CELL';
    case 'charity':
      return 'Haýyr-sahawat gaznasy';
    case 'belet':
      return 'Belet';
    case 'astu iptv':
      return 'IP TV';
    case 'astu phone':
      return 'AŞTU telefon';
    case 'cdma':
      return 'CDMA';
    case 'astu internet':
      return 'AŞTU Internet';
    case 'telecom':
      return 'Telekom Internet';
    case 'alem_iptv':
    case 'alem_tv':
      return 'ÄlemTv';
    default:
      return type;
  }
}

String paymentHistoryTarget(PaymentHistoryModel item) {
  final value = item.paymentTarget.value;
  switch (item.type) {
    case 'tmcell':
    case 'charity':
      return '+993$value';
    case 'belet':
      return '+$value';
    case 'astu iptv':
    case 'astu phone':
    case 'astu internet':
      return '12$value';
    default:
      return value;
  }
}

String paymentHistoryIcon(String type) {
  switch (type) {
    case 'tmcell':
      return AppAssets.tmCell;
    case 'charity':
      return AppAssets.foundation;
    case 'belet':
      return AppAssets.beletIcon;
    case 'astu iptv':
    case 'astu phone':
    case 'cdma':
    case 'astu internet':
      return AppAssets.astu;
    case 'telecom':
      return AppAssets.telecom;
    case 'alem_iptv':
    case 'alem_tv':
      return AppAssets.alemTv;
    default:
      return AppAssets.deviceMobileIcon;
  }
}
