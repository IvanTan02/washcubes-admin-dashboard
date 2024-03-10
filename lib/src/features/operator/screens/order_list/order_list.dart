// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:washcubes_admindashboard/src/constants/colors.dart';
import 'package:washcubes_admindashboard/src/features/operator/screens/input_tag/tag_input_popup.dart';
import 'package:washcubes_admindashboard/src/features/operator/screens/order_detail/order_detail_popup.dart';
import 'package:washcubes_admindashboard/src/utilities/theme/widget_themes/text_theme.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:washcubes_admindashboard/config.dart';
import 'package:washcubes_admindashboard/src/models/order.dart';
import 'package:washcubes_admindashboard/src/models/service.dart';
import 'package:washcubes_admindashboard/src/features/operator/screens/order_detail/pending_order.dart';

class OrderTable extends StatefulWidget {
  const OrderTable({super.key});

  @override
  State<OrderTable> createState() => OrderTableState();
}

class OrderTableState extends State<OrderTable> {
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final response = await http.get(
        Uri.parse('${url}orders/operator'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        //print(response.body)
        final Map<String, dynamic> data = json.decode(response.body);
        //print(data);
        if (data.containsKey('orders')) {
          final List<dynamic> orderData = data['orders'];
          final List<Order> fetchedOrders =
              orderData.map((order) => Order.fromJson(order)).toList();
          print(fetchedOrders);
          setState(() {
            orders = fetchedOrders;
          });
        } else {
          print('Response data does not contain services.');
        }
      } else {
        print('Error: ${response.statusCode}');
        print('Error message: ${response.body}');
      }
    } catch (error) {
      print('Error Fetching Orders: $error');
    }
  }

  void viewOrder(Order order, String serviceName) {
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return OrderDetails(
    //       order: order,
    //       serviceName: serviceName,
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Orders',
                    style: CTextTheme.blackTextTheme.displayLarge,
                  ),
                  IconButton(
                    onPressed: () {
                      //TODO: Refresh List Action
                    },
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: AppColors.cBlackColor,
                    ),
                  )
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const InputTagPopUp();
                    },
                  );
                },
                child: Text(
                  'Scan Tag',
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            height: 40.0,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by ID',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                //TODO: Handle search functionality
              },
            ),
          ),
        ),
        Flexible(
          child: OrderList(
            orders: orders,
          ),
        ),
      ],
    );
  }
}

class OrderList extends StatelessWidget {
  List<Order> orders = [];

  OrderList({super.key, required this.orders});

