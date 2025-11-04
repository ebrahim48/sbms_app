import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sbms_apps/core/presentations/widgets/custom_button.dart';
import '../../../../controllers/product_list_controller.dart';
import '../../../constants/app_colors.dart';
import '../../../helpers/toast_message_helper.dart';
import '../../../models/dealer_info_model.dart';
import '../../../models/warehouselist_model.dart';
import '../../widgets/custom_loader.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {


  ProductListController productListController = Get.put(ProductListController());

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productListController.getDealerList();
      productListController.getWareHouseList();
      productListController.getProductWisePrice();
      productListController.getOrderInvoice();
    });
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _searchQuery = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Order Create",
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
              /// ========================> Row 1: Date, Vendor, Invoice ===========================>
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
                            const Icon(Icons.calendar_today, color: AppColors.primaryColor),
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



                  /// =============================> order vendor with search ==========================>
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Custom vendor selection field
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.business, color: AppColors.primaryColor),
                            title: Text(
                              _vendorName ?? "Select Vendor",
                              style: TextStyle(
                                color: _vendorName != null ? Colors.black : Colors.grey.shade600,
                              ),
                            ),
                            trailing: Icon(Icons.arrow_drop_down),
                            onTap: () {
                              _showSearchableDealerDialog();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),



                  // Obx(()=>
                  //   Expanded(
                  //     flex: 3,
                  //     child: DropdownButtonFormField<String>(
                  //       decoration: const InputDecoration(
                  //         labelText: "Vendor Name",
                  //         border: OutlineInputBorder(),
                  //       ),
                  //       value: _vendorName,
                  //       items: productListController.dealerList.value.dealerInfo
                  //           ?.map((dealer) => DropdownMenuItem(
                  //         value: dealer.dealerName,
                  //         child: Row(
                  //           children: [
                  //             Text(
                  //               '${dealer.id ?? 'N/A'} - ',
                  //               style: TextStyle(
                  //                 fontSize: 12.sp,
                  //                 fontWeight: FontWeight.w500,
                  //               ),
                  //             ),
                  //             Text(
                  //               dealer.dealerName ?? 'N/A',
                  //               style: TextStyle(
                  //                 fontSize: 12.sp,
                  //                 fontWeight: FontWeight.w500,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ))
                  //           .toList() ?? [],
                  //       onChanged: (val) => setState(() => _vendorName = val),
                  //       isExpanded: true,
                  //       menuMaxHeight: 300,
                  //     ),
                  //   ),),
                  SizedBox(width: 10.w),

                  /// =============================>  Invoice ==========================>

                  Obx((){
                    if (productListController.orderInvoiceNumberLoading.value) {
                      return const Center(child: CustomLoader());
                    }
                   return Expanded(
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.redAccent),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Invoice No: ${productListController.invoiceNumber.value.invoiceNo ?? 'N/A'}",
                          style: TextStyle(color: Colors.red),
                        )

                      ),
                    );
                  }

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
                      child: DropdownButtonFormField<int>(
                        decoration:  InputDecoration(
                          labelText: 'Warehouse',
                          border: OutlineInputBorder(),
                        ),
                        value: _warehouseId,
                        items: productListController.wareHouseList.value.warehouseInfo
                            ?.map((warehouse) => DropdownMenuItem(
                          value: warehouse.id,
                          child: Row(
                            children: [
                              Text(
                                '${warehouse.id ?? 'N/A'} - ',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                warehouse.warehouseName ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ))
                            .toList() ?? [],
                        onChanged: (val) => setState(() {
                          _warehouseId = val;
                          if (val != null) {
                            _branch = productListController.wareHouseList.value.warehouseInfo
                                ?.firstWhere((warehouse) => warehouse.id == val, orElse: () =>
                            productListController.wareHouseList.value.warehouseInfo!.isNotEmpty ?
                            productListController.wareHouseList.value.warehouseInfo!.first : WarehouseInfo(id: null, warehouseName: null))
                                ?.warehouseName;
                          }
                        }),
                        isExpanded: true,
                        menuMaxHeight: 300,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              ///======================================> Product Table ==============================>
              const Divider(),
              Text(
                "Products",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                    fontSize: 16.sp),
              ),
              SizedBox(height: 10.h),

              Obx(() {
            if (productListController.productWisePriceLoading.value) {
              return const Center(child: CustomLoader());
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Card(
                  elevation: 1,
                  margin: EdgeInsets.symmetric(vertical: 6.h),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
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
                                "Stock: ${productListController.productWisePrice.value.productInfo?.stock ?? "N/A"}",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Price: ${productListController.productWisePrice.value.productInfo?.price ?? "N/A"}",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: TextFormField(
                                initialValue: product["qty"].toString(),
                                decoration: const InputDecoration(
                                  labelText: "Quantity",
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (val) {
                                  setState(() => product["qty"] = double.tryParse(val) ?? 0);
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
                                  ((product["price"] as num) * (product["qty"] as num))
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
                                      color: AppColors.primaryColor),
                                  onPressed: () {
                                    // Check icon a click korle product add hobe
                                    setState(() {
                                      _products.add({
                                        "name": product["name"],
                                        "price": product["price"],
                                        "qty": product["qty"],
                                        // Add any other necessary fields
                                      });
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.cancel, color: Colors.red),
                                  onPressed: () {
                                    // Cross icon a click korle product remove hobe
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
            );
          }),
              SizedBox(height: 16.h),
// =====================> Grand Total Summary <=====================
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.primaryColor.withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order Summary",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Grand Total Quantity:",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "${_products.fold<int>(0, (sum, item) => sum + (item['qty'] as num).toInt())}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Grand Total Payable:",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "৳ ${_products.fold<num>(0, (sum, item) => sum + (item['price'] as num) * (item['qty'] as num))}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              /// =================================> Narration  =============================>
              TextFormField(
                controller: _narrationController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Narration",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.h),

              SizedBox(height: 20.h),
              Obx(() =>
                  CustomButton(
                    loading: productListController.orderLoading.value,
                    title: 'Order Confirm',
                      onpress: () {
                        if (formKey.currentState!.validate()) {
                          final productList = _products;

                          // 🧩 Safe extraction of product IDs and numeric fields
                          final productIds = productList.map((p) {
                            final id = p["id"];
                            return id is int ? id : 0;
                          }).toList();

                          final prices = productList.map((p) {
                            final price = p["price"];
                            return price is num ? price.toInt() : 0;
                          }).toList();

                          final quantities = productList.map((p) {
                            final qty = p["qty"];
                            return qty is num ? qty.toInt() : 0;
                          }).toList();

                          final totals = productList.map((p) {
                            final price = p["price"];
                            final qty = p["qty"];
                            if (price is num && qty is num) {
                              return (price * qty).toInt();
                            }
                            return 0;
                          }).toList();

                          // 🧮 Totals
                          final grandTotalQty = quantities.fold(0, (sum, qty) => sum + qty);
                          final grandTotalPayableAmount = totals.fold(0, (sum, t) => sum + t);

                          // 🗓️ Check Date
                          if (_selectedDate == null) {
                            ToastMessageHelper.showToastMessage("Please select a date before confirming.");
                            return;
                          }

                          // 🧾 Use selected vendor ID directly
                          if (_vendorId == null) {
                            ToastMessageHelper.showToastMessage("Please select a valid vendor.");
                            return;
                          }

                          // 🏢 Use selected warehouse ID directly
                          if (_warehouseId == null) {
                            ToastMessageHelper.showToastMessage("Please select a valid warehouse.");
                            return;
                          }

                          final formattedDate =
                              "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

                          // 🧠 Debug log (optional)
                          debugPrint('Dealer ID: $_vendorId');
                          debugPrint('Warehouse ID: $_warehouseId');
                          debugPrint('Product IDs: $productIds');

                          // 🚀 Final API call
                          productListController.orderCreateInfo(
                            date: formattedDate,
                            dealerId: _vendorId!,
                            invoiceNo: productListController.invoiceNumber.value.invoiceNo?.toString() ?? 'N/A',
                            warehouseId: _warehouseId!,
                            productId: productIds,
                            price: prices,
                            quantity: quantities,
                            totalPrice: totals,
                            grandTotalQty: grandTotalQty,
                            grandTotalPayableAmount: grandTotalPayableAmount,
                            narration: _narrationController.text.trim(),
                            context: context,
                            totalAmount: totals,
                          );
                        }
                      }

                    // onpress: () {
                    //   if (formKey.currentState!.validate()) {
                    //     final productList = _products;
                    //
                    //     final productIds = productList.map((p) => p["id"] as int).toList();
                    //     final prices = productList.map((p) => (p["price"] as num).toInt()).toList();
                    //     final quantities = productList.map((p) => (p["qty"] as num).toInt()).toList();
                    //     final totals = productList
                    //         .map((p) => ((p["price"] as num) * (p["qty"] as num)).toInt())
                    //         .toList();
                    //
                    //     // 🧮 Step 2: Calculate grand totals
                    //     final grandTotalQty = quantities.fold(0, (sum, qty) => sum + qty);
                    //     final grandTotalPayableAmount = totals.fold(0, (sum, t) => sum + t);
                    //
                    //     // 🗓️ Step 3: Validation check
                    //     if (_selectedDate == null) {
                    //       ToastMessageHelper.showToastMessage("Please select a date before confirming.");
                    //       return;
                    //     }
                    //
                    //     final formattedDate =
                    //         "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
                    //
                    //
                    //     productListController.orderCreateInfo(
                    //       date: formattedDate,
                    //       dealerId: productListController.dealerList.value.dealerInfo
                    //           ?.firstWhereOrNull((dealer) => dealer.dealerName == _vendorName)
                    //           ?.id ?? 0,
                    //       invoiceNo: productListController.invoiceNumber.value.invoiceNo?.toString() ?? 'N/A',
                    //       warehouseId: productListController.wareHouseList.value.warehouseInfo
                    //           ?.firstWhereOrNull((w) => w.warehouseName == _branch)
                    //           ?.id ?? 0,
                    //       productId: productIds,
                    //       price: prices,
                    //       quantity: quantities,
                    //       totalPrice: totals,
                    //       grandTotalQty: grandTotalQty,
                    //       grandTotalPayableAmount: grandTotalPayableAmount,
                    //       narration: _narrationController.text.trim(),
                    //       context: context,
                    //       totalAmount: totals,
                    //     );
                    //   }
                    // },
                  ),)
            ],
          ),
        ),
      ),
    );
  }



  DateTime? _selectedDate;
  String? _vendorName;
  int? _vendorId;
  String? _branch;
  int? _warehouseId;
  String? _type;
  final TextEditingController _narrationController = TextEditingController();


  final List<String> _types = ["Finished Goods"];

  final List<Map<String, dynamic>> _products = [
    {"id": 1, "name": "Affix-100ml", "price": 500.0, "qty": 2},
    {"id": 2, "name": "Aracta 25WDG-20GM", "price": 800.0, "qty": 1},
    {"id": 3, "name": "Bravo-250ml", "price": 300.0, "qty": 5},
    {"id": 4, "name": "Combo-1L", "price": 200.0, "qty": 3},
  ];



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

  // Show a dialog with searchable dealer list
  Future<void> _showSearchableDealerDialog() async {
    final dealers = (productListController.dealerList.value.dealerInfo ?? []);
    List<dynamic> filteredDealers = List.from(dealers);
    String searchQuery = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search vendors...",
                      prefixIcon: Icon(Icons.search, color: AppColors.primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                        filteredDealers = dealers.where((dealer) {
                          final name = (dealer.dealerName ?? '').toLowerCase();
                          final id = (dealer.id?.toString() ?? '').toLowerCase();
                          return name.contains(searchQuery) || id.contains(searchQuery);
                        }).toList();
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Divider(),
                ],
              ),
              content: Container(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredDealers.length,
                  itemBuilder: (BuildContext context, int index) {
                    final dealer = filteredDealers[index];
                    return ListTile(
                      title: Text(
                        dealer.dealerName ?? 'N/A',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text('ID: ${dealer.id ?? 'N/A'}'),
                      onTap: () {
                        setState(() {
                          _vendorId = dealer.id;
                          _vendorName = dealer.dealerName;
                        });
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
    );
  }

}
