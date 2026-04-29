import 'package:dio/dio.dart';
import 'package:senagat_mobile/src/features/identity_verification/models/profile_model.dart';
import '../../../core/networking/api_endpoint.dart';
import '../../../core/networking/api_service.dart';

class ProfileRepository {
  final ApiService _apiService;

  const ProfileRepository({required ApiService apiService})
    : _apiService = apiService;

  Future<ProfileModel> createProfile(FormData data) async {
    return _apiService.setData<ProfileModel>(
      endpoint: ApiEndpoint.auth(AuthEndpoint.PROFILE),
      data: data,
      requiresAuthToken: true,
      converter: (response) {
        final responseData = response.body['data'];
        return ProfileModel.fromJson(responseData);
      },
    );
  }
}
