import 'package:dio/dio.dart';
import 'package:senagat_mobile/src/features/identity_verification/models/profile_model.dart';
import '../../../core/networking/api_endpoint.dart';
import '../../../core/networking/api_service.dart';
import '../../../core/typedefs.dart';

class ProfileRepository {
  final ApiService _apiService;

  const ProfileRepository({required ApiService apiService})
    : _apiService = apiService;

  Future<ProfileModel> createProfile({required JSON data}) async {
    print('=== API Request Debug ===');
    print('Endpoint: ${ApiEndpoint.auth(AuthEndpoint.PROFILE)}');
    print('Data keys: ${data.keys.toList()}');
    print('Data size: ${data.toString().length} characters');
    if (data['scan_passport'] != null) {
      print(
        'Scan passport length: ${data['scan_passport'].toString().length} characters',
      );
    }
    print('=== End API Request Debug ===');

    return _apiService.setData<ProfileModel>(
      endpoint: ApiEndpoint.auth(AuthEndpoint.PROFILE),
      data: data,
      requiresAuthToken: true,
      converter: (response) {
        final responseData = response.body['data'];
        if (responseData != null) {
          return ProfileModel.fromJson(responseData);
        } else {
          throw Exception('Profile data is null in response');
        }
      },
    );
  }

  // Future<ProfileModel> createProfileWithFile({
  //   required ProfileModel profileModel,
  // }) async {
  //   print('=== Multipart Upload Debug ===');
  //   print('Endpoint: ${ApiEndpoint.auth(AuthEndpoint.PROFILE)}');
  //   print('Has passport scan: ${profileModel.passportScan != null}');
  //
  //   if (profileModel.passportScan != null) {
  //     final fileSize = await profileModel.passportScan!.length();
  //     print('File path: ${profileModel.passportScan!.path}');
  //     print(
  //       'File size: $fileSize bytes (${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB)',
  //     );
  //
  //     // Check if file is too large (over 1MB)
  //     if (fileSize > 1024 * 1024) {
  //       print(
  //         '⚠️ File is too large for upload. Uploading profile without file...',
  //       );
  //       return await _createProfileWithoutFile(profileModel);
  //     }
  //   }
  //   print('=== End Multipart Upload Debug ===');
  //
  //   // Create FormData for multipart upload
  //   FormData formData = FormData.fromMap({
  //     'first_name': profileModel.firstName,
  //     'last_name': profileModel.lastName,
  //     'middle_name': profileModel.middleName,
  //     'birth_date': profileModel.birthDate,
  //     'passport_number': profileModel.passportNumber,
  //     'gender': profileModel.gender,
  //     'issued_date': profileModel.issuedDate,
  //     'issued_by': profileModel.issuedBy,
  //   });
  //
  //   // Add file if exists
  //   if (profileModel.passportScan != null) {
  //     formData.files.add(
  //       MapEntry(
  //         'scan_passport',
  //         await MultipartFile.fromFile(
  //           profileModel.passportScan!.path,
  //           filename: 'passport_scan.pdf',
  //         ),
  //       ),
  //     );
  //   }
  //
  //   return _apiService.setData<ProfileModel>(
  //     endpoint: ApiEndpoint.auth(AuthEndpoint.PROFILE),
  //     data: formData,
  //     requiresAuthToken: true,
  //     converter: (response) {
  //       final responseData = response.body['data'];
  //       if (responseData != null) {
  //         return ProfileModel.fromJson(responseData);
  //       } else {
  //         throw Exception('Profile data is null in response');
  //       }
  //     },
  //   );
  // }

  Future<ProfileModel> _createProfileWithoutFile(
    ProfileModel profileModel,
  ) async {
    print('=== Upload Profile Without File ===');

    // Create profile without the file
    final profileData = {
      'first_name': profileModel.firstName,
      'last_name': profileModel.lastName,
      'middle_name': profileModel.middleName,
      'birth_date': profileModel.birthDate,
      'passport_number': profileModel.passportNumber,
      'gender': profileModel.gender,
      'issued_date': profileModel.issuedDate,
      'issued_by': profileModel.issuedBy,
      'scan_passport': null, // No file for now
    };

    print('Profile data size: ${profileData.toString().length} characters');

    return _apiService.setData<ProfileModel>(
      endpoint: ApiEndpoint.auth(AuthEndpoint.PROFILE),
      data: profileData,
      requiresAuthToken: true,
      converter: (response) {
        final responseData = response.body['data'];
        if (responseData != null) {
          return ProfileModel.fromJson(responseData);
        } else {
          throw Exception('Profile data is null in response');
        }
      },
    );
  }
}
