import 'package:senagat_mobile/src/features/loan/models/credit_order_model.dart';
import '../../../core/networking/api_endpoint.dart';
import '../../../core/networking/api_service.dart';
import '../../../core/typedefs.dart';
import '../models/credit_types_model.dart';

class CreditRepository {
  final ApiService _apiService;

  const CreditRepository({required ApiService apiService})
    : _apiService = apiService;

  Future<CreditOrderModel> creditOrder({required JSON data}) async {
    return _apiService.setData<CreditOrderModel>(
      endpoint: await ApiEndpoint.credit(CreditEndpoint.CREDIT_ORDER),
      data: data,
      requiresAuthToken: true,
      converter: (response) {
        final responseData = response.body['data'];
        return CreditOrderModel.fromJson(responseData);
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
