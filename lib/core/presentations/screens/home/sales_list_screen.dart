import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/app_colors.dart';

class SalesListScreen extends StatefulWidget {
  const SalesListScreen({super.key});

  @override
  State<SalesListScreen> createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  final List<Map<String, dynamic>> salesData = [
    {
      "user": "25-09-2025 06:50 pm (Admin)",
      "vendor": "Abdul Malik Pharmacy",
      "warehouse": "Bogura",
      "orderDate": "25-09-2025",
      "invoice": "Sal-23",
      "totalQty": 100,
      "grandTotal": 43750.00,
      "status": "Confirmed",
    },
    {
      "user": "25-09-2025 01:01 pm (Admin)",
      "vendor": "Abdul Malik Pharmacy",
      "warehouse": "Bogura",
      "orderDate": "25-09-2025",
      "invoice": "Sal-22",
      "totalQty": 30,
      "grandTotal": 15092.00,
      "status": "Confirmed",
    },
  ];

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
      body: Padding(
        padding: EdgeInsets.all(12.w),
        child: ListView.builder(
          itemCount: salesData.length,
          itemBuilder: (context, index) {
            final data = salesData[index];
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
                        data["invoice"],
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
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(color: Colors.green.shade400),
                        ),
                        child: Text(
                          data["status"],
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  _buildInfoRow("User", data["user"]),
                  _buildInfoRow("Vendor", data["vendor"]),
                  _buildInfoRow("Warehouse", data["warehouse"]),
                  _buildInfoRow("Order Date", data["orderDate"]),
                  _buildInfoRow("Total Quantity", data["totalQty"].toString()),
                  _buildInfoRow(
                    "Grand Total",
                    "৳ ${data["grandTotal"].toStringAsFixed(2)}",
                    valueColor: AppColors.primaryColor,
                    bold: true,
                  ),
                ],
              ),
            );
          },
        ),
      ),
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
