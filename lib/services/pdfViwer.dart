import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PDFViewerPage extends StatefulWidget {
  final String pdfUrl;

  const PDFViewerPage({super.key, required this.pdfUrl});

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  PDFViewController? _pdfViewController;
  int _pageNumber = 1;
  int _totalPages = 0;
  bool _isLoading = true;
  String? _localFilePath;

  @override
  void initState() {
    super.initState();
    _downloadPDF();
  }

  Future<void> _downloadPDF() async {
    try {
      final response = await http.get(Uri.parse(widget.pdfUrl));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/temp.pdf';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        setState(() {
          _localFilePath = filePath;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load PDF');
      }
    } catch (e) {
      print('Error downloading PDF: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        centerTitle: true,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Stack(
            children: [
              Container(
                color:
                    Colors.grey[200], // Set your desired background color here
                child: _localFilePath != null
                    ? PDFView(
                        fitPolicy: FitPolicy.BOTH,
                        fitEachPage: true,
                        filePath: _localFilePath,
                        autoSpacing: true,
                        pageSnap: true,
                        swipeHorizontal: true,
                        onViewCreated: (PDFViewController vc) {
                          _pdfViewController = vc;
                          _fetchTotalPages();
                        },
                        onPageChanged: (int? page, int? total) {
                          if (page != null) {
                            setState(() {
                              _pageNumber = page;
                            });
                          }
                        },
                        onRender: (pages) {
                          _fetchTotalPages();
                        },
                        onError: (error) {
                          print('Error loading PDF: $error');
                          setState(() {
                            _isLoading = false;
                          });
                        },
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'previousPage', // Unique heroTag
            onPressed: _previousPage,
            child: const Icon(Icons.arrow_upward),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'nextPage', // Unique heroTag
            onPressed: _nextPage,
            child: const Icon(Icons.arrow_downward),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Page $_pageNumber of $_totalPages',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Future<void> _fetchTotalPages() async {
    try {
      if (_pdfViewController != null) {
        int totalPages = await _pdfViewController!.getPageCount() ?? 0;
        setState(() {
          _totalPages = totalPages;
        });
      }
    } catch (e) {
      print('Error fetching total pages: $e');
      setState(() {
        _totalPages = 0;
      });
    }
  }

  void _nextPage() async {
    if (_pageNumber < _totalPages && _pdfViewController != null) {
      await _pdfViewController!.setPage(_pageNumber + 1);
      setState(() {});
    }
  }

  void _previousPage() async {
    if (_pageNumber > 0 && _pdfViewController != null) {
      await _pdfViewController!.setPage(_pageNumber - 1);
      setState(() {});
    }
  }
}
