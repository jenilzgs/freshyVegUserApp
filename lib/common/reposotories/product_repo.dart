import 'package:dio/dio.dart';
import 'package:flutter_grocery/common/enums/data_source_enum.dart';
import 'package:flutter_grocery/common/enums/product_filter_type_enum.dart';
import 'package:flutter_grocery/common/reposotories/data_sync_repo.dart';
import 'package:flutter_grocery/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/utill/product_type.dart';
import 'package:flutter_grocery/utill/app_constants.dart';

class ProductRepo extends DataSyncRepo {

  ProductRepo({required super.dioClient, required super.sharedPreferences});

  Future<ApiResponseModel<T>> getAllProductList<T>(int? offset, ProductFilterType type, {required DataSourceEnum source}) async {

    return  await fetchData<T>('${AppConstants.allProductList}?limit=10&offset=$offset&sort_by=${type.name}', source);
  }


  Future<ApiResponseModel<T>> getItemList<T>(int offset, String? productType, {required DataSourceEnum source}) async {
    String? apiUrl;

    if(productType == ProductType.featuredItem){
      apiUrl = AppConstants.featuredProduct;
    }else if(productType == ProductType.dailyItem){
      apiUrl = AppConstants.dailyItemUri;
    } else if(productType == ProductType.mostReviewed){
      apiUrl = AppConstants.mostReviewedProduct;
    }
    return  await fetchData<T>('$apiUrl?limit=10&&offset=$offset', source);

  }

  Future<ApiResponseModel> getProductDetails(String productID, bool searchQuery) async {
    try {
      String params = productID;
      if(searchQuery) {
        params = '$productID?attribute=product';
      }
      final response = await dioClient.get('${AppConstants.productDetailsUri}$params');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> searchProduct(String productId, String languageCode) async {
    try {
      final response = await dioClient.get(
        '${AppConstants.searchProductUri}$productId',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getBrandOrCategoryProductList(String id) async {
    try {
      final response = await dioClient.get('${AppConstants.categoryProductUri}$id');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel<T>> getFlashDeal<T>({required int offset, required DataSourceEnum source}) async {
    return await fetchData<T>(
        '${AppConstants.flashDealUri}?limit=10&&offset=$offset', source);
  }
}
