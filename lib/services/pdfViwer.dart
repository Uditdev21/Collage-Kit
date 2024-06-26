import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PDFViewerPage extends StatefulWidget {
  final String pdfUrl;

  const PDFViewerPage({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  late PDFViewController _pdfViewController;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          if (_localFilePath != null)
            PDFView(
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
              onRender: (_pages) {
                setState(() {
                  _isLoading = false;
                });
              },
              onError: (error) {
                print('Error loading PDF: $error');
                setState(() {
                  _isLoading = false;
                });
              },
            ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Future<void> _fetchTotalPages() async {
    try {
      int totalPages = await _pdfViewController.getPageCount() ?? 0;
      setState(() {
        _totalPages = totalPages;
      });
    } catch (e) {
      print('Error fetching total pages: $e');
      setState(() {
        _totalPages = 0;
      });
    }
  }
}
