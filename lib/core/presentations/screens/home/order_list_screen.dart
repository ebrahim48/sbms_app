import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  DateTime? _selectedDate;
  String? _vendorName;
  String? _branch;
  String? _orderType;
  String? _type;
  final TextEditingController _narrationController = TextEditingController();

  final List<String> _vendors = ["A.C R R Trading", "ABC Traders", "XYZ Ltd"];
  final List<String> _branches = ["Banosshahbhor Warehouse", "Main Branch"];
  final List<String> _orderTypes = ["Normal Order", "Urgent Order"];
  final List<String> _types = ["Finished Goods", "Raw Material"];
  final List<Map<String, dynamic>> _products = [
    {"name": "Affix-100ml", "stock": -11.199999, "price": 14000.0, "qty": 10},
    {"name": "Aracta 25WDG-20GM", "stock": 163.95, "price": 5400.0, "qty": 0},
  ];

  double get totalQty =>
      _products.fold(0, (sum, p) => sum + (p["qty"] as num).toDouble());

  double get totalPayable => _products.fold(
      0,
          (sum, p) =>
      sum +
          ((p["price"] as num) * (p["qty"] as num))
              .toDouble()); // price * qty

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
        backgroundColor: Colors.green[700],
        title: const Text(
          "Order Create",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Date, Vendor, Invoice
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: _pickDate,
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Date",
                          border: const OutlineInputBorder(),
                          suffixIcon:
                          const Icon(Icons.calendar_today, color: Colors.green),
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
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Vendor Name",
                      border: OutlineInputBorder(),
                    ),
                    value: _vendorName,
                    items: _vendors
                        .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                        .toList(),
                    onChanged: (val) => setState(() => _vendorName = val),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.redAccent),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      "Invoice No: Sal.3971",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 220.w,
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Type",
                        border: OutlineInputBorder(),
                      ),
                      value: _type,
                      items: _types
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) => setState(() => _type = val),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  SizedBox(
                    width: 220.w,
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Branch/Warehouse",
                        border: OutlineInputBorder(),
                      ),
                      value: _branch,
                      items: _branches
                          .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                          .toList(),
                      onChanged: (val) => setState(() => _branch = val),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  SizedBox(
                    width: 220.w,
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Order Type",
                        border: OutlineInputBorder(),
                      ),
                      value: _orderType,
                      items: _orderTypes
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) => setState(() => _orderType = val),
                    ),
                  ),
                ],
              ),
            ),

            // Row 2: Type, Branch, Order Type
            // Row(
            //   children: [
            //     Expanded(
            //       child: DropdownButtonFormField<String>(
            //         decoration: const InputDecoration(
            //           labelText: "Type",
            //           border: OutlineInputBorder(),
            //         ),
            //         value: _type,
            //         items: _types
            //             .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            //             .toList(),
            //         onChanged: (val) => setState(() => _type = val),
            //       ),
            //     ),
            //     SizedBox(width: 10.w),
            //     Expanded(
            //       child: DropdownButtonFormField<String>(
            //         decoration: const InputDecoration(
            //           labelText: "Branch/Warehouse",
            //           border: OutlineInputBorder(),
            //         ),
            //         value: _branch,
            //         items: _branches
            //             .map((b) => DropdownMenuItem(value: b, child: Text(b)))
            //             .toList(),
            //         onChanged: (val) => setState(() => _branch = val),
            //       ),
            //     ),
            //     SizedBox(width: 6.w),
            //     Expanded(
            //       child: DropdownButtonFormField<String>(
            //         decoration: const InputDecoration(
            //           labelText: "Order Type",
            //           border: OutlineInputBorder(),
            //         ),
            //         value: _orderType,
            //         items: _orderTypes
            //             .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            //             .toList(),
            //         onChanged: (val) => setState(() => _orderType = val),
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(height: 16.h),

            // Product Table
            const Divider(),
            Text(
              "Products",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                  fontSize: 16.sp),
            ),
            SizedBox(height: 10.h),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Card(
                  elevation: 1,
                  margin: EdgeInsets.symmetric(vertical: 6.h),
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                product["name"],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Stock: ${product["stock"]}",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: product["price"].toString(),
                                decoration: const InputDecoration(
                                  labelText: "Price",
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (val) {
                                  setState(() => product["price"] =
                                      double.tryParse(val) ?? 0);
                                },
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: TextFormField(
                                initialValue:
                                product["qty"].toString(),
                                decoration: const InputDecoration(
                                  labelText: "Quantity",
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (val) {
                                  setState(() => product["qty"] =
                                      double.tryParse(val) ?? 0);
                                },
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  ((product["price"] as num) *
                                      (product["qty"] as num))
                                      .toStringAsFixed(2),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.check_circle,
                                      color: Colors.green),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.cancel,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() => _products.removeAt(index));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 16.h),

            // Narration
            TextFormField(
              controller: _narrationController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Narration",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.h),

            // Totals
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Qty:"),
                      Text(totalQty.toStringAsFixed(0)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Payable:"),
                      Text(totalPayable.toStringAsFixed(2)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Submit Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Order Confirmed ✅")),
                  );
                },
                child: const Text(
                  "Order Confirm",
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
