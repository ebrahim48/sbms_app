import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sbms_apps/core/presentations/widgets/custom_button.dart';

import '../../../../controllers/product_list_controller.dart';
import '../../../constants/app_colors.dart';
import '../../../helpers/toast_message_helper.dart';
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







  DateTime? _selectedDate;
  String? _vendorName;
  String? _branch;
  String? _orderType;
  String? _type;
  final TextEditingController _narrationController = TextEditingController();


  final List<String> _orderTypes = ["Normal Order", "Urgent Order"];
  final List<String> _types = ["Finished Goods", "Raw Material"];

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

                  // Obx(() {
                  //   final dealerInfo = productListController.dealerList.value.dealerInfo ?? [];
                  //
                  //   return Flexible(
                  //     flex: 3,
                  //     child: DropdownButtonFormField<String>(
                  //       decoration: const InputDecoration(
                  //         labelText: "Vendor Name",
                  //         border: OutlineInputBorder(),
                  //       ),
                  //       value: _vendorName,
                  //       icon: Padding(
                  //         padding: EdgeInsets.only(right: 8.w),
                  //         child: SvgPicture.asset(
                  //           'assets/icons/arrowdown.svg',
                  //           width: 18.w,
                  //           height: 18.h,
                  //           colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
                  //         ),
                  //       ),
                  //       iconSize: 24,
                  //       items: dealerInfo.map((dealer) {
                  //         return DropdownMenuItem(
                  //           value: dealer.dealerName,
                  //           child: Row(
                  //             children: [
                  //               Text(
                  //                 '${dealer.id ?? 'N/A'} - ',
                  //                 style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  //               ),
                  //               Flexible(
                  //                 child: Text(
                  //                   dealer.dealerName ?? 'N/A',
                  //                   style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  //                   overflow: TextOverflow.ellipsis,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         );
                  //       }).toList(),
                  //       onChanged: (val) => _vendorName = val,
                  //       isExpanded: true,
                  //       menuMaxHeight: 300.h,
                  //       elevation: 8,
                  //       dropdownColor: Colors.white,
                  //       borderRadius: BorderRadius.circular(8.r),
                  //     ),
                  //   );
                  // }),


                  /// =============================> order vendor ==========================>
                  Obx(()=>
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: "Vendor Name",
                          border: OutlineInputBorder(),
                        ),
                        value: _vendorName,
                        items: productListController.dealerList.value.dealerInfo
                            ?.map((dealer) => DropdownMenuItem(
                          value: dealer.dealerName,
                          child: Row(
                            children: [
                              Text(
                                '${dealer.id ?? 'N/A'} - ',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                dealer.dealerName ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ))
                            .toList() ?? [],
                        onChanged: (val) => setState(() => _vendorName = val),
                        isExpanded: true,
                        menuMaxHeight: 300,
                      ),
                    ),
                  ),




                  SizedBox(width: 10.w),



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
                      child: DropdownButtonFormField<String>(
                        decoration:  InputDecoration(
                          labelText: productListController.wareHouseList.value.warehouseInfo?.first.warehouseName ?? 'N/A',
                          border: OutlineInputBorder(),
                        ),
                        value: _branch,
                        items: productListController.wareHouseList.value.warehouseInfo
                            ?.map((warehouse) => DropdownMenuItem(
                          value: warehouse.warehouseName,
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
                        onChanged: (val) => setState(() => _branch = val),
                        isExpanded: true,
                        menuMaxHeight: 300,
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
                    color: AppColors.primaryColor,
                    fontSize: 16.sp),
              ),
              SizedBox(height: 10.h),

              Obx((){
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
                                    "Stock: ${productListController.productWisePrice.value.productInfo?.price ?? "N/A"}",
                                    style: TextStyle(color: Colors.black),
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
                                          color: AppColors.primaryColor),
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
                );
              }


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


              SizedBox(height: 20.h),


              Obx(() =>
                  CustomButton(
                    loading: productListController.orderLoading.value,
                    title: 'Order Confirm',
                    onpress: () {
                      if (formKey.currentState!.validate()) {
                        // 🧩 Step 1: Prepare product list data
                        final productList = _products;

                        final productIds = productList.map((p) => p["id"] as int).toList();
                        final prices = productList.map((p) => (p["price"] as num).toInt()).toList();
                        final quantities = productList.map((p) => (p["qty"] as num).toInt()).toList();
                        final totals = productList
                            .map((p) => ((p["price"] as num) * (p["qty"] as num)).toInt())
                            .toList();

                        // 🧮 Step 2: Calculate grand totals
                        final grandTotalQty = quantities.fold(0, (sum, qty) => sum + qty);
                        final grandTotalPayableAmount = totals.fold(0, (sum, t) => sum + t);

                        // 🗓️ Step 3: Validation check
                        if (_selectedDate == null) {
                          ToastMessageHelper.showToastMessage("Please select a date before confirming.");
                          return;
                        }

                        final formattedDate =
                            "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

                        // ✅ Step 4: Call API with proper total_amount array
                        productListController.orderCreateInfo(
                          date: formattedDate,
                          dealerId: productListController.dealerList.value.dealerInfo
                              ?.firstWhereOrNull((dealer) => dealer.dealerName == _vendorName)
                              ?.id ?? 0,
                          invoiceNo: productListController.invoiceNumber.value.invoiceNo?.toString() ?? 'N/A',
                          warehouseId: productListController.wareHouseList.value.warehouseInfo
                              ?.firstWhereOrNull((w) => w.warehouseName == _branch)
                              ?.id ?? 0,
                          productId: productIds,
                          price: prices,
                          quantity: quantities,
                          totalPrice: totals,
                          grandTotalQty: grandTotalQty,
                          grandTotalPayableAmount: grandTotalPayableAmount,
                          narration: _narrationController.text.trim(),
                          context: context,
                          totalAmount: totals, // ✅ নতুন ফিল্ড: total_amount পাঠানো হচ্ছে UI থেকে
                        );
                      }
                    },
                  ),
              )


            ],
          ),
        ),
      ),
    );
  }
}
