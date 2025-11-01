import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sbms_apps/core/presentations/widgets/custom_loader.dart';

import '../../../../controllers/bank_create_controller.dart';
import '../../../constants/app_colors.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  // Controllers
  final TextEditingController _narrationController = TextEditingController();
  final TextEditingController _bankChargeController = TextEditingController(text: "0");
  final TextEditingController _amountController = TextEditingController(text: "0");

  // Form values
  DateTime? _selectedDate;
  String? _type;
  String? _dealer;

  int? _selectedBankId;
  String? _selectedBankName;
  int? _selectCategoryId;
  String? _selectCategoryName;

  String? _selectedInvoiceValue;
  String? _selectedInvoiceLabel;
  int? _selectedDueAmount;

  final List<String> _types = ["Dealer", "Customer"];
  final List<String> _dealers = ["A.C R R Trading", "ABC Traders", "XYZ Ltd"];


  double get totalAmount {
    double amount = double.tryParse(_amountController.text) ?? 0;
    double charge = double.tryParse(_bankChargeController.text) ?? 0;
    return amount - charge;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }


  final BankListController bankListController = Get.put(BankListController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bankListController.getBankList();
      bankListController.getCategoryList();
      bankListController.getInvoiceList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Create Bank Received",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===========================> Date & Narration Row =========================>
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _pickDate,
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Date",
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today, color: AppColors.primaryColor),
                        ),
                        controller: TextEditingController(
                          text: _selectedDate == null
                              ? ''
                              : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: TextFormField(
                    controller: _narrationController,
                    decoration: const InputDecoration(
                      labelText: "Narration",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            /// =======================> Type Dropdown ==========================>
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Type",
                border: OutlineInputBorder(),
              ),
              value: _type,
              items: _types.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) => setState(() => _type = value),
            ),
            SizedBox(height: 16.h),

            /// =======================> Bank Selection ==========================>
            Obx(() {
              if (bankListController.bankListLoading.value) {
                return const CustomLoader();
              }

              if (bankListController.bankList.isEmpty) {
                return const Text("No banks available");
              }

              return DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: "Bank",
                  border: OutlineInputBorder(),
                ),
                value: _selectedBankId,
                items: bankListController.bankList.map((bank) {
                  return DropdownMenuItem<int>(
                    value: bank.id,
                    child: Text(bank.bankName ?? "N/A"),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBankId = value;
                    // Find the selected bank name
                    _selectedBankName = bankListController.bankList
                        .firstWhere((bank) => bank.id == value)
                        .bankName;
                  });

                  // Print or use the selected values
                  print("Selected Bank ID: $_selectedBankId");
                  print("Selected Bank Name: $_selectedBankName");
                },
              );
            }),

            SizedBox(height: 16.h),

            // Display selected values
            if (_selectedBankId != null)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Selected Bank ID: $_selectedBankId"),
                      Text("Selected Bank Name: $_selectedBankName"),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 20.h),

            /// =========================> Product Category =========================>


            Obx(() {
              if (bankListController.categoryListLoading.value) {
                return const CustomLoader();
              }

              if (bankListController.bankList.isEmpty) {
                return const Text("No category available");
              }

              return DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: "Product Category",
                  border: OutlineInputBorder(),
                ),
                value: _selectCategoryId,
                items: bankListController.categoryList.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(category.categoryName ?? "N/A"),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectCategoryId = value;
                    // Find the selected bank name
                    _selectCategoryName = bankListController.categoryList
                        .firstWhere((category) => category.id == value)
                        .categoryName;
                  });

                  // Print or use the selected values
                  print("Selected Category ID: $_selectCategoryId");
                  print("Selected Category Name: $_selectCategoryName");
                },
              );
            }),
            SizedBox(height: 16.h),

            // Display selected values
            if (_selectCategoryId!= null)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Selected Category ID: $_selectCategoryId"),
                      Text("Selected Category Name: $_selectCategoryName"),
                    ],
                  ),
                ),
              ),


            SizedBox(height: 16.h),

            /// ===========================>  Dealer, Type & Invoice ========================>
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Dealer",
                      border: OutlineInputBorder(),
                    ),
                    value: _dealer,
                    items: _dealers.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (value) => setState(() => _dealer = value),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Type",
                      border: OutlineInputBorder(),
                    ),
                    value: "Invoice",
                    items: const [
                      DropdownMenuItem(value: "Invoice", child: Text("Invoice")),
                      DropdownMenuItem(value: "Bill", child: Text("Bill")),
                    ],
                    onChanged: (_) {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            ///=============================> Invoice and Action ============================>
            Row(
              children: [
                Expanded(
                  child: Obx(() {
                    if (bankListController.invoiceListLoading.value) {
                      return const Center(child: CustomLoader());
                    }

                    if (bankListController.invoiceList.isEmpty) {
                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: "Invoice",
                          border: OutlineInputBorder(),
                        ),
                        items: const [],
                        onChanged: null,
                        hint: const Text("No invoices available"),
                      );
                    }

                    return DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Invoice",
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedInvoiceValue,
                      items: bankListController.invoiceList.map((invoice) {
                        return DropdownMenuItem<String>(
                          value: invoice.invoiceValue,
                          child: Text(invoice.invoiceLabel ?? "N/A"),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedInvoiceValue = value;

                          // Find the selected invoice and get all details
                          final selectedInvoice = bankListController.invoiceList
                              .firstWhere((invoice) => invoice.invoiceValue == value);

                          _selectedInvoiceLabel = selectedInvoice.invoiceLabel;
                          _selectedDueAmount = selectedInvoice.dueAmount;
                        });

                        print("Selected Invoice Value: $_selectedInvoiceValue");
                        print("Selected Invoice Label: $_selectedInvoiceLabel");
                        print("Due Amount: $_selectedDueAmount");
                      },
                    );
                  }),
                ),
                SizedBox(width: 10.w),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check_circle, color: AppColors.primaryColor),
                      onPressed: _handleConfirm,
                      tooltip: "Confirm Invoice",
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: _handleCancel,
                      tooltip: "Cancel Selection",
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Display selected invoice details
            if (_selectedInvoiceValue != null)
              Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selected Invoice Details",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _buildDetailRow("Invoice", _selectedInvoiceLabel ?? "N/A"),
                      _buildDetailRow("Invoice Value", _selectedInvoiceValue ?? "N/A"),
                      _buildDetailRow("Due Amount", "৳ ${_selectedDueAmount ?? 0}"),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 16.h),

            /// ==============================> Bank Charge & Amount ===================================>
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _bankChargeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Bank Charge",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Amount",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              "Already Paid Amount = 0",
              style: TextStyle(color: Colors.red[700]),
            ),
            SizedBox(height: 16.h),

            /// =============================>  Total Amount ===========================>
            Center(
              child: Text(
                "Total Amount : ${totalAmount.toStringAsFixed(2)}/-",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20.h),

            /// ===============================> Submit Button ==========================>
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Form Submitted")),
                  );
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _handleConfirm() {
    if (_selectedInvoiceValue == null) {
      Get.snackbar(
        "Error",
        "Please select an invoice first",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    print("✅ Confirmed Invoice: $_selectedInvoiceValue");
    print("✅ Due Amount: $_selectedDueAmount");

    // Your confirm logic here
    Get.snackbar(
      "Success",
      "Invoice $_selectedInvoiceValue confirmed",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _handleCancel() {
    setState(() {
      _selectedInvoiceValue = null;
      _selectedInvoiceLabel = null;
      _selectedDueAmount = null;
    });

    print("❌ Invoice selection cancelled");

    Get.snackbar(
      "Cancelled",
      "Invoice selection cleared",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

}
Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$label:",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}


