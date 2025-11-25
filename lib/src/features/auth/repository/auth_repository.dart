import 'package:senagat_mobile/src/features/home/models/user_information_model.dart';
import 'package:senagat_mobile/src/features/register_password_setup/models/new_password_model.dart';
import 'package:senagat_mobile/src/features/register_password_setup/models/new_password_model.dart';
import 'package:senagat_mobile/src/features/register_password_setup/models/new_password_model.dart';

import '../../../core/networking/api_endpoint.dart';
import '../../../core/networking/api_service.dart';
import '../../../core/typedefs.dart';
import '../../register_confirmation/models/account_model.dart';

class AuthRepository {
  final ApiService _apiService;

  const AuthRepository({required ApiService apiService})
    : _apiService = apiService;

  Future<bool> preLogin({required JSON data}) async {
    return _apiService.setData<bool>(
      endpoint: ApiEndpoint.auth(AuthEndpoint.PRE_LOGIN),
      data: data,
      converter: (response) {
        return response.body['success'];
      },
    );
  }

  Future<String> verifyOTP({required JSON data}) async {
    return _apiService.setData<String>(
      endpoint: ApiEndpoint.auth(AuthEndpoint.VERIFY_OTP),
      data: data,
      converter: (response) {
        return response.body['otp_session_token'];
      },
    );
  }

  Future<bool> requestOTP({required JSON data}) async {
    return _apiService.setData<bool>(
      endpoint: ApiEndpoint.auth(AuthEndpoint.REQUEST_OTP),
      data: data,
      converter: (response) {
        return response.body['success'];
      },
    );
  }

  Future<AccountModel> login({required JSON data}) async {
    return _apiService.setData<AccountModel>(
      endpoint: ApiEndpoint.auth(AuthEndpoint.LOGIN),
      data: data,
      converter: (response) {
        return AccountModel.fromJson(response.body['data']);
      },
    );
  }

  Future<AccountModel> register({required JSON data}) async {
    return _apiService.setData<AccountModel>(
      endpoint: ApiEndpoint.auth(AuthEndpoint.REGISTER),
      data: data,
      converter: (response) {
        return AccountModel.fromJson(response.body['data']);
      },
    );
  }

  Future<bool> checkRegister({required JSON data}) async {
    return _apiService.setData<bool>(
      endpoint: ApiEndpoint.auth(AuthEndpoint.CHECK_REGISTER),
      data: data,
      converter: (response) {
        return response.body['exists'];
      },
    );
  }

  Future<UserInformationModel> getUserInformation() async {
    return await _apiService.getDocumentData(
      endpoint: ApiEndpoint.auth(AuthEndpoint.USER_INFORMATION),
      requiresAuthToken: true,
      converter: (response) {
        return UserInformationModel.fromJson(response['data']);
      },
    );
  }

  Future<NewPasswordModel> resetPassword({required JSON data}) async {
    return _apiService.setData<NewPasswordModel>(
      endpoint: ApiEndpoint.auth(AuthEndpoint.RESET_PASSWORD),
      data: data,
      converter: (response) {
        return response.body['data'];
      },
    );
  }
}
