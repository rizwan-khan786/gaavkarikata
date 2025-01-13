

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class BillsPage extends StatefulWidget {
//   @override
//   _BillsPageState createState() => _BillsPageState();
// }

// class _BillsPageState extends State<BillsPage> {
//   List<dynamic> bills = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchBills();
//   }

//   // Fetch bills data from the API
//   Future<void> fetchBills() async {
//     final url = Uri.parse('https://res-zpd2.onrender.com/api/bill/');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       setState(() {
//         bills = jsonDecode(response.body);
//         bills.sort((a, b) => b['_id'].compareTo(a['_id']));
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load bills')),
//       );
//     }
//   }

//   // Function to handle the payment (PUT request)
//   Future<void> payBill(String billId, String tableId) async {
//     final billUrl =
//         Uri.parse('https://res-zpd2.onrender.com/api/bill/$billId/pay');
//     final billResponse = await http.put(billUrl);

//     if (billResponse.statusCode == 200) {
//       final tableUrl =
//           Uri.parse('https://res-zpd2.onrender.com/api/table/$tableId/vacant');
//       final tableResponse = await http.put(tableUrl);

//       if (tableResponse.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Bill Paid and Table Vacant')),
//         );
//         fetchBills();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to mark table as vacant')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to pay bill')),
//       );
//     }
//   }

//   // Function to print a bill
//   void printBill(Map<String, dynamic> bill) {
//     String billData = '''
// Bill ID: ${bill['_id']}
// Total Amount: \$${bill['totalAmount']}
// Status: ${bill['status']}
// Table: ${bill['tableId']?['tableType'] ?? 'N/A'}
// Items: ${bill['items'].map((item) => '${item['dishName']} (\$${item['price']})').join(', ')}
//     ''';
//     print(billData); // Replace with actual print functionality if required
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Bill data printed to console')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Bills',
//           style: TextStyle(color: Colors.white, fontSize: 22),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: bills.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: bills.length,
//               itemBuilder: (context, index) {
//                 final bill = bills[index];
//                 return Card(
//                   margin:
//                       const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   elevation: 10,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Bill ID: ${bill['_id']}',
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18,
//                               color: Colors.deepPurple),
//                         ),
//                         const SizedBox(height: 8),
//                         bill['tableId'] != null
//                             ? Text(
//                                 'Table: ${bill['tableId']['tableType']}',
//                                 style: const TextStyle(
//                                     fontSize: 14, color: Colors.black54),
//                               )
//                             : const Text(
//                                 'Table: N/A',
//                                 style: TextStyle(
//                                     fontSize: 14, color: Colors.black54),
//                               ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Status: ${bill['status']}',
//                           style: const TextStyle(fontSize: 14),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Total Amount: \$${bill['totalAmount']}',
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 12),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Items: ',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 bill['items']
//                                     .map((item) => item['dishName'].toString())
//                                     .join(', '),
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.black87,
//                                 ),
//                                 overflow: TextOverflow
//                                     .ellipsis, // Optional: Handle long text gracefully
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         if (bill['status'] == 'Pending')
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               minimumSize: Size(double.infinity, 50),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               backgroundColor: Colors.deepPurple,
//                             ),
//                             onPressed: () {
//                               String tableId = bill['tableId']?['_id'] ?? '';
//                               payBill(bill['_id'], tableId);
//                             },
//                             child: const Text(
//                               'Paid',
//                               style:
//                                   TextStyle(color: Colors.white, fontSize: 18),
//                             ),
//                           ),
//                         const SizedBox(height: 10),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             minimumSize: Size(double.infinity, 50),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             backgroundColor: Colors.blue,
//                           ),
//                           onPressed: () => printBill(bill),
//                           child: const Text(
//                             'Print',
//                             style: TextStyle(color: Colors.white, fontSize: 18),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }




