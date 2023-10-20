import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class ViewPdfForm extends StatefulWidget {
  const ViewPdfForm({super.key});

  @override
  State<ViewPdfForm> createState() => _ViewPdfFormState();
}

class _ViewPdfFormState extends State<ViewPdfForm> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> pdfList = [];

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
          title: const Text('View PDF'),
        ),
        body: GridView.builder(
            itemCount: pdfList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.all(10),
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
                              color: Color.fromARGB(255, 8, 23, 45), width: 1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            "assets/resource/PDF.jpg",
                            height: 90,
                            width: 100,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: Center(
                              child: Text(
                                pdfList[index]['name'],
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: () {}, child: const Icon(Icons.upload_file)));
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
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
