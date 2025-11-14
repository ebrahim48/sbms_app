import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sbms_apps/core/presentations/widgets/custom_button.dart';
import 'package:sbms_apps/core/presentations/widgets/custom_loader.dart';
import 'package:sbms_apps/core/presentations/widgets/searchable_dealer_dropdown.dart';

import '../../../../controllers/bank_create_controller.dart';
import '../../../../controllers/product_list_controller.dart';
import '../../../constants/app_colors.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

// Model for each row data
class PaymentRowData {
  int? dealerId;
  String? dealerName;
  int? bankId;
  String? bankName;
  int? categoryId;
  String? categoryName;
  String? balanceType;
  String? invoiceValue;
  String? invoiceLabel;
  int? dueAmount;
  TextEditingController bankChargeController;
  TextEditingController amountController;

  PaymentRowData({
    this.dealerId,
    this.dealerName,
    this.bankId,
    this.bankName,
    this.categoryId,
    this.categoryName,
    this.balanceType = "Invoice",
    this.invoiceValue,
    this.invoiceLabel,
    this.dueAmount,
    TextEditingController? bankChargeController,
    TextEditingController? amountController,
  })  : bankChargeController = bankChargeController ?? TextEditingController(text: "0"),
        amountController = amountController ?? TextEditingController(text: "0");

  void dispose() {
    bankChargeController.dispose();
    amountController.dispose();
  }
}

