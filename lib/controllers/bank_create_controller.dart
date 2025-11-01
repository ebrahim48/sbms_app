import 'package:get/get.dart';
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

  Future<void> getInvoiceList() async {
    invoiceListLoading.value = true;
    try {
      var response = await ApiClient.getData(ApiConstants.getDealerInvoiceListEndPoint);
      if (response.statusCode == 200) {
        List<dynamic> data = response.body['res']['invoice_info'];
        invoiceList.value = data.map((json) => InvoiceListModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Invoice List error: $e');
    } finally {
      invoiceListLoading.value = false;
    }
  }





}