import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BillsPage extends StatefulWidget {
  @override
  _BillsPageState createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  List<dynamic> bills = [];

  @override
  void initState() {
    super.initState();
    fetchBills();
  }

  // Fetch bills data from the API
  Future<void> fetchBills() async {
    final url = Uri.parse('https://res-zpd2.onrender.com/api/bill/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        bills = jsonDecode(response.body);
        bills.sort((a, b) => b['_id'].compareTo(a['_id']));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load bills')),
      );
    }
  }

  // Function to handle the payment (PUT request)
  Future<void> payBill(String billId, String tableId) async {
    final billUrl =
        Uri.parse('https://res-zpd2.onrender.com/api/bill/$billId/pay');
    final billResponse = await http.put(billUrl);

    if (billResponse.statusCode == 200) {
      final tableUrl =
          Uri.parse('https://res-zpd2.onrender.com/api/table/$tableId/vacant');
      final tableResponse = await http.put(tableUrl);

      if (tableResponse.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bill Paid and Table Vacant')),
        );
        fetchBills();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to mark table as vacant')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pay bill')),
      );
    }
  }

  // Function to generate and display the PDF
  Future<void> generatePdf(Map<String, dynamic> bill) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Bill ID: ${bill['_id']}', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Table: ${bill['tableId']?['tableType'] ?? 'N/A'}'),
              pw.SizedBox(height: 10),
              pw.Text('Status: ${bill['status']}'),
              pw.SizedBox(height: 10),
              pw.Text('Total Amount: \$${bill['totalAmount']}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Items:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Column(
                children: (bill['items'] as List).map((item) {
                  return pw.Text('- ${item['dishName']} (\$${item['price']})');
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bills',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: bills.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: bills.length,
              itemBuilder: (context, index) {
                final bill = bills[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bill ID: ${bill['_id']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.deepPurple),
                        ),
                        const SizedBox(height: 8),
                        bill['tableId'] != null
                            ? Text(
                                'Table: ${bill['tableId']['tableType']}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              )
                            : const Text(
                                'Table: N/A',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                        const SizedBox(height: 8),
                        Text(
                          'Status: ${bill['status']}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total Amount: \$${bill['totalAmount']}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Items: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                bill['items']
                                    .map((item) => item['dishName'].toString())
                                    .join(', '),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (bill['status'] == 'Pending')
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: Colors.deepPurple,
                            ),
                            onPressed: () {
                              String tableId = bill['tableId']?['_id'] ?? '';
                              payBill(bill['_id'], tableId);
                            },
                            child: const Text(
                              'Paid',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () => generatePdf(bill),
                          child: const Text(
                            'Print',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}



// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class BillsPage extends StatefulWidget {
//   @override
//   _BillsPageState createState() => _BillsPageState();
// }

// class _BillsPageState extends State<BillsPage> {
//   List<dynamic> bills = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchBills();
//   }

//   Future<void> fetchBills() async {
//     final url = Uri.parse('https://res-zpd2.onrender.com/api/bill/');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       setState(() {
//         bills = jsonDecode(response.body);
//         bills.sort((a, b) => b['_id'].compareTo(a['_id']));
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load bills')),
//       );
//     }
//   }

//   Future<void> payBill(String billId, String tableId) async {
//     final billUrl =
//         Uri.parse('https://res-zpd2.onrender.com/api/bill/$billId/pay');
//     final billResponse = await http.put(billUrl);

//     if (billResponse.statusCode == 200) {
//       final tableUrl =
//           Uri.parse('https://res-zpd2.onrender.com/api/table/$tableId/vacant');
//       final tableResponse = await http.put(tableUrl);

//       if (tableResponse.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Bill Paid and Table Vacant')),
//         );
//         fetchBills();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to mark table as vacant')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to pay bill')),
//       );
//     }
//   }

//   Future<void> generateAndPrintPDF(Map<String, dynamic> bill) async {
//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) => pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text(
//               'Bill Receipt',
//               style: pw.TextStyle(
//                 fontSize: 24,
//                 fontWeight: pw.FontWeight.bold,
//               ),
//             ),
//             pw.SizedBox(height: 20),
//             pw.Text('Bill ID: ${bill['_id']}'),
//             pw.Text('Total Amount: \$${bill['totalAmount']}'),
//             pw.Text('Status: ${bill['status']}'),
//             pw.Text(
//               'Table: ${bill['tableId']?['tableType'] ?? 'N/A'}',
//             ),
//             pw.SizedBox(height: 10),
//             pw.Text('Items:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//             pw.Bullet(
//               text: bill['items']
//                   .map((item) => '${item['dishName']} (\$${item['price']})')
//                   .join(', '),
//             ),
//           ],
//         ),
//       ),
//     );

//     await Printing.layoutPdf(
//       onLayout: (PdfPageFormat format) async => pdf.save(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Bills',
//           style: TextStyle(color: Colors.white, fontSize: 22),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: bills.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: bills.length,
//               itemBuilder: (context, index) {
//                 final bill = bills[index];
//                 return Card(
//                   margin:
//                       const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   elevation: 10,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Bill ID: ${bill['_id']}',
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18,
//                               color: Colors.deepPurple),
//                         ),
//                         const SizedBox(height: 8),
//                         bill['tableId'] != null
//                             ? Text(
//                                 'Table: ${bill['tableId']['tableType']}',
//                                 style: const TextStyle(
//                                     fontSize: 14, color: Colors.black54),
//                               )
//                             : const Text(
//                                 'Table: N/A',
//                                 style: TextStyle(
//                                     fontSize: 14, color: Colors.black54),
//                               ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Status: ${bill['status']}',
//                           style: const TextStyle(fontSize: 14),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Total Amount: \$${bill['totalAmount']}',
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 12),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             minimumSize: Size(double.infinity, 50),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             backgroundColor: Colors.blue,
//                           ),
//                           onPressed: () => generateAndPrintPDF(bill),
//                           child: const Text(
//                             'Generate & Print PDF',
//                             style: TextStyle(color: Colors.white, fontSize: 18),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
