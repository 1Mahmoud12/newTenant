import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/local/cache.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/account/view/myDetalis/data/dataSource/edit_profile_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());

  Future<void> getUserData({required BuildContext context}) async {
    emit(EditProfileLoading());
    await EditProfileDataSource.getUserData().then(
      (value) async {
        value.fold((l) {
          emit(EditProfileError(e: l.errMessage));
  }, (r) async {
          ConstantsModels.editProfileModel = r;
          // loginCacheValue?.data?.name = r.data?.name ?? 'unKnow name';
          // loginCacheValue?.data?.email = r.data?.email ?? 'unKnow email';
          // loginCacheValue?.data?.phone = r.data?.phone ?? 'unKnow phone';
          // loginCacheValue?.data?.avatarPath = r.data?.avatarPath ?? '';
          await loginCache?.put(loginCacheKey, jsonEncode(loginCacheValue?.toJson()));

          emit(EditProfileSuccess());
        });
      },
    );
  }

  Future<void> updateUserData({required BuildContext context, File? image, String? name, String? email, String? phone}) async {
    emit(UpdateProfileLoading());
    await EditProfileDataSource.updateUserData(
      data: {
        if (image != null) 'avatar': await MultipartFile.fromFile(image.path),
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        '_method': 'put',
      },
    ).then(
      (value) async {
        value.fold((l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);

          emit(UpdateProfileError(e: l.errMessage));
        }, (r) async {
          Utils.showToast(title: 'Profile updated successfully', state: UtilState.success);

          emit(UpdateProfileSuccess());
        });
      },
    );
  }
}
