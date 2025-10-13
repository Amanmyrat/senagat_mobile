import 'package:dio/dio.dart';
import 'package:senagat_mobile/src/features/credit/models/credit_details_model.dart';
import 'package:senagat_mobile/src/features/get_card/models/card_type_model.dart';
import 'package:senagat_mobile/src/features/get_card_details/models/card_order_model.dart';
import 'package:senagat_mobile/src/features/loan/models/credit_branch_info_model.dart';
import 'package:senagat_mobile/src/features/loan/models/credit_work_info_model.dart';
import '../../../core/networking/api_endpoint.dart';
import '../../../core/networking/api_service.dart';
import '../../../core/typedefs.dart';
import '../models/credit_types_model.dart';

class CreditRepository {
  final ApiService _apiService;

  const CreditRepository({required ApiService apiService})
    : _apiService = apiService;

  Future<CreditDetailsModel> submitCreditDetails({required JSON data}) async {
    return _apiService.setData<CreditDetailsModel>(
      endpoint: await ApiEndpoint.credit(CreditEndpoint.CREDIT_DETAILS),
      data: data,
      requiresAuthToken: true,
      converter: (response) {
        final responseData = response.body['data'];
        return CreditDetailsModel.fromJson(responseData);
      },
    );
  }

  Future<CreditWorkInfoModel> submitWorkInfo({required JSON data}) async {
    return _apiService.setData<CreditWorkInfoModel>(
      endpoint: await ApiEndpoint.credit(CreditEndpoint.WORK_INFO),
      data: data,
      requiresAuthToken: true,
      converter: (response) {
        final responseData = response.body['data'];
        return CreditWorkInfoModel.fromJson(responseData);
      },
    );
  }

  Future<CreditBranchInfoModel> submitBranchInfo({required JSON data}) async {
    return _apiService.setData<CreditBranchInfoModel>(
      endpoint: await ApiEndpoint.credit(CreditEndpoint.BRANCH_INFO),
      data: data,
      requiresAuthToken: true,
      converter: (response) {
        final responseData = response.body['data'];
        return CreditBranchInfoModel.fromJson(responseData);
      },
    );
  }

  Future<List<CreditTypeModel>> getCreditTypes() async {
    return await _apiService.getCollectionData(
      endpoint: await ApiEndpoint.credit(CreditEndpoint.CREDIT_TYPES),
      requiresAuthToken: true,
      converter: (response) {
        return CreditTypeModel.fromJson(response);
      },
    );
  }
}
