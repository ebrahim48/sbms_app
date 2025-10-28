import 'package:get/get.dart';

import '../core/models/dealer_info_model.dart';
import '../core/models/product_list_model.dart';
import '../core/services/api_client.dart';
import '../core/services/api_constants.dart';



class ProductListController extends GetxController {

  RxBool productListLoading = false.obs;
  Rx<ProductListModel> productList = Rx<ProductListModel>(ProductListModel());

  Future<void> getProductList() async {
    productListLoading.value = true;
    try {
      var response = await ApiClient.getData(ApiConstants.getProductListEndPoint);
      if (response.statusCode == 200) {
        productList.value = ProductListModel.fromJson(response.body['res']);
      }
    } catch (e) {
      print('Product List error: $e');
    } finally {
      productListLoading.value = false;
    }
  }





  RxBool dealerListLoading = false.obs;
  Rx<DealerInfoModel> dealerList = Rx<DealerInfoModel>(DealerInfoModel());

  Future<void> getDealerList() async {
    dealerListLoading.value = true;
    try {
      var response = await ApiClient.getData(ApiConstants.getDealerListEndPoint);
      if (response.statusCode == 200) {
        productList.value = ProductListModel.fromJson(response.body['res']);
      }
    } catch (e) {
      print('Product List error: $e');
    } finally {
      dealerListLoading.value = false;
    }
  }




}



