import 'package:senagat_mobile/src/features/map_search/model/location_model.dart';
import '../../../core/networking/api_endpoint.dart';
import '../../../core/networking/api_service.dart';

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

  Future<List<LocationModel>> getBranches() async {
    return await _apiService.getCollectionData(
      endpoint: await ApiEndpoint.location(LocationEndpoint.LOCATION_BRANCHES),
      requiresAuthToken: true,
      converter: (response) {
        return LocationModel.fromJson(response);
      },
    );
  }
}
