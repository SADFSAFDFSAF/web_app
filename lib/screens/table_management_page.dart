import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/taple.dart';
import '../providers/table_management_provider.dart';
import '../widgtes/customer_list_panel..dart';
import '../widgtes/floor_plan_canvas.dart';

class TableManagementPage extends StatelessWidget {
  const TableManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool showCustomerPanel = screenWidth > 700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Tables'),
        leading: showCustomerPanel
            ? null
            : Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.calendar_today, color: Colors.white70),
            label: Text(
              'Tuesday, Jun 24',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(width: 10),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.access_time, color: Colors.white70),
            label: Text('1:54 PM', style: TextStyle(color: Colors.white70)),
          ),
          SizedBox(width: 10),
          DropdownButton<String>(
            value: 'Lunch',
            icon: Icon(Icons.arrow_drop_down, color: Colors.white),
            underline: SizedBox.shrink(),
            onChanged: (String? newValue) {},
            items: <String>['Lunch', 'Dinner', 'Breakfast']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
          ),
          SizedBox(width: 10),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      drawer: showCustomerPanel ? null : const Drawer(child: CustomerListPanel()),
      body: Row(
        children: [
          if (showCustomerPanel)
            const SizedBox(width: 300, child: CustomerListPanel()),
          Expanded(child: FloorPlanCanvas()),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[900],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_none, color: Colors.white70),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.bar_chart, color: Colors.white70),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.settings_outlined, color: Colors.white70),
              ),
              SizedBox(width: 50),
              ElevatedButton.icon(
                onPressed: () => _showAddTableDialog(context),
                icon: Icon(Icons.add_circle_outline, color: Colors.white),
                label: Text('New Table', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddTableDialog(BuildContext context) {
    TableShape selectedShape = TableShape.square;
    int capacity = 4;
    double width = 100;
    double height = 100;
    String? imagePath;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Table'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<TableShape>(
                value: selectedShape,
                decoration: InputDecoration(labelText: 'Shape'),
                items: TableShape.values.map((shape) {
                  return DropdownMenuItem(
                    value: shape,
                    child: Text(shape.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (shape) {
                  selectedShape = shape!;
                  if (selectedShape != TableShape.image) {
                    imagePath = null;
                  }
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: '4',
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Capacity'),
                onChanged: (value) => capacity = int.tryParse(value) ?? 4,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: '100',
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Width'),
                      onChanged: (value) => width = double.tryParse(value) ?? 100,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: '100',
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Height'),
                      onChanged: (value) => height = double.tryParse(value) ?? 100,
                    ),
                  ),
                ],
              ),
              if (selectedShape == TableShape.image) ...[
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    // In a real app, you would implement image picking here
                    // For demo purposes, we'll just use a placeholder
                    imagePath = 'assets/custom_table.png';
                  },
                  child: Text('Select Table Image'),
                ),
                if (imagePath != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Image selected',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<TableManagementProvider>(context, listen: false).addNewTable(
                shape: selectedShape,
                capacity: capacity,
                size: Size(width, height),
                imagePath: imagePath,
              );
              Navigator.pop(context);
            },
            child: Text('Add Table'),
          ),
        ],
      ),
    );
  }
}