import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sbms_apps/core/config/app_routes/app_routes.dart';

import '../core/helpers/toast_message_helper.dart';
import '../core/models/dealer_info_model.dart';
import '../core/models/invoice_number_model.dart';
import '../core/models/product_list_model.dart';
import '../core/models/product_wise_model.dart';
import '../core/models/warehouselist_model.dart';
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
        dealerList.value = DealerInfoModel.fromJson(response.body['res']);
      }
    } catch (e) {
      print('Product List error: $e');
    } finally {
      dealerListLoading.value = false;
    }
  }






  RxBool wareHoseListLoading = false.obs;
  Rx<WareHouseListModel> wareHouseList = Rx<WareHouseListModel>(WareHouseListModel());

  Future<void> getWareHouseList() async {
    wareHoseListLoading.value = true;
    try {
      var response = await ApiClient.getData(ApiConstants.getWareHouseListEndPoint);
      if (response.statusCode == 200) {
        wareHouseList.value = WareHouseListModel.fromJson(response.body['res']);
      }
    } catch (e) {
      print('WareHouse List error: $e');
    } finally {
      wareHoseListLoading.value = false;
    }
  }



  RxBool productWisePriceLoading = false.obs;
  Rx<ProductWisePricetModel> productWisePrice = Rx<ProductWisePricetModel>(ProductWisePricetModel());
  
  // Map to store price information for each product ID
  final Map<int, ProductWisePricetModel> productPriceMap = {};
  
  // Loading state for specific product prices
  final Map<int, RxBool> productPriceLoadingMap = {};

  Future<void> getProductWisePrice({int? productId}) async {
    productWisePriceLoading.value = true;
    try {
      // Use the provided product ID, default to 1 if not provided
      String endpoint = productId != null ? "/api/v2/get-product-wise-price-info/$productId" : ApiConstants.getProductWiseEndPoint;
      var response = await ApiClient.getData(endpoint);
      if (response.statusCode == 200) {
        productWisePrice.value = ProductWisePricetModel.fromJson(response.body['res']);
      }
    } catch (e) {
      print('ProductWise Price error: $e');
    } finally {
      productWisePriceLoading.value = false;
    }
  }
  
  // New method to get product-wise price for a specific product ID
  Future<ProductWisePricetModel> getProductWisePriceForProduct(int productId) async {
    // Check if we already have the price in the map
    if (productPriceMap.containsKey(productId)) {
      return productPriceMap[productId]!;
    }
    
    // Mark as loading
    productPriceLoadingMap[productId] ??= false.obs;
    productPriceLoadingMap[productId]!.value = true;
    
    try {
      String endpoint = "/api/v2/get-product-wise-price-info/$productId";
      var response = await ApiClient.getData(endpoint);
      if (response.statusCode == 200) {
        var priceModel = ProductWisePricetModel.fromJson(response.body['res']);
        // Cache the price information
        productPriceMap[productId] = priceModel;
        return priceModel;
      }
    } catch (e) {
      print('ProductWise Price error for product $productId: $e');
    } finally {
      // Mark as not loading
      if (productPriceLoadingMap.containsKey(productId)) {
        productPriceLoadingMap[productId]!.value = false;
      }
    }
    return ProductWisePricetModel();
  }
  
  // Method to clear all cached prices
  void clearProductPriceCache() {
    productPriceMap.clear();
    // Clear loading states too
    productPriceLoadingMap.clear();
  }
  
  // Method to get loading state for a specific product
  bool isProductPriceLoading(int productId) {
    if (productPriceLoadingMap.containsKey(productId)) {
      return productPriceLoadingMap[productId]!.value;
    }
    return false;
  }




  RxBool orderInvoiceNumberLoading = false.obs;
  Rx<InvoiceNumberModel> invoiceNumber = Rx<InvoiceNumberModel>(InvoiceNumberModel());

  Future<void> getOrderInvoice() async {
    orderInvoiceNumberLoading.value = true;
    try {
      var response = await ApiClient.getData(ApiConstants.getInvoiceNumberEndPoint);
      if (response.statusCode == 200) {
        invoiceNumber.value = InvoiceNumberModel.fromJson(response.body['res']);
      }
    } catch (e) {
      print('Invoice Number error: $e');
    } finally {
      orderInvoiceNumberLoading.value = false;
    }
  }




  var orderLoading = false.obs;

  Future<bool> orderCreateInfo({
    required String date,
    required int? dealerId,
    required String invoiceNo,
    required int? warehouseId,
    required List<int> productId,
    required List<int> price,
    required List<int> quantity,
    required List<int> totalPrice,
    required int grandTotalQty,
    required int grandTotalPayableAmount,
    required List<int> totalAmount,
    String? narration,
    required BuildContext context,
  }) async {
    var body = {
      "date": date,
      "dealer_id": dealerId,
      "invoice_no": invoiceNo,
      "warehouse_id": warehouseId,
      "product_id": productId,
      "price": price,
      "quantity": quantity,
      "total_price": totalPrice,
      "grand_total_qty": grandTotalQty,
      "garnd_total_payable_amount": grandTotalPayableAmount,
      "narration": narration ?? "",
      "total_amount": totalAmount,
    };

    orderLoading(true);

    try {
      var response = await ApiClient.postData(
        ApiConstants.orderCreateEndPoint,
        body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ToastMessageHelper.showToastMessage("${response.body['msg']}",title: 'Success');
        context.pushNamed(AppRoutes.salesListScreen);
        return true;
      } else {
        ToastMessageHelper.showToastMessage("Order creation failed!");
        return false;
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Something went wrong: $e");
      return false;
    } finally {
      orderLoading(false);
    }
  }






}



