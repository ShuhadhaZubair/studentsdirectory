import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Controller.dart';

class Admindashboard extends StatelessWidget {
  Admindashboard({super.key});
  final controller = Get.find<AdminDashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              controller.updateSearchQuery(value);
            },
            decoration: InputDecoration(
              labelText: 'Search Students',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              final students = controller.students.where((doc) {
                String studentName = doc["name"].toString().toLowerCase();
                return studentName.contains(controller.searchQuery.value);
              }).toList();

              if (students.isEmpty) {
                return Center(child: Text("No students found"));
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: students.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return DataRow(cells: [
                      DataCell(Text(data['name'])),
                      DataCell(
                        data['status'] == 0
                            ? Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                controller.updateStudentStatus(doc.id, 1);
                              },
                              child: Text('Accept',
                                  style: TextStyle(
                                      color: Colors.green.shade800,
                                      fontWeight: FontWeight.bold)),
                            ),
                            TextButton(
                              onPressed: () {
                                controller.updateStudentStatus(doc.id, 2);
                              },
                              child: Text('Reject',
                                  style: TextStyle(
                                      color: Colors.red.shade800,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        )
                            : Center(
                          child: Text(
                            data['status'] == 1
                                ? 'Accepted'
                                : 'Rejected',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: data['status'] == 1
                                  ? Colors.green.shade800
                                  : Colors.red.shade800,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'delete') {
                              controller.deleteStudent(doc.id);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete'),
                                ],
                              ),
                            ),
                          ],
                          icon: Icon(Icons.more_vert),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
