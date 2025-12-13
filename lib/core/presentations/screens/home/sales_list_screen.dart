import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sbms_apps/core/presentations/widgets/custom_loader.dart';
import '../../../../controllers/sales_order_list_controller.dart';
import '../../../constants/app_colors.dart';
import '../../widgets/custom_text.dart';
import '../../../models/sales_invoice_list_model.dart';

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
          "Order List",
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
                        SizedBox(width: 12,),
                        InkWell(
                          onTap: () => _showInvoiceDetails(data.invoiceNo ?? ""),
                          child: CustomText(text: 'View',
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor1A1A1A,),
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
                    _buildInfoRow("Created At", _extractTimeOnly(data.createdAt) ?? "N/A"),
                    _buildInfoRow("Total Quantity", (data.totalQty != null && data.totalQty!.isNotEmpty) ? data.totalQty! : "0"),
                    _buildInfoRow("Total Discount", (data.totalDiscount != null && data.totalDiscount!.isNotEmpty) ? data.totalDiscount! : "N/A"),
                    _buildInfoRow("Total Bonus", (data.totalBonus != null && data.totalBonus!.isNotEmpty) ? data.totalBonus! : "N/A"),
                    _buildInfoRow("Dealer Type", data.dealerType?.toString() ?? "N/A"),
                    _buildInfoRow("Dealer Duration", "${data.dealerCreditDuration?.toString() ?? "N/A"} days"),
                    _buildInfoRow("Narration", (data.narration != null && data.narration!.isNotEmpty) ? data.narration! : "N/A"),
                    _buildInfoRow(
                      "Grand Total",
                      "৳ ${data.grandTotal != null && data.grandTotal!.isNotEmpty ? data.grandTotal! : "0.00"}",
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

  // Method to extract time only from datetime string
  String? _extractTimeOnly(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return null;

    // Handle different datetime formats, including AM/PM format
    try {
      // If it's in a format with AM/PM, extract the time part
      if (dateTimeString.contains(RegExp(r'\d{2}:\d{2}\s?(AM|PM|am|pm)'))) {
        // Extract time with AM/PM using regex
        RegExp regExp = RegExp(r'(\d{1,2}:\d{2}\s*(AM|PM|am|pm))');
        Match? match = regExp.firstMatch(dateTimeString);
        if (match != null) {
          return match.group(0)?.trim();
        }
      }
      // Try to parse as regular datetime string
      else {
        DateTime dateTime = DateTime.parse(dateTimeString);
        // Extract only the time part in HH:MM format
        String timeOnly = "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
        return timeOnly;
      }
    } catch (e) {
      // If parsing fails, try extracting time using regex as fallback
      try {
        // Try to find any time pattern in the string
        RegExp regExp = RegExp(r'(\d{1,2}:\d{2}(:\d{2})?\s*(AM|PM|am|pm)?)');
        Match? match = regExp.firstMatch(dateTimeString);
        if (match != null) {
          return match.group(0)?.trim();
        }
      } catch (e2) {
        // If all attempts fail, return original
      }
    }

    // If all attempts fail, return original string
    return dateTimeString;
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

  Future<void> _showInvoiceDetails(String invoiceNo) async {
    // Show a loading dialog while fetching data
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomLoader(),
              SizedBox(width: 16.w),
              const Text("Loading invoice details..."),
            ],
          ),
        );
      },
    );

    // Fetch the invoice details
    final invoiceData = await salesOrderListController.getSalesInvoiceList(invoiceNo);

    // Close the loading dialog
    Navigator.of(context).pop();

    if (invoiceData != null) {
      // Show the invoice details popup
      _showInvoiceDetailsPopup(invoiceData);
    } else {
      // Show error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Could not load invoice details."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  void _showInvoiceDetailsPopup(SalesInvoiceListModel invoiceData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Invoice Details - ${invoiceData.invoice?.invoiceNo ?? 'N/A'}"),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company Information
                  Text(
                    "Company Information",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  _buildPopupInfoRow("Name", invoiceData.company?.name ?? "N/A"),
                  _buildPopupInfoRow("Address", invoiceData.company?.address ?? "N/A"),
                  _buildPopupInfoRow("Phone", invoiceData.company?.phone ?? "N/A"),
                  _buildPopupInfoRow("Email", invoiceData.company?.email ?? "N/A"),
                  SizedBox(height: 16.h),

                  // Invoice Information
                  Text(
                    "Invoice Information",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  _buildPopupInfoRow("Invoice No", invoiceData.invoice?.invoiceNo ?? "N/A"),
                  _buildPopupInfoRow("Invoice Date", invoiceData.invoice?.invoiceDate ?? "N/A"),
                  _buildPopupInfoRow("Item Type", invoiceData.invoice?.itemType ?? "N/A"),
                  _buildPopupInfoRow("Transport Cost", invoiceData.invoice?.transportCost?.toString() ?? "N/A"),
                  _buildPopupInfoRow("Narration", invoiceData.invoice?.narration ?? "N/A"),
                  _buildPopupInfoRow("Created By", invoiceData.invoice?.createdBy ?? "N/A"),
                  _buildPopupInfoRow("Current Time", invoiceData.invoice?.currentTime ?? "N/A"),
                  SizedBox(height: 16.h),

                  // Dealer Information
                  Text(
                    "Dealer Information",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  _buildPopupInfoRow("Name", invoiceData.dealer?.name ?? "N/A"),
                  _buildPopupInfoRow("Code", invoiceData.dealer?.code ?? "N/A"),
                  _buildPopupInfoRow("Type", invoiceData.dealer?.type ?? "N/A"),
                  _buildPopupInfoRow("Address", invoiceData.dealer?.address ?? "N/A"),
                  _buildPopupInfoRow("Warehouse", invoiceData.dealer?.warehouse ?? "N/A"),
                  _buildPopupInfoRow("Territory", invoiceData.dealer?.territory ?? "N/A"),
                  _buildPopupInfoRow("Employee", invoiceData.dealer?.employee ?? "N/A"),
                  _buildPopupInfoRow("Dealer Duration", "${invoiceData.dealer?.dealerCreditDuration?.toString() ?? "N/A"} Days"),
                  SizedBox(height: 16.h),

                  // Financial Information
                  Text(
                    "Financial Information",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  _buildPopupInfoRow("Opening Balance", invoiceData.financial?.openingBalance ?? "N/A"),
                  _buildPopupInfoRow("Current Invoice Value", invoiceData.financial?.currentInvoiceValue ?? "N/A"),
                  _buildPopupInfoRow("Current Balance", invoiceData.financial?.currentBalance ?? "N/A"),
                  _buildPopupInfoRow("Last Payment", invoiceData.financial?.lastPayment?.toString() ?? "N/A"),
                  _buildPopupInfoRow("Total Value", invoiceData.financial?.totalValue ?? "N/A"),
                  _buildPopupInfoRow("Commission", invoiceData.financial?.commission ?? "N/A"),
                  _buildPopupInfoRow("Payable", invoiceData.financial?.payable ?? "N/A"),
                  _buildPopupInfoRow("Payable in Words", invoiceData.financial?.payableInWords ?? "N/A"),



                  SizedBox(height: 16.h),

                  // Product Items Information
                  Text(
                    "Product Items Information",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  // Check if items list is not empty
                  if (invoiceData.items != null && invoiceData.items!.isNotEmpty)
                    ...invoiceData.items!.map((item) => Column(
                          children: [
                            _buildPopupInfoRow("ID", (item.id != null) ? item.id.toString() : "N/A"),
                            _buildPopupInfoRow("Product Name", (item.productName != null && item.productName!.isNotEmpty) ? item.productName! : "N/A"),
                            _buildPopupInfoRow("Unit Price", (item.unitPrice != null && item.unitPrice!.isNotEmpty) ? item.unitPrice! : "N/A"),
                            _buildPopupInfoRow("Quantity", (item.qty != null && item.qty!.isNotEmpty) ? item.qty! : "N/A"),
                            _buildPopupInfoRow("Weight", "${item.weight?.toString() ?? '0'} ${item.weightUnit ?? ''}"),
                            _buildPopupInfoRow("Unit Name", (item.unitName != null && item.unitName!.isNotEmpty) ? item.unitName! : "N/A"),
                            _buildPopupInfoRow("Bonus", (item.bonus != null) ? item.bonus.toString() : "N/A"),
                            _buildPopupInfoRow("Discount %", "${item.discountPercentage?.toString() ?? '0'}%"),
                            _buildPopupInfoRow("Discount Amount", (item.discountAmount != null && item.discountAmount!.isNotEmpty) ? item.discountAmount! : "N/A"),
                            _buildPopupInfoRow("Total Price", (item.totalPrice != null && item.totalPrice!.isNotEmpty) ? item.totalPrice! : "N/A"),
                            Divider(height: 12.h),
                          ],
                        )).toList()
                  else
                    _buildPopupInfoRow("Items", "No items found"),


                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  // Helper method to build info rows in popup
  Widget _buildPopupInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
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
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}