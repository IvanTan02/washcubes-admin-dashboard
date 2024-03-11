// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:washcubes_admindashboard/src/models/order.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:washcubes_admindashboard/config.dart';
import 'package:washcubes_admindashboard/src/utilities/theme/widget_themes/text_theme.dart';

class ProcessOrder extends StatefulWidget {
  final Order? order;
  final String serviceName;
  final List<String> receiverDetails;

  const ProcessOrder({
    super.key,
    required this.order,
    required this.serviceName,
    required this.receiverDetails,
  });

  @override
  State<ProcessOrder> createState() => ProcessOrderState();
}

class ProcessOrderState extends State<ProcessOrder> {
  List<bool> itemChecklist = [];

  @override
  void initState() {
    super.initState();
    itemChecklist = List.generate(
      widget.order?.orderItems.length ?? 0,
      (index) => false,
    );
  }

  Future<void> confirmProcessingComplete() async {
    try {
      final Map<String, dynamic> data = {'orderId': widget.order?.id};
      final response = await http.post(
        Uri.parse('${url}orders/operator/confirm-processing-complete'),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Processing Complete',
                textAlign: TextAlign.center,
                style: CTextTheme.blackTextTheme.headlineLarge,
              ),
              content: Text(
                'Order ${widget.order?.orderNumber} has been successfully processed.',
                textAlign: TextAlign.center,
                style: CTextTheme.blackTextTheme.headlineSmall,
              ),
              actions: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Nice!',
                          style: CTextTheme.blackTextTheme.headlineSmall,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('Error approve order details: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final allItemsChecked = itemChecklist.every((item) => item);

    return AlertDialog(
      icon: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_rounded),
          ),
        ],
      ),
      content: SizedBox(
        width: size.width * 0.6,
        height: size.height * 0.6,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Order Number: ${widget.order?.orderNumber ?? 'Loading...'}',
                style: CTextTheme.blackTextTheme.displayLarge,
              ),
              const SizedBox(
                height: 30.0,
              ),
              //Order Detail Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Text(
                            'ORDER RECEIVED:',
                            style: CTextTheme.greyTextTheme.headlineMedium,
                          ),
                          title: Text(
                            '${widget.order?.orderStage?.inProgress.dateUpdated ?? 'Loading...'}',
                            style: CTextTheme.blackTextTheme.headlineMedium,
                          ),
                        ),
                        ListTile(
                          leading: Text(
                            'BARCODE ID:',
                            style: CTextTheme.greyTextTheme.headlineMedium,
                          ),
                          title: Text(
                            widget.order?.barcodeID ?? 'Loading...',
                            style: CTextTheme.blackTextTheme.headlineMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Text(
                            'USER PHONE NUMBER:',
                            style: CTextTheme.greyTextTheme.headlineMedium,
                          ),
                          title: Text(
                            widget.order?.user?.phoneNumber.toString() ??
                                'Loading...',
                            style: CTextTheme.blackTextTheme.headlineMedium,
                          ),
                        ),
                        ListTile(
                          leading: Text(
                            'LATEST STATUS:',
                            style: CTextTheme.greyTextTheme.headlineMedium,
                          ),
                          title: Text(
                            widget.order?.orderStage?.getInProgressStatus() ??
                                'Loading...',
                            style: CTextTheme.blackTextTheme.headlineMedium
                                ?.copyWith(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
              //Receiving Detail Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Text(
                            'RECEIVING DETAILS',
                            style: CTextTheme.blackTextTheme.headlineMedium,
                          ),
                        ),
                        ListTile(
                          leading: Text(
                            'DATE / TIME:',
                            style: CTextTheme.greyTextTheme.headlineMedium,
                          ),
                          title: Text(
                            '${widget.order?.orderStage?.inProgress.dateUpdated ?? 'Loading...'}',
                            style: CTextTheme.blackTextTheme.headlineMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Text(
                            'RECEIVER NAME:',
                            style: CTextTheme.greyTextTheme.headlineMedium,
                          ),
                          title: Text(
                            widget.receiverDetails[0],
                            style: CTextTheme.blackTextTheme.headlineMedium,
                          ),
                        ),
                        ListTile(
                          leading: Text(
                            'RECEIVER IC:',
                            style: CTextTheme.greyTextTheme.headlineMedium,
                          ),
                          title: Text(
                            widget.receiverDetails[1],
                            style: CTextTheme.blackTextTheme.headlineMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
              //Verification Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Text(
                            'ORDER DETAILS',
                            style: CTextTheme.blackTextTheme.headlineMedium,
                          ),
                        ),
                        ListTile(
                          leading: Text(
                            'SERVICE TYPE',
                            style: CTextTheme.greyTextTheme.headlineMedium,
                          ),
                          title: Text(
                            widget.serviceName,
                            style: CTextTheme.blackTextTheme.headlineMedium,
                          ),
                        ),
                        ListTile(
                          leading: Text(
                            'FINAL PRICE',
                            style: CTextTheme.greyTextTheme.headlineMedium,
                          ),
                          title: Text(
                            'RM${widget.order!.finalPrice?.toStringAsFixed(2)}',
                            style: CTextTheme.blackTextTheme.headlineMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(children: [
                    ElevatedButton(
                        onPressed: () {
                          if (allItemsChecked) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Approve Processing Completed?',
                                    textAlign: TextAlign.center,
                                    style:
                                        CTextTheme.blackTextTheme.headlineLarge,
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.red[100]!),
                                            ),
                                            child: Text(
                                              'Cancel',
                                              style: CTextTheme
                                                  .blackTextTheme.headlineSmall,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              await confirmProcessingComplete();
                                            },
                                            child: Text(
                                              'Confirm',
                                              style: CTextTheme
                                                  .blackTextTheme.headlineSmall,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Some Order Items are Unchecked',
                                    textAlign: TextAlign.center,
                                    style:
                                        CTextTheme.blackTextTheme.headlineLarge,
                                  ),
                                  content: Text(
                                    'Please ensure that all order items are in the right quantity.',
                                    textAlign: TextAlign.center,
                                    style:
                                        CTextTheme.blackTextTheme.headlineSmall,
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'OK',
                                              style: CTextTheme
                                                  .blackTextTheme.headlineSmall,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Text(
                          'Confirm Processed',
                          style: CTextTheme.blackTextTheme.headlineMedium,
                        ))
                  ]),
                ],
              ),
              const Divider(),
              //Order Item List
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        'ITEM',
                        style: CTextTheme.greyTextTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      )),
                      Expanded(
                          child: Text(
                        'PRICE',
                        style: CTextTheme.greyTextTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      )),
                      Expanded(
                          child: Text(
                        'QUANTITY',
                        style: CTextTheme.greyTextTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      )),
                      Expanded(
                          child: Text(
                        'CUM. PRICE',
                        style: CTextTheme.greyTextTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      )),
                      const SizedBox(width: 45.0),
                    ],
                  ),
                  const Divider(),
                  // Order Item List
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.order!.orderItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.order!.orderItems[index];
                      return CheckboxListTile(
                        title: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: CTextTheme
                                        .blackTextTheme.headlineMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'RM${item.price.toStringAsFixed(2)}/${item.unit}',
                                    style: CTextTheme
                                        .blackTextTheme.headlineMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    item.quantity.toString(),
                                    style: CTextTheme
                                        .blackTextTheme.headlineMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'RM${item.cumPrice.toStringAsFixed(2)}',
                                    style: CTextTheme
                                        .blackTextTheme.headlineMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        value: itemChecklist[index],
                        onChanged: (checked) {
                          setState(() {
                            itemChecklist[index] = checked ?? false;
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
