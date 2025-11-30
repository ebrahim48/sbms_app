import 'package:get/get.dart';
import '../core/models/sales_oder_list_model.dart';
import '../core/services/api_client.dart';
import '../core/services/api_constants.dart';

class SalesOrderListController extends GetxController {
  RxBool salesOrderListLoading = false.obs;
  RxList<SalesOrderListModel> salesOrderList = <SalesOrderListModel>[].obs;

  Future<void> getSalesOrderList() async {
    salesOrderListLoading.value = true;
    try {
      var response = await ApiClient.getData(ApiConstants.getSalesOrderListEndPoint);
      if (response.statusCode == 200) {
        List<dynamic> data = response.body['res']['sales_order_list_info'];
        salesOrderList.value = data.map((json) => SalesOrderListModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Sales Order List error: $e');
    } finally {
      salesOrderListLoading.value = false;
    }
  }
}