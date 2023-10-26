import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shades/features/resource_mgt/download_success.dart';
import 'package:shades/features/resource_mgt/resource.dart';

class ViewPdfForm extends StatefulWidget {
  const ViewPdfForm({super.key});

  @override
  State<ViewPdfForm> createState() => _ViewPdfFormState();
}

class _ViewPdfFormState extends State<ViewPdfForm> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> pdfList = [];
  bool downloading = false;

  void getAllPdf() async {
    final allPdfs = await _firebaseFirestore.collection("resources_pdfs").get();
    pdfList = allPdfs.docs.map((e) => e.data()).toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllPdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(20, 108, 148, 1.000),
          title: const Text('View PDF'),
        ),
        body: GridView.builder(
            itemCount: pdfList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8, top: 0, bottom: 0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PdfViewerScreen(
                                pdfurl: pdfList[index]['url'],
                              )));
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(
                              color: Color.fromARGB(255, 177, 177, 177),
                              width: 1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            "assets/resource/PDF.jpg",
                            height: 70,
                            width: 100,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8, top: 5),
                            child: Center(
                              child: Text(
                                pdfList[index]['fileName'] ??
                                    'Unknown', // Use a default value if 'name' is null
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cloud_download_sharp,
                                size: 35),
                            onPressed: () {
                              downloadAndOpenPdf(pdfList[index]['url'],
                                  pdfList[index]['fileName']);
                            },
                          ),
                        ],
                      ),
                    ),
                  ));
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  const Resourceoperations(), // Navigate to Resourceoperations
            ));
          },
          backgroundColor: const Color.fromRGBO(20, 108, 148, 1.000),
          child: const Icon(Icons.home),
        ));
  }

  void downloadAndOpenPdf(String pdfUrl, String fileName) async {
    try {
      setState(() {
        // Set a flag to indicate that download is in progress
        downloading = true;
      });
      var response = await http.get(Uri.parse(pdfUrl));
      if (response.statusCode == 200) {
        var time = DateTime.now().millisecondsSinceEpoch;
        var path = '/storage/emulated/0/Download/$fileName-$time.pdf';
        var file = File(path);
        await file.writeAsBytes(response.bodyBytes);
        print('File downloaded to: $path');

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const DownloadSuccess(),
        ));
        // });
      } else {
        print(
            'Failed to download the file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        // Set the flag to indicate that download is complete
        downloading = false;
      });
    }
  }
}

class PdfViewerScreen extends StatefulWidget {
  final String pdfurl;
  const PdfViewerScreen({super.key, required this.pdfurl});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PDFDocument? document;

  void initialisePdf() async {
    document = await PDFDocument.fromURL(widget.pdfurl);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initialisePdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: document != null
          ? PDFViewer(
              document: document!,
            )
          : const Center(
              child: CircularProgressIndicator(
              strokeWidth: 6,
              backgroundColor: Colors.grey,
            )),
    );
  }
}
