// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class MenuPage extends StatefulWidget {
//   @override
//   _MenuPageState createState() => _MenuPageState();
// }

// class _MenuPageState extends State<MenuPage> {
//   List<dynamic> menuItems = [];
//   List<dynamic> filteredMenuItems = [];
//   String selectedDishType = 'All'; // Filter for dishType
//   TextEditingController searchController = TextEditingController();
//   List<dynamic> availableTables = [];
//   String selectedTableId = '';

//   @override
//   void initState() {
//     super.initState();
//     fetchMenu();
//     fetchAvailableTables();
//     searchController.addListener(() {
//       filterMenu();
//     });
//   }

//   // Fetch menu data from API
//   Future<void> fetchMenu() async {
//     final url = Uri.parse('https://res-zpd2.onrender.com/api/menu/');
//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       setState(() {
//         menuItems = jsonDecode(response.body);
//         filteredMenuItems = menuItems;
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load menu items')),
//       );
//     }
//   }

//   // Fetch available tables
//  Future<void> fetchAvailableTables() async {
//   final url = Uri.parse('https://res-zpd2.onrender.com/api/table/');
//   final response = await http.get(url);
//   if (response.statusCode == 200) {
//     try {
//       final responseData = jsonDecode(response.body);

//       print(responseData); // Print the full response

//       // Access the 'tables' key from the first object in the list
//       final tables = responseData[0]['tables'];

//       if (tables is List) {
//         // If 'tables' is indeed a List, proceed with filtering
//         print("tables is a List");
//         print(tables.runtimeType); // It should be List<dynamic>

//         setState(() {
//           availableTables = tables.where((table) {
//             return table['isVacant'] == true;  // Filter vacant tables
//           }).toList();
//         });
//       } else {
//         print("Error: tables is not a List");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: tables is not a List')),
//         );
//       }
//     } catch (e) {
//       print('Error parsing data: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load available tables')),
//       );
//     }
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Failed to load tables')),
//     );
//   }
// }

//   // Filter menu by dishType and search by dishName
//   void filterMenu() {
//     setState(() {
//       filteredMenuItems = menuItems.where((item) {
//         bool matchesDishType =
//             selectedDishType == 'All' || item['dishType'] == selectedDishType;
//         bool matchesSearchQuery = item['dishName']
//             .toLowerCase()
//             .contains(searchController.text.toLowerCase());

//         return matchesDishType && matchesSearchQuery;
//       }).toList();
//     });
//   }

//   // Filter dishes by type
//   void filterByDishType(String type) {
//     setState(() {
//       selectedDishType = type;
//       filterMenu();
//     });
//   }

//   // Occupy a table
//   Future<void> occupyTable(String tableId) async {
//     final url =
//         Uri.parse('https://res-zpd2.onrender.com/api/table/occupy/$tableId');
//     final response = await http.put(url);
//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Table occupied successfully')),
//       );
//       fetchAvailableTables(); // Refresh available tables
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to occupy table')),
//       );
//     }
//   }

//   // Generate bill
//  Future<void> generateBill(String tableId, List<String> itemIds) async {
//   final url = Uri.parse('https://res-zpd2.onrender.com/api/bill/');
//   final response = await http.post(
//     url,
//     body: jsonEncode({
//       'tableId': tableId,
//       'items': itemIds,
//     }),
//     headers: {
//       'Content-Type': 'application/json',
//     },
//   );

//   print('Response Status: ${response.statusCode}');
//   print('Response Body: ${response.body}');

