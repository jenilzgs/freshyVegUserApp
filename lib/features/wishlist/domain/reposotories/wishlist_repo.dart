import 'package:flutter_grocery/common/enums/data_source_enum.dart';
import 'package:flutter_grocery/common/reposotories/data_sync_repo.dart';
import 'package:flutter_grocery/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/utill/app_constants.dart';


class WishListRepo extends DataSyncRepo {

  WishListRepo({required super.dioClient, required super.sharedPreferences});

  Future<ApiResponseModel<T>> getWishList<T>({required DataSourceEnum source}) async {
    return await fetchData<T>(AppConstants.wishListUri, source);
  }

  Future<ApiResponseModel> addWishList(List<int?> productID) async {
    try {
      final response = await dioClient.post(AppConstants.wishListUri, data: {'product_ids' : productID});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> removeWishList(List<int?> productID) async {
    try {
      final response = await dioClient.delete(AppConstants.wishListUri, data: {'product_ids' : productID, '_method':'delete'});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
