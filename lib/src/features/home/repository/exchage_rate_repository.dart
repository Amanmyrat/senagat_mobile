import 'package:senagat_mobile/src/features/home/models/exchange_rate_model.dart';
import '../../../core/networking/api_endpoint.dart';
import '../../../core/networking/api_service.dart';


class ExchangeRateRepository {
  final ApiService _apiService;

  const ExchangeRateRepository({required ApiService apiService})
      : _apiService = apiService;


  Future<List<ExchangeRateModel>> getExchangeRateTypes() async {
    return await _apiService.getCollectionData(
      endpoint: await ApiEndpoint.exchangeRate(ExchangeRateEndpoint.EXCHANGE_RALE),
      requiresAuthToken: true,
      converter: (response) {
        return ExchangeRateModel.fromJson(response);
      },
    );
  }

}
