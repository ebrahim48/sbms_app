import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sbms_apps/core/presentations/widgets/custom_loader.dart';
import '../../../../controllers/sales_order_list_controller.dart';
import '../../../constants/app_colors.dart';

class SalesListScreen extends StatefulWidget {
  const SalesListScreen({super.key});

  @override
  State<SalesListScreen> createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  final SalesOrderListController salesOrderListController = Get.put(SalesOrderListController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      salesOrderListController.getSalesOrderList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Sales Order List",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (salesOrderListController.salesOrderListLoading.value) {
          return const Center(child: CustomLoader());
        }

        if (salesOrderListController.salesOrderList.isEmpty) {
          return const Center(child: Text("No sales orders found"));
        }

        return Padding(
          padding: EdgeInsets.all(12.w),
          child: ListView.builder(
            itemCount: salesOrderListController.salesOrderList.length,
            itemBuilder: (context, index) {
              final data = salesOrderListController.salesOrderList[index];
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
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data.invoiceNo ?? "N/A",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: data.orderStatusText == "Confirmed"
                                ? Colors.green.shade50
                                : Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(
                              color: data.orderStatusText == "Confirmed"
                                  ? Colors.green.shade400
                                  : Colors.orange.shade400,
                            ),
                          ),
                          child: Text(
                            data.orderStatusText ?? "N/A",
                            style: TextStyle(
                              color: data.orderStatusText == "Confirmed"
                                  ? Colors.green.shade800
                                  : Colors.orange.shade800,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.h),

                    _buildInfoRow("User", data.userName ?? "N/A"),
                    _buildInfoRow("Vendor", data.dealerName ?? "N/A"),
                    _buildInfoRow("Warehouse", data.warehouseName ?? "N/A"),
                    _buildInfoRow("Order Date", data.orderDate ?? "N/A"),
                    _buildInfoRow("Created At", data.createdAt ?? "N/A"),
                    _buildInfoRow("Total Quantity", data.totalQty ?? "0"),
                    _buildInfoRow(
                      "Grand Total",
                      "৳ ${data.grandTotal ?? "0.00"}",
                      valueColor: AppColors.primaryColor,
                      bold: true,
                    ),
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