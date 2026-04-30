import 'package:senagat_mobile/src/features/check_phone_balance/model/check_balance_model.dart';
import 'package:senagat_mobile/src/features/pay/model/alem_top_up_model.dart';
import 'package:senagat_mobile/src/features/pay/model/alem_top_up_model.dart';
import 'package:senagat_mobile/src/features/pay/model/alem_top_up_model.dart';
import 'package:senagat_mobile/src/features/pay/model/astu_top_up_model.dart';
import 'package:senagat_mobile/src/features/pay/model/belet_balances_model.dart';
import 'package:senagat_mobile/src/features/pay/model/belet_top_up_model.dart';
import 'package:senagat_mobile/src/features/pay/model/charity_model.dart';

import '../../../core/networking/api_endpoint.dart';
import '../../../core/networking/api_service.dart';
import '../../../core/typedefs.dart';
import '../model/alem_get_tariff_model.dart';
import '../model/paymet_history_model.dart';
import '../model/telecom_top_up_model.dart';

class PaymentRepository {
  final ApiService _apiService;

  const PaymentRepository({required ApiService apiService})
      : _apiService = apiService;


  Future<bool> checkPhone({required JSON data}) async {
    return _apiService.setData<bool>(
      endpoint: await ApiEndpoint.payment(PaymentEndpoint.CHECK_PHONE),
      data: data,
      converter: (response) {
        return response.body['success'];
      },
    );
  }

  Future<List<BeletBalanceModel>> getBalance() async {
    return await _apiService.getDocumentData(
      endpoint: await ApiEndpoint.payment(PaymentEndpoint.BALANCE),
      requiresAuthToken: true,
      converter: (response) {
        final List items = response['data']['items'];
        return items
            .map((e) => BeletBalanceModel.fromJson(e))
            .toList();
      },
    );
  }


  Future<BeletTopUpModel> beletTopUp({required JSON data}) async {
    return _apiService.setData<BeletTopUpModel>(
      endpoint: await ApiEndpoint.payment(PaymentEndpoint.TOP_UP,),
      data: data,
      requiresAuthToken: true,
      converter: (response) {
        final responseData = response.body['data'];
        if (responseData != null) {
          return BeletTopUpModel.fromMap(responseData);
        } else {
          throw Exception('Profile data is null in response');
        }
      },
    );
  }

  Future<CheckBalanceModel> beletBalance({required JSON data}) async {
    return _apiService.setData<CheckBalanceModel>(
      endpoint: await ApiEndpoint.payment(PaymentEndpoint.BELET_BALANCE),
      data: data,
      requiresAuthToken: true,
      converter: (response) {
        final responseData = response.body;
        return CheckBalanceModel.fromMap(responseData);

      },
    );
  }

  Future<CharityModel> charity({required JSON data}) async {
    return _apiService.setData<CharityModel>(
      endpoint: await ApiEndpoint.charity(CharityEndpoint.CHARITY,),
      data: data,
      requiresAuthToken: true,
      converter: (response) {
        final responseData = response.body['data'];
        if (responseData != null) {
          return CharityModel.fromMap(responseData);
        } else {
          throw Exception('Profile data is null in response');
        }
      },
    );
  }

  Future<List<PaymentHistoryModel>> getPaymentHistory() async {
    return await _apiService.getCollectionData(
      endpoint: await ApiEndpoint.payment(
        PaymentEndpoint.HISTORY,
      ),
      requiresAuthToken: true,
      converter: (response) {
        return PaymentHistoryModel.fromJson(response);
      },
    );
  }

  Future<CheckBalanceModel> telecomBalance({required JSON data}) async {
    return _apiService.setData<CheckBalanceModel>(
      endpoint: await ApiEndpoint.payment(PaymentEndpoint.TELECOM_BALANCE),
      data: data,
      requiresAuthToken: true,
      converter: (response) {
        final responseData = response.body;
        return CheckBalanceModel.fromMap(responseData);

      },
    );
  }

