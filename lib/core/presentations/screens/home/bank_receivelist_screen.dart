import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sbms_apps/core/presentations/widgets/custom_loader.dart';
import '../../../../controllers/bank_receive_list_controller.dart';
import '../../../../controllers/sales_order_list_controller.dart';
import '../../../constants/app_colors.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class BankReceiveListScreen extends StatefulWidget {
  const BankReceiveListScreen({super.key});

  @override
  State<BankReceiveListScreen> createState() => _BankReceiveListScreenState();
}

class _BankReceiveListScreenState extends State<BankReceiveListScreen> {
  final BankReceiveListController bankReceiveListController = Get.put(BankReceiveListController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bankReceiveListController.getBankReceiveList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Bank Receive List",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (bankReceiveListController.bankReceiveListLoading.value) {
          return const Center(child: CustomLoader());
        }

        if (bankReceiveListController.bankReceiveList.isEmpty) {
          return const Center(child: Text("No Bank Receive found"));
        }

        return Padding(
          padding: EdgeInsets.all(12.w),
          child: ListView.builder(
            itemCount: bankReceiveListController.bankReceiveList.length,
            itemBuilder: (context, index) {
              final data = bankReceiveListController.bankReceiveList[index];
              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: 10.h),

                    _buildInfoRow("User Name", data.userName ?? "N/A"),
                    _buildInfoRow("Created At",
                        data.createdAt != null
                            ? DateFormat('yyyy-MM-dd HH:mm:ss').format(data.createdAt!)
                            : "N/A"
                    ),
                    _buildInfoRow("Bank Name", data.bankName ?? "N/A"),
                    _buildInfoRow("Ds Name", data.dSName ?? "N/A"),
                    _buildInfoRow("Payment Date",
                        data.paymentDate != null
                            ? DateFormat('yyyy-MM-dd').format(data.paymentDate!)
                            : "N/A"
                    ),
                    _buildInfoRow("Invoice", data.invoice ?? "N/A"),
                    _buildInfoRow("Amount", data.amount ?? "N/A"),

                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {Color? valueColor, bool bold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110.w,
            child: Text(
              "$label:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.w500,
                fontSize: 12.sp,
                color: valueColor ?? Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}