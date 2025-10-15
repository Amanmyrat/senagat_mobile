import 'package:dio/dio.dart';
import 'package:senagat_mobile/src/features/get_card/models/card_type_model.dart';
import 'package:senagat_mobile/src/features/get_card_details/models/card_order_model.dart';
import 'package:senagat_mobile/src/features/get_card_details/models/card_order_model.dart';
import 'package:senagat_mobile/src/features/get_card_details/models/card_order_model.dart';
import 'package:senagat_mobile/src/features/identity_verification/models/profile_model.dart';
import 'package:senagat_mobile/src/features/map_search/model/location_model.dart';
import '../../../core/networking/api_endpoint.dart';
import '../../../core/networking/api_service.dart';
import '../../../core/typedefs.dart';

class LocationRepository {
  final ApiService _apiService;

  const LocationRepository({required ApiService apiService})
      : _apiService = apiService;


  Future<List<LocationModel>> getLocations() async {
    return await _apiService.getCollectionData(
      endpoint: await ApiEndpoint.location(LocationEndpoint.LOCATION),
      requiresAuthToken: true,
      converter: (response) {
        return LocationModel.fromJson(response);
      },
    );
  }
}
