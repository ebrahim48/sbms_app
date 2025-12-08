import 'package:get/get.dart';
import '../core/models/sales_invoice_list_model.dart';
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


  RxBool salesInvoiceListLoading = false.obs;
  var currentSalesInvoice = Rxn<SalesInvoiceListModel>();

  Future<SalesInvoiceListModel?> getSalesInvoiceList(String invoiceNo) async {
    salesInvoiceListLoading.value = true;
    try {
      var response = await ApiClient.getData(ApiConstants.getSalesInvoiceListEndPoint(invoiceNo));
      if (response.statusCode == 200) {
        // The response is a single object, not a list
        SalesInvoiceListModel invoiceData = SalesInvoiceListModel.fromJson(response.body['res']);
        currentSalesInvoice.value = invoiceData;
        return invoiceData;
      } else {
        print('Sales Invoice List error: ${response.statusText}');
        return null;
      }
    } catch (e) {
      print('Sales Invoice List error: $e');
      return null;
    } finally {
      salesInvoiceListLoading.value = false;
    }
  }
}