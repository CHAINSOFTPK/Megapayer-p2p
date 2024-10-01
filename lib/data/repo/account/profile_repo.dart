import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:local_coin/constants/my_strings.dart';
import 'package:local_coin/core/helper/shared_pref_helper.dart';
import 'package:local_coin/data/model/authorization/AuthorizationResponseModel.dart';
import 'package:local_coin/data/model/public_profile/profile_complete_post_model.dart';

import '../../../constants/method.dart';
import '../../../core/utils/url_container.dart';
import '../../../view/components/show_custom_snackbar.dart';
import '../../model/account/ProfileResponseModel.dart';
import '../../model/account/user_post_model/UserPostModel.dart';
import '../../model/global/response_model/response_model.dart';
import '../../services/api_service.dart';

class ProfileRepo {
  ApiClient apiClient;

  ProfileRepo({required this.apiClient});

  Future<bool> updateProfile(UserPostModel m, String callFrom) async {
    print('final map ${m.image}');

    try {
      apiClient.initToken();

      String url = '${UrlContainer.baseUrl}${callFrom == 'profile' ? UrlContainer.updateProfileEndPoint : UrlContainer.profileCompleteEndPoint}';

      var request = http.MultipartRequest('POST', Uri.parse(url));
      //'image':m.image!=null?await dio_.MultipartFile.fromFile(m.image?.path??'',filename: m.image?.path.split('/').last??''):'',
      Map<String, String> finalMap = {
        'firstname': m.firstname,
        'lastname': m.lastName,
        'address': m.address ?? '',
        'zip': m.zip ?? '',
        'state': m.state ?? "",
        'city': m.city ?? '',
      };

      request.headers.addAll(<String, String>{'Authorization': 'Bearer ${apiClient.token}'});
      if (m.image != null) {
        print("image not null");
        request.files.add(http.MultipartFile('image', m.image!.readAsBytes().asStream(), m.image!.lengthSync(), filename: m.image!.path.split('/').last));
      }
      request.fields.addAll(finalMap);

      http.StreamedResponse response = await request.send();
      print('final map $finalMap');
      String jsonResponse = await response.stream.bytesToString();
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(jsonDecode(jsonResponse));
      print("model.data?.user?.image ${model.data?.user?.image}");
      if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        CustomSnackbar.showCustomSnackbar(errorList: [], msg: model.message?.success ?? [MyStrings.success], isError: false);
        return true;
      } else {
        CustomSnackbar.showCustomSnackbar(errorList: [], msg: model.message?.error ?? [MyStrings.error], isError: false);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<ResponseModel> completeProfile(ProfileCompletePostModel model) async {
    dynamic params = model.toMap();
    String url = '${UrlContainer.baseUrl}${UrlContainer.profileCompleteEndPoint}';
    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, params, passHeader: true);
    return responseModel;
  }

  Future<ProfileResponseModel> loadProfileInfo() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.getProfileEndPoint}';

    ResponseModel responseModel = await apiClient.request(url, Method.getMethod, null, passHeader: true);

    if (responseModel.statusCode == 200) {
      ProfileResponseModel model = ProfileResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status == 'success') {
        return model;
      } else {
        return ProfileResponseModel();
      }
    } else {
      return ProfileResponseModel();
    }
  }

  Future<dynamic> getCountryList() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.countryEndPoint}';
    ResponseModel model = await apiClient.request(url, Method.getMethod, null);
    return model;
  }

  Future<bool> sendUserToken() async {
    String deviceToken;
    if (apiClient.sharedPreferences.containsKey(SharedPreferenceHelper.fcmDeviceKey)) {
      deviceToken = apiClient.sharedPreferences.getString(SharedPreferenceHelper.fcmDeviceKey) ?? '';
    } else {
      deviceToken = '';
    }

    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    bool success = false;
    if (deviceToken.isEmpty) {
      firebaseMessaging.getToken().then((fcmDeviceToken) async {
        success = await sendUpdatedToken(fcmDeviceToken ?? '');
      });
    } else {
      firebaseMessaging.onTokenRefresh.listen((fcmDeviceToken) async {
        if (deviceToken == fcmDeviceToken) {
          success = true;
        } else {
          apiClient.sharedPreferences.setString(SharedPreferenceHelper.fcmDeviceKey, fcmDeviceToken);
          success = await sendUpdatedToken(fcmDeviceToken);
        }
      });
    }
    return success;
  }

  Future<bool> sendUpdatedToken(String deviceToken) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.deviceTokenEndPoint}';
    Map<String, String> map = deviceTokenMap(deviceToken);

    await apiClient.request(url, Method.postMethod, map, passHeader: true);
    return true;
  }

  Map<String, String> deviceTokenMap(String deviceToken) {
    Map<String, String> map = {'token': deviceToken.toString()};
    return map;
  }
}
