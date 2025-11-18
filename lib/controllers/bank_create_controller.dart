import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../core/config/app_routes/app_routes.dart';
import '../core/helpers/toast_message_helper.dart';
import '../core/models/bank_list_model.dart';
import '../core/models/category_model.dart';
import '../core/models/invoice_list_model.dart';
import '../core/services/api_client.dart';
import '../core/services/api_constants.dart';

class BankListController extends GetxController {


  RxBool bankListLoading = false.obs;
  RxList<BankListModel> bankList = <BankListModel>[].obs;

  Future<void> getBankList() async {
    bankListLoading.value = true;
    try {
      var response = await ApiClient.getData(ApiConstants.getBankListEndPoint);
      if (response.statusCode == 200) {
        List<dynamic> data = response.body['res']['bank_info'];
        bankList.value = data.map((json) => BankListModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Bank List error: $e');
    } finally {
      bankListLoading.value = false;
    }
  }






  RxBool categoryListLoading = false.obs;
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;

  Future<void> getCategoryList() async {
    categoryListLoading.value = true;
    try {
      var response = await ApiClient.getData(ApiConstants.getCategoryListEndPoint);
      if (response.statusCode == 200) {
        List<dynamic> data = response.body['res']['category_info'];
        categoryList.value = data.map((json) => CategoryModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Category List error: $e');
    } finally {
      categoryListLoading.value = false;
    }
  }


  RxBool invoiceListLoading = false.obs;
  RxList<InvoiceListModel> invoiceList = <InvoiceListModel>[].obs;

  Future<void> getInvoiceList({int? dealerId}) async {
    invoiceListLoading.value = true;
    try {
      // Build endpoint with dealer ID if provided
      String endpoint = dealerId != null
          ? '${ApiConstants.getDealerInvoiceListEndPoint}/$dealerId'
          : ApiConstants.getDealerInvoiceListEndPoint;

      print("Fetching invoices from: $endpoint");

      var response = await ApiClient.getData(endpoint);
      if (response.statusCode == 200) {
        List<dynamic> data = response.body['res']['invoice_info'];
        invoiceList.value = data.map((json) => InvoiceListModel.fromJson(json)).toList();

        print("✅ Loaded ${invoiceList.length} invoices");
      }
    } catch (e) {
      print('Invoice List error: $e');
      invoiceList.value = []; // Clear list on error
    } finally {
      invoiceListLoading.value = false;
    }
  }


  var bankReceiveLoading = false.obs;

  Future<bool> bankReceiveStore({
    required String paymentDate,
    required List<int> dealerId,
    required List<int> bankId,
    required List<int> categoryId,
    required List<String> balanceType,
    required List<String> salesInvoice,
    required List<int> bankCharge,
    required List<int> amount,
    String? paymentDescription,
    required BuildContext context,
  }) async {
    var body = {
      "payment_date": paymentDate,
      "dealer_id": dealerId,
      "bank_id": bankId,
      "category_id": categoryId,
      "balance_type": balanceType,
      "sales_invoice": salesInvoice,
      "bank_charge": bankCharge,
      "amount": amount,
      "payment_description": paymentDescription,
    };

    bankReceiveLoading(true);

    try {
      var response = await ApiClient.postData(
        ApiConstants.bankReceiveEndPoint,
        body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ToastMessageHelper.showToastMessage("${response.body['msg']}", title: 'Success');
        context.pushNamed(AppRoutes.bankReceiveListScreen);
        return true;
      } else {
        ToastMessageHelper.showToastMessage("Bank Receive failed!");
        return false;
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Something went wrong: $e");
      return false;
    } finally {
      bankReceiveLoading(false);
    }
  }






}