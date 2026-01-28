import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/feature/address/data/models/address_model.dart';

import '../../../../core/utils/constants.dart' hide AddressModel;
import '../models/add_address_params.dart';

import 'package:dobzz_seller/feature/address/data/models/address_state_model.dart';
import 'package:dobzz_seller/feature/address/data/models/country_model.dart';
import 'package:dobzz_seller/feature/address/data/models/address_city_model.dart';

class AddressDataSource {
  static Future<Either<Failure, AddressModel>> getAddress() async {
    try {
      final response = await DioHelper.postData(endPoint: EndPoints.address, data: {
        'theme_id': 'grocery',
        'customer_id': Constants.customerId,
      });
      if (response.data['status'] == 1) {
        // logger.d('response address: ${response.data['data']}');
        return Right(AddressModel.fromJson(response.data));
      } else {
        return Left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      log('Dio error message: $error');
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  static Future<Either<Failure, String>> deleteAddress({required int addressId}) async {
    try {
      final response = await DioHelper.postData(endPoint: EndPoints.deleteAddress, query: {
        'theme_id': 'grocery',
        'address_id': addressId.toString(),
      }, data: {});
      log('Response address: ${response.data['data']}');
      return const Right('address delete successfully');
    } catch (error) {
      log('Dio error message: $error');

      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  static Future<Either<Failure, void>> addAddress({required AddAddressParams data}) async {
    try {
      final response = await DioHelper.postData(endPoint: EndPoints.addAddress, data: data.toJson());
      if (response.data['status'] == 1) {
        return const Right(null);
      } else {
        return Left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  static Future<Either<Failure, void>> updateAddress(
      {required AddAddressParams data, required int addressId}) async {
    try {
      final parm={
        'address_id': addressId.toString(),
        ...data.toJson(),
      };
      final response = await DioHelper.postData(endPoint: '${EndPoints.updateAddress}', query: parm, data: {});
      if (response.data['status'] == 1) {
        log('Response: ${response.data['data']}');
        return const Right(null);
      } else {
        return Left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  static Future<Either<Failure, List<CountryModel>>> getCountries() async {
    try {
      final response = await DioHelper.postData(
        endPoint: EndPoints.countryList,
        query: {
          'theme_id': 'grocery',
        },
        data: {},
      );
      if (response.data['status'] == 1) {
        List<CountryModel> countries = [];
        if (response.data['data'] != null) {
          response.data['data'].forEach((v) {
            countries.add(CountryModel.fromJson(v));
          });
        }
        return Right(countries);
      } else {
        return Left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  static Future<Either<Failure, List<AddressStateModel>>> getStates({required int countryId}) async {
    try {
      final response = await DioHelper.postData(
        endPoint: EndPoints.stateList,
        query: {
          'theme_id': 'grocery',
          'country_id': countryId,
        },
        data: {},
      );
      if (response.data['status'] == 1) {
        List<AddressStateModel> states = [];
        if (response.data['data'] != null) {
          response.data['data'].forEach((v) {
            states.add(AddressStateModel.fromJson(v));
          });
        }
        return Right(states);
      } else {
        return Left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  static Future<Either<Failure, List<AddressCityModel>>> getCities({required int stateId}) async {
    try {
      final response = await DioHelper.postData(
        endPoint: EndPoints.cityList,
        data: {
          'theme_id': 'grocery',
          'state_id': stateId.toString(),
        },
      );
      if (response.data['status'] == 1) {
        List<AddressCityModel> cities = [];
        if (response.data['data'] != null) {
          response.data['data'].forEach((v) {
            cities.add(AddressCityModel.fromJson(v));
          });
        }
        return Right(cities);
      } else {
        return Left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
