import 'package:get/get.dart';

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



}



