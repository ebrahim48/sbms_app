import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  String? _bank;
  String? _dealer;
  String? _invoice;
  String? _productCategory;

  final List<String> _types = ["Dealer", "Customer"];
  final List<String> _dealers = ["A.C R R Trading", "ABC Traders", "XYZ Ltd"];
  final List<String> _banks = ["IBBL-AWCA-4896", "DBBL-ACC-2345"];
  final List<String> _invoices = ["Sal-2944 (2024-12-05)", "Sal-2950 (2025-01-12)"];
  final List<String> _categories = ["FG-CORN SEED", "FG-WHEAT SEED"];

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
            // Date & Narration Row
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

            // Type Dropdown
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

            // Bank Selection
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Bank",
                border: OutlineInputBorder(),
              ),
              value: _bank,
              items: _banks.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) => setState(() => _bank = value),
            ),
            SizedBox(height: 8.h),
            Text(
              "Balance: 679715.78",
              style: TextStyle(color: Colors.red[700], fontSize: 14.sp),
            ),
            SizedBox(height: 8.h),

            // Product Category
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Product Category",
                border: OutlineInputBorder(),
              ),
              value: _productCategory,
              items: _categories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) => setState(() => _productCategory = value),
            ),
            SizedBox(height: 16.h),

            // Dealer, Type & Invoice
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

            // Invoice and Action
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Invoice",
                      border: OutlineInputBorder(),
                    ),
                    value: _invoice,
                    items: _invoices.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (value) => setState(() => _invoice = value),
                  ),
                ),
                SizedBox(width: 10.w),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check_circle, color: AppColors.primaryColor),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Bank Charge & Amount
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

            // Total Amount
            Center(
              child: Text(
                "Total Amount : ${totalAmount.toStringAsFixed(2)}/-",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20.h),

            // Submit Button
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
}
