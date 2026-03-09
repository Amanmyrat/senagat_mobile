import 'package:senagat_mobile/src/features/home/models/user_information_model.dart';
import 'package:senagat_mobile/src/features/pay/model/belet_balances_model.dart';
import 'package:senagat_mobile/src/features/pay/model/belet_top_up_model.dart';
import 'package:senagat_mobile/src/features/pay/model/belet_top_up_model.dart';
import 'package:senagat_mobile/src/features/pay/model/belet_top_up_model.dart';
import 'package:senagat_mobile/src/features/pay/model/charity_model.dart';
import 'package:senagat_mobile/src/features/register_password_setup/models/new_password_model.dart';
import 'package:senagat_mobile/src/features/register_password_setup/models/new_password_model.dart';
import 'package:senagat_mobile/src/features/register_password_setup/models/new_password_model.dart';

import '../../../core/networking/api_endpoint.dart';
import '../../../core/networking/api_service.dart';
import '../../../core/typedefs.dart';
import '../../register_confirmation/models/account_model.dart';
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

  Future<String> telecomBalance({required JSON data}) async {
    return _apiService.setData<String>(
      endpoint: await ApiEndpoint.payment(PaymentEndpoint.TELECOM_BALANCE),
      data: data,
      requiresAuthToken: true,
      converter: (response) {
        return response.body['data']['balance'];
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




}
