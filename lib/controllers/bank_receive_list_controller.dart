


// import 'package:get/get.dart';
// import '../core/helpers/prefs_helper.dart';
// import '../core/app_constants/app_constants.dart';
// import '../core/models/bank_receive_list_model.dart';
// import '../core/services/api_client.dart';
// import '../core/services/api_constants.dart';
//
// class BankReceiveListController extends GetxController {
//   RxBool bankReceiveListLoading = false.obs;
//   RxList<BankReceiveListModel> bankReceiveList = <BankReceiveListModel>[].obs;
//
//   Future<void> getBankReceiveList() async {
//     bankReceiveListLoading.value = true;
//     try {
//       // Get logged in user ID
//       int? userId = await PrefsHelper.getInt(AppConstants.userId);
//
//       // Build endpoint with user_id
//       String endpoint = userId != null
//           ? "${ApiConstants.getBankReceiveListEndPoint}/$userId"
//           : ApiConstants.getBankReceiveListEndPoint;
//
//       var response = await ApiClient.getData(endpoint);
//
//       if (response.statusCode == 200) {
//         // Check if 'res' exists and has data
//         if (response.body['res'] != null && response.body['res']['payment_receive_list_info'] != null) {
//           List<dynamic> data = response.body['res']['payment_receive_list_info'];
//           bankReceiveList.value = data.map((json) => BankReceiveListModel.fromJson(json)).toList();
//         } else {
//           // No data found
//           bankReceiveList.value = [];
//           print('No bank receive data found');
//         }
//       } else if (response.statusCode == 404) {
//         // Handle 404 - No data found
//         bankReceiveList.value = [];
//         print('No bank receive data found for this user');
//       }
//     } catch (e) {
//       print('Bank Receive List error: $e');
//       bankReceiveList.value = [];
//     } finally {
//       bankReceiveListLoading.value = false;
//     }
//   }
// }


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