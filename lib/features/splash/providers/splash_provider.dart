import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_grocery/common/enums/data_source_enum.dart';
import 'package:flutter_grocery/common/enums/html_type_enum.dart';
import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/models/delivery_info_model.dart';
import 'package:flutter_grocery/data/datasource/local/cache_response.dart';
import 'package:flutter_grocery/features/address/screens/address_list_screen.dart';
import 'package:flutter_grocery/features/cart/screens/cart_screen.dart';
import 'package:flutter_grocery/features/category/screens/all_categories_screen.dart';
import 'package:flutter_grocery/features/chat/screens/chat_screen.dart';
import 'package:flutter_grocery/features/coupon/screens/coupon_screen.dart';
import 'package:flutter_grocery/features/home/screens/home_screens.dart';
import 'package:flutter_grocery/features/html/screens/html_viewer_screen.dart';
import 'package:flutter_grocery/features/menu/domain/models/main_screen_model.dart';
import 'package:flutter_grocery/features/menu/screens/setting_screen.dart';
import 'package:flutter_grocery/features/order/domain/models/offline_payment_model.dart';
import 'package:flutter_grocery/features/order/screens/order_list_screen.dart';
import 'package:flutter_grocery/features/order/screens/order_search_screen.dart';
import 'package:flutter_grocery/features/splash/domain/reposotories/splash_repo.dart';
import 'package:flutter_grocery/features/wallet_and_loyalty/screens/loyalty_screen.dart';
import 'package:flutter_grocery/features/wallet_and_loyalty/screens/wallet_screen.dart';
import 'package:flutter_grocery/features/wishlist/screens/wishlist_screen.dart';
import 'package:flutter_grocery/helper/api_checker_helper.dart';
import 'package:flutter_grocery/helper/data_sync_helper.dart';
import 'package:flutter_grocery/helper/maintenance_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashProvider extends ChangeNotifier  {
  final SplashRepo? splashRepo;
  SplashProvider({required this.splashRepo});

  ConfigModel? _configModel;
  List<DeliveryInfoModel>? _deliveryInfoModelList;
  BaseUrls? _baseUrls;
  int _pageIndex = 0;
  bool _fromSetting = false;
  bool _firstTimeConnectionCheck = true;
  bool _cookiesShow = true;
  List<OfflinePaymentModel?>? _offlinePaymentModelList;
  List<MainScreenModel> _screenList = [];



  List<MainScreenModel> get screenList => _screenList;
  ConfigModel? get configModel => _configModel;
  List<DeliveryInfoModel>? get deliveryInfoModelList => _deliveryInfoModelList;
  BaseUrls? get baseUrls => _baseUrls;
  int get pageIndex => _pageIndex;
  bool get fromSetting => _fromSetting;
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;
  bool get cookiesShow => _cookiesShow;
  List<OfflinePaymentModel?>? get offlinePaymentModelList => _offlinePaymentModelList;


  bool _isFingerprintOn = false;

  bool get isFingerprintOn => _isFingerprintOn;

  set isFingerprintOn(bool value) {
    _isFingerprintOn = value;
    notifyListeners();
  }

  Future<void> loadSwitchValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isFingerprintOn = prefs.getInt('fingerprint_enabled') == 1;
    notifyListeners(); // optionally notify when loading from prefs too
  }

  void _startTimer (DateTime startTime){
    Timer.periodic(const Duration(seconds: 30), (Timer timer){

      DateTime now = DateTime.now();

      if (now.isAfter(startTime) || now.isAtSameMomentAs(startTime)) {
        timer.cancel();
        Navigator.pushNamedAndRemoveUntil(Get.context!, RouteHelper.getMainRoute(), (route) => false);
      }

    });
  }

  Future<ConfigModel?> initConfig({bool fromNotification = false, DataSourceEnum source = DataSourceEnum.local}) async {
    if(source == DataSourceEnum.local) {
      ApiResponseModel<CacheResponseData> responseModel =  await splashRepo!.getConfig(source: DataSourceEnum.local);

      if(responseModel.isSuccess) {

        _configModel = ConfigModel.fromJson(jsonDecode(responseModel.response!.response));
        _baseUrls = _configModel?.baseUrls;
        _onConfigAction(fromNotification);

      }

      initConfig(fromNotification: fromNotification, source:  DataSourceEnum.client);


    }else {
      ApiResponseModel<Response> apiResponseModel = await splashRepo!.getConfig(source: DataSourceEnum.client);

      if(apiResponseModel.isSuccess) {
        _configModel = ConfigModel.fromJson(apiResponseModel.response?.data);
        _baseUrls = _configModel?.baseUrls;

        await _onConfigAction(fromNotification);


      }
    }



    return _configModel;
  }

  Future<void> _onConfigAction(bool fromNotification) async {
    if (_configModel != null) {



      if(!MaintenanceHelper.isMaintenanceModeEnable(configModel)){
        if(MaintenanceHelper.checkWebMaintenanceMode(configModel) || MaintenanceHelper.checkCustomerMaintenanceMode(configModel)){
          if(MaintenanceHelper.isCustomizeMaintenance(configModel)){

            DateTime now = DateTime.now();
            DateTime specifiedDateTime = DateTime.parse(_configModel!.maintenanceMode!.maintenanceTypeAndDuration!.startDate!);

            Duration difference = specifiedDateTime.difference(now);

            if(difference.inMinutes > 0 && (difference.inMinutes < 60 || difference.inMinutes == 60)){
              _startTimer(specifiedDateTime);
            }

          }
        }
      }

      if(fromNotification){
        print('--------------(Config)-------$fromNotification');
        print('--------------(Config)-------${MaintenanceHelper.isMaintenanceModeEnable(configModel)}');
        print('--------------(Config Current Route)---------${ModalRoute.of(Get.context!)?.settings.name}');
        if(MaintenanceHelper.isMaintenanceModeEnable(configModel) && (MaintenanceHelper.checkCustomerMaintenanceMode(configModel) || MaintenanceHelper.checkWebMaintenanceMode(configModel))) {
          Navigator.pushNamedAndRemoveUntil(Get.context!, RouteHelper.getMaintenanceRoute(), (route) => false);
        }else if (!MaintenanceHelper.isMaintenanceModeEnable(configModel) && ModalRoute.of(Get.context!)?.settings.name == RouteHelper.maintenance){
          Navigator.pushNamedAndRemoveUntil(Get.context!, RouteHelper.getMainRoute(), (route) => false);
        }
      }


      if(Get.context != null) {
        final AuthProvider authProvider = Provider.of<AuthProvider>(Get.context!, listen: false);

        if(authProvider.getGuestId() == null && !authProvider.isLoggedIn()){
          authProvider.addOrUpdateGuest();
        }
      }


      if(!kIsWeb) {
        if(!Provider.of<AuthProvider>(Get.context!, listen: false).isLoggedIn()){
         await Provider.of<AuthProvider>(Get.context!, listen: false).updateFirebaseToken();
        }
      }
      initializeScreenList();



      notifyListeners();
    }
  }


  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  void setPageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  Future<bool> initSharedData() {
    return splashRepo!.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashRepo!.removeSharedData();
  }

  void setFromSetting(bool isSetting) {
    _fromSetting = isSetting;
  }
  String? getLanguageCode(){
    return splashRepo!.sharedPreferences!.getString(AppConstants.languageCode);
  }

  bool showIntro() {
    return splashRepo!.showIntro();
  }

  void disableIntro() {
    splashRepo!.disableIntro();
  }

  void cookiesStatusChange(String? data) {
    if(data != null){
      splashRepo!.sharedPreferences!.setString(AppConstants.cookingManagement, data);
    }
    _cookiesShow = false;
    notifyListeners();
  }

  bool getAcceptCookiesStatus(String? data) => splashRepo!.sharedPreferences!.getString(AppConstants.cookingManagement) != null
      && splashRepo!.sharedPreferences!.getString(AppConstants.cookingManagement) == data;

  Future<void> getOfflinePaymentMethod(bool isReload) async {
    if(_offlinePaymentModelList == null || isReload){
      _offlinePaymentModelList = null;
    }
    if(_offlinePaymentModelList == null){
      ApiResponseModel apiResponse = await splashRepo!.getOfflinePaymentMethod();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _offlinePaymentModelList = [];

        apiResponse.response?.data.forEach((v) {
          _offlinePaymentModelList?.add(OfflinePaymentModel.fromJson(v));
        });

      } else {
        ApiCheckerHelper.checkApi(apiResponse);
      }
      notifyListeners();
    }

  }

  Future<void> getDeliveryInfo() async{
    DataSyncHelper.fetchAndSyncData(
      fetchFromLocal: ()=> splashRepo!.getDeliveryInfo<CacheResponseData>(source: DataSourceEnum.local),
      fetchFromClient: ()=> splashRepo!.getDeliveryInfo(source: DataSourceEnum.client),
      onResponse: (data, _){
        _deliveryInfoModelList = [];

        data.forEach((deliveryInfo) {
          _deliveryInfoModelList?.add(DeliveryInfoModel.fromJson(deliveryInfo));
        });
        notifyListeners();
      },
    );

  }

  void initializeScreenList() {

    _screenList = [
      MainScreenModel(const HomeScreen(), 'home', Images.home),
      MainScreenModel(const AllCategoriesScreen(), 'all_categories', Images.list),
      MainScreenModel(const CartScreen(), 'shopping_bag', Images.orderBag),
      MainScreenModel(const WishListScreen(), 'favourite', Images.favouriteIcon),
      MainScreenModel(const OrderListScreen(), 'my_order', Images.orderList),
      MainScreenModel(const OrderSearchScreen(), 'track_order', Images.orderDetails),
      MainScreenModel(const AddressListScreen(), 'address', Images.location),
      MainScreenModel(const CouponScreen(), 'coupon', Images.coupon),
      MainScreenModel(const ChatScreen(orderModel: null), 'live_chat', Images.chat),
      MainScreenModel(const SettingsScreen(), 'settings', Images.settings),
      if (_configModel?.walletStatus ?? false)
        MainScreenModel(const WalletScreen(), 'wallet', Images.wallet),
      if (_configModel?.loyaltyPointStatus ?? false)
        MainScreenModel(const LoyaltyScreen(), 'loyalty_point', Images.loyaltyIcon),
      MainScreenModel(const HtmlViewerScreen(htmlType: HtmlType.termsAndCondition), 'terms_and_condition', Images.termsAndConditions),
      MainScreenModel(const HtmlViewerScreen(htmlType: HtmlType.privacyPolicy), 'privacy_policy', Images.privacyPolicy),
      MainScreenModel(const HtmlViewerScreen(htmlType: HtmlType.aboutUs), 'about_us', Images.aboutUs),
      if (_configModel?.returnPolicyStatus ?? false)
        MainScreenModel(const HtmlViewerScreen(htmlType: HtmlType.returnPolicy), 'return_policy', Images.returnPolicy),
      if (_configModel?.refundPolicyStatus ?? false)
        MainScreenModel(const HtmlViewerScreen(htmlType: HtmlType.refundPolicy), 'refund_policy', Images.refundPolicy),
      if (_configModel?.cancellationPolicyStatus ?? false)
        MainScreenModel(const HtmlViewerScreen(htmlType: HtmlType.cancellationPolicy), 'cancellation_policy', Images.cancellationPolicy),
      MainScreenModel(const HtmlViewerScreen(htmlType: HtmlType.faq), 'faq', Images.faq),
    ];
  }

}