class _CreateScreenState extends State<CreateScreen> {
  final BankListController bankListController = Get.put(BankListController());
  final ProductListController productListController = Get.put(ProductListController());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bankListController.getBankList();
      bankListController.getCategoryList();
      productListController.getDealerList();
      bankListController.getInvoiceList();
    });
  }

  @override
  void dispose() {
    _narrationController.dispose();
    for (var row in _paymentRows) {
      row.dispose();
    }
    super.dispose();
  }

  // Controllers
  final TextEditingController _narrationController = TextEditingController();
  DateTime? _selectedDate;

  // List to store multiple payment rows
  List<PaymentRowData> _paymentRows = [PaymentRowData()];

  double get totalAmount {
    double total = 0;
    for (var row in _paymentRows) {
      double amount = double.tryParse(row.amountController.text) ?? 0;
      double charge = double.tryParse(row.bankChargeController.text) ?? 0;
      total += (amount - charge);
    }
    return total;
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

  void _addNewRow() {
    setState(() {
      _paymentRows.add(PaymentRowData());
    });
  }

  void _removeRow(int index) {
    if (_paymentRows.length > 1) {
      setState(() {
        _paymentRows[index].dispose();
        _paymentRows.removeAt(index);
      });
    } else {
      _showError("At least one payment row is required");
    }
  }

  void _showError(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
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
        child: Form(
          key: formKey,
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
                          validator: (value) {
                            if (_selectedDate == null) {
                              return "Please select a date";
                            }
                            return null;
                          },
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
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Narration cannot be empty";
                        }
                        if (value.length > 255) {
                          return "Narration cannot exceed 255 characters";
                        }
                        // Optional: Allow only letters, numbers, basic punctuation
                        final validPattern = RegExp(r'^[a-zA-Z0-9\s.,!?()-]*$');
                        if (!validPattern.hasMatch(value)) {
                          return "Invalid characters in narration";
                        }
                        return null; // Valid
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              /// ======================> Payment Rows Section ========================>
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Payment Details",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  // ElevatedButton.icon(
                  //   onPressed: _addNewRow,
                  //   icon: const Icon(Icons.add),
                  //   label: const Text("Add Row"),
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: AppColors.primaryColor,
                  //     foregroundColor: Colors.white,
                  //   ),
                  // ),
                ],
              ),
              SizedBox(height: 10.h),





              /// ======================> Dynamic Payment Rows ========================>
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _paymentRows.length,
                itemBuilder: (context, index) {
                  return _buildPaymentRow(index);
                },
              ),

              SizedBox(height: 20.h),

              /// =============================>  Total Amount ===========================>
              Center(
                child: Text(
                  "Total Amount : ${totalAmount.toStringAsFixed(2)}/-",
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                ),
              ),
              SizedBox(height: 20.h),

              /// ===============================> Submit Button ==========================>
              Obx(() => CustomButton(
                loading: bankListController.bankReceiveLoading.value,
                title: 'Submit',
                onpress: _handleSubmit,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentRow(int index) {
    final rowData = _paymentRows[index];

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16.h),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Row Header with Remove Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Payment #${index + 1}",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                if (_paymentRows.length > 1)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeRow(index),
                    tooltip: "Remove Row",
                  ),
              ],
            ),
            SizedBox(height: 10.h),

            /// Dealer Searchable Dropdown


            Obx(() {
              if (productListController.dealerList.value.dealerInfo == null ||
                  productListController.dealerList.value.dealerInfo!.isEmpty) {
                return TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Dealer",
                    border: OutlineInputBorder(),
                    hintText: "No dealers available",
                  ),
                  enabled: false,
                );
              }

              return SearchableDealerDropdown(
                dealers: productListController.dealerList.value.dealerInfo,
                selectedDealerId: rowData.dealerId,
                onChanged: (val) {
                  setState(() {
                    rowData.dealerId = val;
                    rowData.dealerName = productListController.dealerList.value.dealerInfo
                        ?.firstWhere((dealer) => dealer.id == val)
                        .dealerName;
                  });
                  // Load invoices for this dealer
                  if (val != null) {
                    // bankListController.getInvoiceList(dealerId: val);
                  }
                },
                validator: (value) => value == null ? "Select dealer" : null,
              );
            }),


            SizedBox(height: 12.h),

            /// Bank Dropdown
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
                value: rowData.bankId,
                items: bankListController.bankList.map((bank) {
                  return DropdownMenuItem<int>(
                    value: bank.id,
                    child: Text(bank.bankName ?? "N/A"),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    rowData.bankId = value;
                    rowData.bankName = bankListController.bankList
                        .firstWhere((bank) => bank.id == value)
                        .bankName;
                  });
                },
                validator: (value) => value == null ? "Select bank" : null,
              );
            }),
            SizedBox(height: 12.h),

            /// Category Dropdown
            Obx(() {
              if (bankListController.categoryListLoading.value) {
                return const CustomLoader();
              }

              if (bankListController.categoryList.isEmpty) {
                return const Text("No category available");
              }

              return DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: "Product Category",
                  border: OutlineInputBorder(),
                ),
                value: rowData.categoryId,
                items: bankListController.categoryList.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(category.categoryName ?? "N/A"),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    rowData.categoryId = value;
                    rowData.categoryName = bankListController.categoryList
                        .firstWhere((category) => category.id == value)
                        .categoryName;
                  });
                },
                validator: (value) => value == null ? "Select category" : null,
              );
            }),
            SizedBox(height: 12.h),

            /// Balance Type & Invoice Row
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Balance Type",
                      border: OutlineInputBorder(),
                    ),
                    value: rowData.balanceType,
                    items: const [
                      DropdownMenuItem(value: "Invoice", child: Text("Invoice")),
                      DropdownMenuItem(value: "opening_balance", child: Text("Opening Balance")),
                    ],
                    onChanged: (val) {
                      setState(() {
                        rowData.balanceType = val;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Obx(() {
                    print("Invoice List Loading: ${bankListController.invoiceListLoading.value}");
                    print("Invoice List Length: ${bankListController.invoiceList.length}");

                    if (bankListController.invoiceListLoading.value) {
                      return const Center(child: CustomLoader());
                    }

                    if (bankListController.invoiceList.isEmpty) {
                      print("⚠️ No invoices available!");
                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: "Invoice",
                          border: OutlineInputBorder(),
                        ),
                        items: const [],
                        onChanged: null,
                        hint: const Text("Select dealer first"),
                      );
                    }

                    print("✅ ${bankListController.invoiceList.length} invoices loaded");

                    return DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Invoice",
                        border: OutlineInputBorder(),
                      ),
                      value: rowData.invoiceValue,
                      items: bankListController.invoiceList.map((invoice) {
                        return DropdownMenuItem<String>(
                          value: invoice.invoiceValue,
                          child: Text(invoice.invoiceLabel ?? "N/A", style: TextStyle(fontSize: 11.sp)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          rowData.invoiceValue = value;
                          final selectedInvoice = bankListController.invoiceList
                              .firstWhere((invoice) => invoice.invoiceValue == value);
                          rowData.invoiceLabel = selectedInvoice.invoiceLabel;
                          rowData.dueAmount = selectedInvoice.dueAmount;
                        });

                        print("Invoice selected: $value");
                      },
                      validator: (value) => value == null ? "Select invoice" : null,
                    );
                  }),
                ),
                // Expanded(
                //   child: Obx(() {
                //     if (bankListController.invoiceListLoading.value) {
                //       return const Center(child: CustomLoader());
                //     }
                //
                //     if (bankListController.invoiceList.isEmpty) {
                //       return DropdownButtonFormField<String>(
                //         decoration: const InputDecoration(
                //           labelText: "Invoice",
                //           border: OutlineInputBorder(),
                //         ),
                //         items: const [],
                //         onChanged: null,
                //         hint: const Text("No invoices"),
                //       );
                //     }
                //
                //     return DropdownButtonFormField<String>(
                //       decoration: const InputDecoration(
                //         labelText: "Invoice",
                //         border: OutlineInputBorder(),
                //       ),
                //       value: rowData.invoiceValue,
                //       items: bankListController.invoiceList.map((invoice) {
                //         return DropdownMenuItem<String>(
                //           value: invoice.invoiceValue,
                //           child: Text(invoice.invoiceLabel ?? "N/A", style: TextStyle(fontSize: 11.sp)),
                //         );
                //       }).toList(),
                //       onChanged: (value) {
                //         setState(() {
                //           rowData.invoiceValue = value;
                //           final selectedInvoice = bankListController.invoiceList
                //               .firstWhere((invoice) => invoice.invoiceValue == value);
                //           rowData.invoiceLabel = selectedInvoice.invoiceLabel;
                //           rowData.dueAmount = selectedInvoice.dueAmount;
                //         });
                //       },
                //       validator: (value) => value == null ? "Select invoice" : null,
                //     );
                //   }),
                // ),
              ],
            ),
            SizedBox(height: 12.h),

            /// Bank Charge & Amount Row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: rowData.bankChargeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Bank Charge",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: TextFormField(
                    controller: rowData.amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Amount",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            if (rowData.dueAmount != null)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  "Due Amount: ৳ ${rowData.dueAmount}",
                  style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.w600),
                ),
              ),
          ],
        ),
      ),
    );
  }
  void _handleSubmit() {
    // Validation
    if (_selectedDate == null) {
      _showError("Please select a date");
      return;
    }

    if (!formKey.currentState!.validate()) {
      _showError("Please fill all required fields");
      return;
    }

    // Check if all rows have invoices selected
    for (int i = 0; i < _paymentRows.length; i++) {
      if (_paymentRows[i].invoiceValue == null || _paymentRows[i].invoiceValue!.isEmpty) {
        _showError("Please select invoice for Payment #${i + 1}");
        return;
      }
    }

    // Prepare data
    String formattedDate =
        "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

    List<int> dealerIds = _paymentRows.map((row) => row.dealerId ?? 0).toList();
    List<int> bankIds = _paymentRows.map((row) => row.bankId ?? 0).toList();
    List<int> categoryIds = _paymentRows.map((row) => row.categoryId ?? 0).toList();
    List<String> balanceTypes = _paymentRows.map((row) => row.balanceType ?? "Invoice").toList();

    // Filter out empty invoices
    List<String> salesInvoices = _paymentRows
        .map((row) => row.invoiceValue ?? "")
        .where((invoice) => invoice.isNotEmpty)
        .toList();

    List<int> bankCharges =
    _paymentRows.map((row) => int.tryParse(row.bankChargeController.text.trim()) ?? 0).toList();
    List<int> amounts = _paymentRows.map((row) => int.tryParse(row.amountController.text.trim()) ?? 0).toList();

    // Debug print
    print("=== Submit Data ===");
    print("Payment Date: $formattedDate");
    print("Dealer IDs: $dealerIds");
    print("Bank IDs: $bankIds");
    print("Category IDs: $categoryIds");
    print("Balance Types: $balanceTypes");
    print("Sales Invoices: $salesInvoices"); // This should now show values
    print("Bank Charges: $bankCharges");
    print("Amounts: $amounts");
    print("Description: ${_narrationController.text.trim()}");
    print("==================");

    // Check if we have invoices
    if (salesInvoices.isEmpty) {
      _showError("No invoices selected!");
      return;
    }

    // Call API
    bankListController.bankReceiveStore(
      paymentDate: formattedDate,
      dealerId: dealerIds,
      bankId: bankIds,
      categoryId: categoryIds,
      balanceType: balanceTypes,
      salesInvoice: salesInvoices,
      bankCharge: bankCharges,
      amount: amounts,
      paymentDescription: _narrationController.text.trim(),
      context: context,
    );
  }


}