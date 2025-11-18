import 'package:get/get.dart';
import '../core/models/bank_receive_list_model.dart';
import '../core/services/api_client.dart';
import '../core/services/api_constants.dart';

class BankReceiveListController extends GetxController {
  RxBool bankReceiveListLoading = false.obs;
  RxList<BankReceiveListModel> bankReceiveList = <BankReceiveListModel>[].obs;

  Future<void> getBankReceiveList() async {
    bankReceiveListLoading.value = true;
    try {
      var response = await ApiClient.getData(ApiConstants.getBankReceiveListEndPoint);
      if (response.statusCode == 200) {
        List<dynamic> data = response.body['res']['payment_receive_list_info'];
        bankReceiveList.value = data.map((json) => BankReceiveListModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Bank Receive List error: $e');
    } finally {
      bankReceiveListLoading.value = false;
    }
  }
}