  Future<TelecomTopUpModel> telecomPay({required JSON data}) async {
    return _apiService.setData<TelecomTopUpModel>(
      endpoint: await ApiEndpoint.payment(PaymentEndpoint.TELECOM_PAY),
      data: data,
      requiresAuthToken: true,
      converter: (response) {
        final responseData = response.body['data'];
        if (responseData != null) {
          return TelecomTopUpModel.fromMap(responseData);
        } else {
          throw Exception('Payment data is null in response');
        }
      },
    );
  }

  Future<CheckBalanceModel> astuBalance({required JSON data}) async {
    return _apiService.setData<CheckBalanceModel>(
      endpoint: await ApiEndpoint.payment(PaymentEndpoint.ASTU_BALANCE),
      data: data,
      requiresAuthToken: true,
      converter: (response) {
        final responseData = response.body;
        return CheckBalanceModel.fromMap(responseData);
      },
    );
  }

  Future<AstuTopUpModel> astuPay({required JSON data}) async {
    return _apiService.setData<AstuTopUpModel>(
      endpoint: await ApiEndpoint.payment(PaymentEndpoint.ASTU_PAY),
      data: data,
      requiresAuthToken: true,
      converter: (response) {
        final responseData = response.body['data'];
        if (responseData != null) {
          return AstuTopUpModel.fromMap(responseData);
        } else {
          throw Exception('Payment data is null in response');
        }
      },
    );
  }

  Future<CheckBalanceModel> tmcellBalance({required JSON data}) async {
    return _apiService.setData<CheckBalanceModel>(
      endpoint: await ApiEndpoint.payment(PaymentEndpoint.TMCELL_BALANCE),
      data: data,
      requiresAuthToken: true,
      converter: (response) {
        final responseData = response.body;
        return CheckBalanceModel.fromMap(responseData);
      },
    );
  }

  Future<TelecomTopUpModel> tmcellPay({required JSON data}) async {
    return _apiService.setData<TelecomTopUpModel>(
      endpoint: await ApiEndpoint.payment(PaymentEndpoint.TMCELL_PAY),
      data: data,
      requiresAuthToken: true,
      converter: (response) {
        final responseData = response.body['data'];
        if (responseData != null) {
          return TelecomTopUpModel.fromMap(responseData);
        } else {
          throw Exception('Payment data is null in response');
        }
      },
    );
  }
  Future<CheckBalanceModel> cdmaBalance({required JSON data}) async {
    return _apiService.setData<CheckBalanceModel>(
      endpoint: await ApiEndpoint.payment(PaymentEndpoint.CDMA_BALANCE),
      data: data,
      requiresAuthToken: true,
      converter: (response) {
        final responseData = response.body;
        return CheckBalanceModel.fromMap(responseData);
      },
    );
  }

  Future<TelecomTopUpModel> cdmaPay({required JSON data}) async {
    return _apiService.setData<TelecomTopUpModel>(
      endpoint: await ApiEndpoint.payment(PaymentEndpoint.CDMA_PAY),
      data: data,
      requiresAuthToken: true,
      converter: (response) {
        final responseData = response.body['data'];
        if (responseData != null) {
          return TelecomTopUpModel.fromMap(responseData);
        } else {
          throw Exception('Payment data is null in response');
        }
      },
    );
  }

  Future<AlemGetTariffModel> alemGetTariff({required JSON data}) async {
    return _apiService.setData<AlemGetTariffModel>(
      endpoint: await ApiEndpoint.payment(PaymentEndpoint.ALEM_TARIFF),
      data: data,
      requiresAuthToken: true,
      converter: (response) {
        final responseData = response.body['data'];
        if (responseData != null) {
          return AlemGetTariffModel.fromMap(responseData);
        } else {
          throw Exception('Payment data is null in response');
        }
      },
    );
  }

  Future<AlemTopUpModel> alemTopUp({required JSON data}) async {
    return _apiService.setData<AlemTopUpModel>(
      endpoint: await ApiEndpoint.payment(PaymentEndpoint.ALEM_TOP_UP),
      data: data,
      requiresAuthToken: true,
      converter: (response) {
        final responseData = response.body['data'];
        if (responseData != null) {
          return AlemTopUpModel.fromMap(responseData);
        } else {
          throw Exception('Payment data is null in response');
        }
      },
    );
  }




}