  Future<String> getServiceName(String serviceId) async {
    String serviceName = 'Loading...';
    try {
      final response = await http.get(Uri.parse('${url}services/$serviceId'),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('service')) {
          final dynamic serviceData = data['service'];
          final Service service = Service.fromJson(serviceData);
          serviceName = service.name;
        }
      }
    } catch (error) {
      print('Error Fetching Service Name: $error');
    }
    return serviceName;
  }

  @override
  Widget build(BuildContext context) {
    // Accessing device-specific information
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        DataTable(
          columnSpacing: screenWidth * 0.07,
          columns: [
            DataColumn(
                label: Text(
              'ID',
              style: CTextTheme.greyTextTheme.headlineMedium,
            )),
            DataColumn(
                label: Text(
              'Date/Time',
              style: CTextTheme.greyTextTheme.headlineMedium,
            )),
            DataColumn(
                label: Text(
              'Tag ID',
              style: CTextTheme.greyTextTheme.headlineMedium,
            )),
            DataColumn(
                label: Text(
              'User ID',
              style: CTextTheme.greyTextTheme.headlineMedium,
            )),
            DataColumn(
                label: Text(
              'Service Type',
              style: CTextTheme.greyTextTheme.headlineMedium,
            )),
            DataColumn(
                label: Text(
              'Status',
              style: CTextTheme.greyTextTheme.headlineMedium,
            )),
            const DataColumn(label: Text('')),
          ],
          rows: orders
              .map(
                (order) => DataRow(cells: [
                  DataCell(Text(
                    order.orderNumber,
                    style: CTextTheme.blackTextTheme.headlineMedium,
                  )),
                  DataCell(Text(
                    order.getFormattedDateTime(order.createdAt),
                    style: CTextTheme.blackTextTheme.headlineMedium,
                  )),
                  DataCell(SizedBox(
                      width: 80,
                      child: Text(
                        order.barcodeID,
                        style: CTextTheme.blackTextTheme.headlineMedium,
                      ))),
                  DataCell(SizedBox(
                      width: 80,
                      child: Text(
                        order.user?.phoneNumber.toString() ?? 'Loading...',
                        style: CTextTheme.blackTextTheme.headlineMedium,
                      ))),
                  DataCell(SizedBox(
                    width: 100,
                    child: FutureBuilder<String>(
                      future: getServiceName(order.serviceId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text('Loading...');
                        } else if (snapshot.hasError) {
                          return const Text('Error');
                        } else {
                          return Text(
                            snapshot.data ?? 'Service Name Not Available',
                            style: CTextTheme.blackTextTheme.headlineMedium,
                          );
                        }
                      },
                    ),
                  )),
                  DataCell(
                    Text(
                      order.orderStage?.processingComplete.status == true
                          ? 'Ready'
                          : order.orderStage?.getInProgressStatus() ??
                              'Loading...',
                      style: CTextTheme.blackTextTheme.headlineMedium?.copyWith(
                          color: _getStatusColor(
                              order.orderStage?.processingComplete.status ==
                                      true
                                  ? 'Ready'
                                  : order.orderStage?.getInProgressStatus() ??
                                      'Loading...')),
                    ),
                  ),
                  DataCell(
                    ElevatedButton(
                      onPressed: () async {
                        String serviceName =
                            await getServiceName(order.serviceId);
                        checkOrderAction(order, serviceName, context);
                      },
                      child: Text(
                        'Check',
                        style: CTextTheme.blackTextTheme.headlineMedium,
                      ),
                    ),
                  ),
                ]),
              )
              .toList(),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  //TODO: Handle previous page button tap
                },
                icon: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFD7ECF7),
                  ),
                  child: const Icon(Icons.arrow_back),
                ),
              ),

              const SizedBox(width: 16), // Adjust spacing as needed
              Text(
                'Page 1 of 5', // Replace with actual page number
                style: CTextTheme.blackTextTheme.headlineMedium,
              ),
              const SizedBox(width: 16), // Adjust spacing as needed
              IconButton(
                onPressed: () {
                  //TODO: Handle next page button tap
                },
                icon: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFD7ECF7),
                  ),
                  child: const Icon(Icons.arrow_forward),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void checkOrderAction(Order order, String serviceName, BuildContext context) {
    final inProgressStatus = order.orderStage?.getInProgressStatus();

    switch (inProgressStatus) {
      case 'Pending':
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return PendingOrder(
              order: order,
              serviceName: serviceName,
            );
          },
        );
        break;
      case 'Processing':
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const OrderDetailPopUp(orderStatus: 'Processing');
          },
        );
        break;
      case 'Order Error':
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const OrderDetailPopUp(orderStatus: 'Order Error');
          },
        );
        break;
      case 'Ready':
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const OrderDetailPopUp(orderStatus: 'Ready');
          },
        );
        break;
      case 'Returned':
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const OrderDetailPopUp(orderStatus: 'Returned');
          },
        );
        break;
      default:
    }
  }

  // Function to determine status color
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.grey;
      case 'Processing':
        return Colors.orange;
      case 'Order Error':
        return Colors.red;
      case 'Ready':
        return Colors.green;
      case 'Returned':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

class OrderRow {
  final int id;
  final String dateTime;
  final String tagId;
  final String userId;
  final String serviceType;
  final String status;

  OrderRow({
    required this.id,
    required this.dateTime,
    required this.tagId,
    required this.userId,
    required this.serviceType,
    required this.status,
  });
}