//   if (response.statusCode == 200) {
//     try {
//       final billData = jsonDecode(response.body);
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Bill Generated'),
//             content: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 for (var item in billData['items'])
//                   Text('${item['dishName']} - \$${item['price']}'),
//                 SizedBox(height: 10),
//                 Text('Total: \$${billData['totalAmount']}'),
//                 Text('Status: ${billData['status']}'),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text('Close'),
//               ),
//             ],
//           );
//         },
//       );
//     } catch (e) {
//       print('Error parsing bill data: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to parse bill data')),
//       );
//     }
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Generate bill')),
//     );
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Menu'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_list),
//             onPressed: () {
//               _showDishTypeFilterDialog();
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Search bar
//             TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 labelText: 'Search by Dish Name',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             // Dish grid view
//             Expanded(
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2, // Number of columns
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                   childAspectRatio: 0.75,
//                 ),
//                 itemCount: filteredMenuItems.length,
//                 itemBuilder: (context, index) {
//                   final item = filteredMenuItems[index];
//                   return GestureDetector(
//                     onTap: () async {
//                       // Display table options for selecting a table
//                       String? tableId = await _selectTableDialog();
//                       if (tableId != null) {
//                         // Generate bill with selected table and item
//                         generateBill(tableId, [item['_id']]);
//                       }
//                     },
//                     child: Card(
//                       elevation: 5,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Image.network(
//                             'https://res-zpd2.onrender.com/${item['image']}',
//                             width: double.infinity,
//                             height: 120,
//                             fit: BoxFit.cover,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   item['dishName'],
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 5),
//                                 Text('Type: ${item['dishType']}'),
//                                 const SizedBox(height: 5),
//                                 Text('Price: \$${item['price']}'),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Show filter dialog for dishType
//   void _showDishTypeFilterDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Filter by Dish Type'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 title: const Text('All'),
//                 onTap: () {
//                   filterByDishType('All');
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: const Text('Chinese'),
//                 onTap: () {
//                   filterByDishType('Chinese');
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: const Text('Starter'),
//                 onTap: () {
//                   filterByDishType('Starter');
//                   Navigator.pop(context);
//                 },
//               ),
//               // Add more dish types here if needed
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // Show dialog to select a table
//   Future<String?> _selectTableDialog() {
//     return showDialog<String>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Select a Table'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: availableTables.map<Widget>((table) {
//               return ListTile(
//                 title: Text('Table ${table['tableType']}'),
//                 subtitle: Text('Seats: ${table['tablecount']}'),
//                 trailing: Icon(
//                   Icons.check_circle,
//                   color: table['isVacant'] ? Colors.green : Colors.red,
//                 ),
//                 onTap: () {
//                   if (table['isVacant']) {
//                     Navigator.pop(context, table['_id']);
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Table is not vacant')),
//                     );
//                   }
//                 },
//               );
//             }).toList(),
//           ),
//         );
//       },
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<dynamic> menuItems = [];
  List<dynamic> filteredMenuItems = [];
  String selectedDishType = 'All'; // Filter for dishType
  TextEditingController searchController = TextEditingController();
  List<dynamic> availableTables = [];
  String selectedTableId = '';

  @override
  void initState() {
    super.initState();
    fetchMenu();
    fetchAvailableTables();
    searchController.addListener(() {
      filterMenu();
    });
  }

  // Fetch menu data from API
  Future<void> fetchMenu() async {
    final url = Uri.parse('https://res-zpd2.onrender.com/api/menu/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        menuItems = jsonDecode(response.body);
        filteredMenuItems = menuItems;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load menu items')),
      );
    }
  }

  // Fetch available tables
  Future<void> fetchAvailableTables() async {
    final url = Uri.parse('https://res-zpd2.onrender.com/api/table/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      try {
        final responseData = jsonDecode(response.body);

        print(responseData); // Print the full response

        // Access the 'tables' key from the first object in the list
        final tables = responseData[0]['tables'];

        if (tables is List) {
          // If 'tables' is indeed a List, proceed with filtering
          print("tables is a List");
          print(tables.runtimeType); // It should be List<dynamic>

          setState(() {
            availableTables = tables.where((table) {
              return table['isVacant'] == true; // Filter vacant tables
            }).toList();
          });
        } else {
          print("Error: tables is not a List");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: tables is not a List')),
          );
        }
      } catch (e) {
        print('Error parsing data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load available tables')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load tables')),
      );
    }
  }

  // Filter menu by dishType and search by dishName
  void filterMenu() {
    setState(() {
      filteredMenuItems = menuItems.where((item) {
        bool matchesDishType =
            selectedDishType == 'All' || item['dishType'] == selectedDishType;
        bool matchesSearchQuery = item['dishName']
            .toLowerCase()
            .contains(searchController.text.toLowerCase());

        return matchesDishType && matchesSearchQuery;
      }).toList();
    });
  }

  // Filter dishes by type
  void filterByDishType(String type) {
    setState(() {
      selectedDishType = type;
      filterMenu();
    });
  }

  // Occupy a table (PUT request)
  Future<void> occupyTable(String tableId) async {
    final url =
        Uri.parse('https://res-zpd2.onrender.com/api/table/occupy/$tableId');
    final response = await http.put(url);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Table occupied successfully')),
      );
      fetchAvailableTables(); // Refresh available tables
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to occupy table')),
      );
    }
  }

  // Generate bill
  Future<void> generateBill(String tableId, List<String> itemIds) async {
    final url = Uri.parse('https://res-zpd2.onrender.com/api/bill/');
    final response = await http.post(
      url,
      body: jsonEncode({
        'tableId': tableId,
        'items': itemIds,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final billData = jsonDecode(response.body);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Bill Generated'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var item in billData['items'])
                    Text('${item['dishName']} - \$${item['price']}'),
                  SizedBox(height: 10),
                  Text('Total: \$${billData['totalAmount']}'),
                  Text('Status: ${billData['status']}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('Error parsing bill data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to parse bill data')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Generate bill')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Bills',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list,color: Colors.white,),
            onPressed: () {
              _showDishTypeFilterDialog();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by Dish Name',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Dish grid view
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: filteredMenuItems.length,
                itemBuilder: (context, index) {
                  final item = filteredMenuItems[index];
                  return GestureDetector(
                    onTap: () async {
                      // Display table options for selecting a table
                      String? tableId = await _selectTableDialog();
                      if (tableId != null) {
                        // Generate bill with selected table and item
                        generateBill(tableId, [item['_id']]);
                      }
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            'https://res-zpd2.onrender.com/${item['image']}',
                            width: double.infinity,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['dishName'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text('Type: ${item['dishType']}'),
                                const SizedBox(height: 5),
                                Text('Price: \$${item['price']}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show filter dialog for dishType
  void _showDishTypeFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter by Dish Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('All'),
                onTap: () {
                  filterByDishType('All');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Chinese'),
                onTap: () {
                  filterByDishType('Chinese');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Starter'),
                onTap: () {
                  filterByDishType('Starter');
                  Navigator.pop(context);
                },
              ),
              // Add more dish types here if needed
            ],
          ),
        );
      },
    );
  }

  // Show dialog to select a table
  Future<String?> _selectTableDialog() {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select a Table'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: availableTables.map<Widget>((table) {
              return ListTile(
                title: Text('Table ${table['tableType']}'),
                subtitle: Text('Seats: ${table['tablecount']}'),
                trailing: Icon(
                  Icons.check_circle,
                  color: table['isVacant'] ? Colors.green : Colors.red,
                ),
                onTap: () {
                  if (table['isVacant']) {
                    Navigator.pop(context, table['_id']);
                    occupyTable(table['_id']); // Mark the table as occupied
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Table is not vacant')),
                    );
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
