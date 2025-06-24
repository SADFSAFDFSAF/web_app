import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/customer.dart';
import '../providers/table_management_provider.dart';
import 'customer_list_item.dart';

class CustomerListPanel extends StatelessWidget {
  const CustomerListPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TableManagementProvider>(
      builder: (context, provider, child) {
        final seatedCustomers =
        provider.customers.where((c) => c.status == CustomerStatus.seated).toList();
        final waitingCustomers =
        provider.customers.where((c) => c.status == CustomerStatus.waiting).toList();
        final finishedCustomers =
        provider.customers.where((c) => c.status == CustomerStatus.finished).toList();

        return Container(
          color: Colors.grey[900],
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Customers',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    _buildCustomerSection(
                      context,
                      'Seated',
                      seatedCustomers,
                      provider,
                    ),
                    _buildCustomerSection(
                      context,
                      'Waiting',
                      waitingCustomers,
                      provider,
                    ),
                    _buildCustomerSection(
                      context,
                      'Finished',
                      finishedCustomers,
                      provider,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomerSection(
      BuildContext context,
      String title,
      List<Customer> customerList,
      TableManagementProvider provider,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (customerList.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'No ${title.toLowerCase()} customers.',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ),
        ...customerList
            .map(
              (customer) => CustomerListItem(
            customer: customer,
            onMarkFinished: () => provider.markCustomerFinished(customer.id),
          ),
        )
            .toList(),
      ],
    );
  }
}