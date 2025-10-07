import 'package:dio/dio.dart';
import 'package:senagat_mobile/src/features/inquiries/models/inquiries_model.dart';
import 'package:senagat_mobile/src/features/inquiries/models/inquiries_model.dart';
import '../../../core/networking/api_endpoint.dart';
import '../../../core/networking/api_service.dart';
import '../../../core/typedefs.dart';
import '../../identity_verification/models/profile_model.dart';
import '../../register_confirmation/models/account_model.dart';

class InquiriesRepository {
  final ApiService _apiService;

  const InquiriesRepository({required ApiService apiService})
      : _apiService = apiService;

  Future<InquiriesModel> createInquiresOrder({required JSON data}) async {
    return _apiService.setData<InquiriesModel>(
      endpoint: await ApiEndpoint.inquiries(InquiriesEndpoint.CERTIFICATE_ORDER,),
      data: data,
      requiresAuthToken: true,
      converter: (response) {
        final responseData = response.body['data'];
        if (responseData != null) {
          return InquiriesModel.fromJson(responseData);
        } else {
          throw Exception('Profile data is null in response');
        }
      },
    );
  }

  Future<List<InquiriesModel>> getInquiriesTypes() async {
    return await _apiService.getCollectionData(
      endpoint: await ApiEndpoint.inquiries(InquiriesEndpoint.CERTIFICATE_TYPES),
      requiresAuthToken: true,
      converter: (response) {
        return InquiriesModel.fromJson(response);
      },
    );
  }

}
