import 'package:dio/dio.dart';
import 'package:senagat_mobile/src/features/get_card/models/card_type_model.dart';
import 'package:senagat_mobile/src/features/get_card_details/models/card_order_model.dart';
import 'package:senagat_mobile/src/features/get_card_details/models/card_order_model.dart';
import 'package:senagat_mobile/src/features/get_card_details/models/card_order_model.dart';
import 'package:senagat_mobile/src/features/identity_verification/models/profile_model.dart';
import '../../../core/networking/api_endpoint.dart';
import '../../../core/networking/api_service.dart';
import '../../../core/typedefs.dart';

class CardRepository {
  final ApiService _apiService;

  const CardRepository({required ApiService apiService})
    : _apiService = apiService;

  Future<CardOrderModel> createCardOrder({required JSON data}) async {
    return _apiService.setData<CardOrderModel>(
      endpoint: await ApiEndpoint.card(CardEndpoint.CARD_ORDER,),
      data: data,
      requiresAuthToken: true,
      converter: (response) {
        final responseData = response.body['data'];
        if (responseData != null) {
          return CardOrderModel.fromJson(responseData);
        } else {
          throw Exception('Profile data is null in response');
        }
      },
    );
  }

  Future<List<CardTypeModel>> getCardTypes() async {
    return await _apiService.getCollectionData(
      endpoint: await ApiEndpoint.card(CardEndpoint.CARD_TYPES),
      requiresAuthToken: true,
      converter: (response) {
        return CardTypeModel.fromJson(response);
      },
    );
  }
}
