import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_coin/constants/my_strings.dart';
import 'package:local_coin/core/route/route.dart';
import 'package:local_coin/data/model/auth/login_response_model.dart';
import 'package:local_coin/data/model/general_setting/GeneralSettingsResponseModel.dart';
import 'package:local_coin/data/model/global/response_model/response_model.dart';
import 'package:local_coin/data/model/user/user.dart';
import 'package:local_coin/data/repo/auth/social_login_repo.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_coin/view/components/show_custom_snackbar.dart';
import 'package:local_coin/view/packages/signin_with_linkdin/signin_with_linkedin.dart';

class SocialLoginController extends GetxController {
  SocialLoginRepo repo;
  SocialLoginController({required this.repo});

  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool isGoogleSignInLoading = false;
  Future<void> signInWithGoogle() async {
    try {
      isGoogleSignInLoading = true;
      update();
      googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        isGoogleSignInLoading = false;
        update();
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      await socialLoginUser(provider: 'google', accessToken: googleAuth.accessToken ?? '');
    } catch (e) {
      print(e.toString());
      CustomSnackbar.showCustomSnackbar(errorList: [e.toString()], msg: [], isError: true);
    }

    isGoogleSignInLoading = false;
    update();
  }

  bool isLinkedinLoading = false;
  Future<void> signInWithLinkedin(BuildContext context) async {
    try {
      isLinkedinLoading = true;
      update();

      SocialiteCredentials linkedinCredential = repo.apiClient.getSocialCredentialsConfigData();
      String linkedinCredentialRedirectUrl = "${repo.apiClient.getSocialCredentialsRedirectUrl()}/linkedin";
      print("linkedinCredentialRedirectUrl $linkedinCredentialRedirectUrl");
      print(linkedinCredential.linkedin?.toJson());

      SignInWithLinkedIn.signIn(
        context,
        config: LinkedInConfig(
          clientId: linkedinCredential.linkedin?.clientId ?? '',
          clientSecret: linkedinCredential.linkedin?.clientSecret ?? '',
          scope: ['openid', 'profile', 'email'],
          redirectUrl: linkedinCredentialRedirectUrl,
        ),
        onGetAuthToken: (data) {
          print('Auth token data: ${data.toJson()}');
        },
        onGetUserProfile: (token, user) async {
          print('${token.idToken}-');
          print('LinkedIn User: ${user.toJson()}');
          await socialLoginUser(provider: 'linkedin', accessToken: token.accessToken ?? '');
        },
        onSignInError: (error) {
          print('Error on sign in: $error');
          CustomSnackbar.showCustomSnackbar(errorList: [error.description ?? MyStrings.loginFailedTryAgain.tr], msg: [], isError: true);
          isLinkedinLoading = false;
          update();
        },
      );
    } catch (e) {
      debugPrint(e.toString());

      CustomSnackbar.showCustomSnackbar(errorList: [e.toString()], msg: [], isError: true);
    }
  }

  Future socialLoginUser({
    String accessToken = '',
    String? provider,
  }) async {
    try {
      ResponseModel responseModel = await repo.socialLoginUser(
        accessToken: accessToken,
        provider: provider,
      );
      if (responseModel.statusCode == 200) {
        LoginResponseModel loginModel = LoginResponseModel.fromJson(jsonDecode(responseModel.responseJson));
        if (loginModel.status.toString().toLowerCase() == MyStrings.success.toLowerCase()) {
          String accessToken = loginModel.data?.accessToken ?? "";
          String tokenType = loginModel.data?.tokenType ?? "";
          GlobalUser? user = loginModel.data?.user;

          await repo.sendUserToken();

          await RouteHelper.checkUserStatusAndGoToNextStep(user, accessToken: accessToken, tokenType: tokenType, isRemember: true);
        } else {
          CustomSnackbar.showCustomSnackbar(errorList: loginModel.message?.error ?? [MyStrings.loginFailedTryAgain.tr], msg: [], isError: true);
        }
      } else {
        CustomSnackbar.showCustomSnackbar(errorList: [responseModel.message], msg: [], isError: true);
      }
    } catch (e) {
      //printx(e.toString());
    }
  }

  bool checkSocialAuthActiveOrNot({String provider = 'all'}) {
    // Always return false to disable all social login options
    return false;
  }
}