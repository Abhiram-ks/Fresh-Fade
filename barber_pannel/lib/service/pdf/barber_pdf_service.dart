
import 'dart:io' as io;
import 'package:barber_pannel/features/auth/domain/entity/barber_entity.dart';
import 'package:barber_pannel/features/app/domain/entity/barber_service_entity.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class BarberPdfService {
  static Future<bool> generateBarberProfilePdf({
    required BarberEntity barber,
    List<BarberServiceEntity>? services,
  }) async {
    final pdf = pw.Document();

    // Load logo
    final logoData = await rootBundle.load('assets/freshfade_logo.png');
    final logo = pw.MemoryImage(logoData.buffer.asUint8List());

    // Load barber shop images if available
    pw.MemoryImage? shopImage;
    pw.MemoryImage? detailImage;

    try {
      if (barber.image != null && barber.image!.isNotEmpty) {
        final imageBytes = await _loadImageFromUrl(barber.image!);
        if (imageBytes != null) {
          shopImage = pw.MemoryImage(imageBytes);
        }
      }

      if (barber.detailImage != null && barber.detailImage!.isNotEmpty) {
        final detailBytes = await _loadImageFromUrl(barber.detailImage!);
        if (detailBytes != null) {
          detailImage = pw.MemoryImage(detailBytes);
        }
      }
      } catch (e) {
        throw Exception(e);
    }

    String str(dynamic v) => v?.toString() ?? "-";

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          // Header Section
          _buildHeader(logo),
          pw.SizedBox(height: 24),

          if (shopImage != null || detailImage != null) ...[
            _buildImagesSection(shopImage, detailImage),
            pw.SizedBox(height: 24),
          ],

          // Barber Shop Information
          _buildInfoSection(barber, str),
          pw.SizedBox(height: 24),

          // Services Section
          if (services != null && services.isNotEmpty) ...[
            _buildServicesSection(services),
            pw.SizedBox(height: 24),
          ],

          // Footer
          _buildFooter(barber),
        ],
      ),
    );

    // Save and open PDF
    return await _savePdf(pdf, barber.ventureName);
  }

  /// Build header with logo and title
  static pw.Widget _buildHeader(pw.MemoryImage logo) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.grey300,
            width: 1,
          ),
        ),
      ),
      padding: const pw.EdgeInsets.only(bottom: 16),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Image(logo, height: 50, fit: pw.BoxFit.contain),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'BARBER PROFILE',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey800,
                ),
              ),
              pw.Text(
                'Fresh Fade : Business',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build images section
  static pw.Widget _buildImagesSection(
    pw.MemoryImage? shopImage,
    pw.MemoryImage? detailImage,
  ) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      padding: const pw.EdgeInsets.all(16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Shop Gallery',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey800,
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            children: [
              if (shopImage != null)
                pw.Expanded(
                  child: pw.Container(
                    margin: const pw.EdgeInsets.only(right: 8),
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(color: PdfColors.grey300),
                    ),
                    child: pw.ClipRRect(
                      horizontalRadius: 8,
                      verticalRadius: 8,
                      child: pw.Image(
                        shopImage,
                        height: 140,
                        fit: pw.BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              if (detailImage != null)
                pw.Expanded(
                  child: pw.Container(
                    margin: const pw.EdgeInsets.only(left: 8),
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(color: PdfColors.grey300),
                    ),
                    child: pw.ClipRRect(
                      horizontalRadius: 8,
                      verticalRadius: 8,
                      child: pw.Image(
                        detailImage,
                        height: 140,
                        fit: pw.BoxFit.cover,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build information section
  static pw.Widget _buildInfoSection(BarberEntity barber, String Function(dynamic) str) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [
          // Section Header
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey800,
              borderRadius: const pw.BorderRadius.only(
                topLeft: pw.Radius.circular(8),
                topRight: pw.Radius.circular(8),
              ),
            ),
            child: pw.Text(
              'Business Information',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            ),
          ),
          // Info Content
          pw.Padding(
            padding: const pw.EdgeInsets.all(16),
            child: pw.Column(
              children: [
                _buildInfoRow('Venture Name', str(barber.ventureName), isFirst: true),
                _buildInfoRow('Owner Name', str(barber.barberName)),
                _buildInfoRow('Email', str(barber.email)),
                _buildInfoRow('Phone Number', str(barber.phoneNumber)),
                _buildInfoRow('Address', str(barber.address)),
                _buildInfoRow('Gender Specialization', str(barber.gender)),
                _buildInfoRow('Established Year', str(barber.age)),
                _buildInfoRow(
                  'Verification Status',
                  barber.isVerified ? 'Verified' : 'Pending',
                  valueColor: barber.isVerified ? PdfColors.green700 : PdfColors.orange700,
                ),
                _buildInfoRow(
                  'Account Status',
                  barber.isBloc ? 'Blocked' : 'Active',
                  valueColor: barber.isBloc ? PdfColors.red700 : PdfColors.green700,
                ),
                if (barber.createdAt != null)
                  _buildInfoRow(
                    'Registered Since',
                    _formatDate(barber.createdAt!),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build services section
  static pw.Widget _buildServicesSection(List<BarberServiceEntity> services) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [
          // Section Header
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey800,
              borderRadius: const pw.BorderRadius.only(
                topLeft: pw.Radius.circular(8),
                topRight: pw.Radius.circular(8),
              ),
            ),
            child: pw.Text(
              'Services Offered',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            ),
          ),
          // Services Table
          pw.Table(
            border: pw.TableBorder(
              horizontalInside: pw.BorderSide(color: PdfColors.grey300),
            ),
            columnWidths: {
              0: const pw.FlexColumnWidth(1),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FlexColumnWidth(2),
            },
            children: [
              // Table Header
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey100,
                ),
                children: [
                  _buildTableCell('#', isHeader: true),
                  _buildTableCell('Service Name', isHeader: true),
                  _buildTableCell('Rate (₹)', isHeader: true, align: pw.TextAlign.right),
                ],
              ),
              ...services.asMap().entries.map((entry) {
                final index = entry.key;
                final service = entry.value;
                return pw.TableRow(
                  children: [
                    _buildTableCell('${index + 1}'),
                    _buildTableCell(service.serviceName),
                    _buildTableCell(
                      '₹${service.serviceRate.toStringAsFixed(2)}',
                      align: pw.TextAlign.right,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                );
              }),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey100,
                ),
                children: [
                  _buildTableCell(''),
                  _buildTableCell(
                    'Total Services',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  _buildTableCell(
                    '${services.length}',
                    align: pw.TextAlign.right,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(BarberEntity barber) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Generated on: ${_formatDate(DateTime.now())}',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey700,
                ),
              ),
              pw.Text(
                'ID: ${barber.uid}',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            '© FreshFade - Barber Management System',
            style: pw.TextStyle(
              fontSize: 9,
              color: PdfColors.grey600,
              fontStyle: pw.FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  /// Helper to build info row
  static pw.Widget _buildInfoRow(
    String label,
    String value, {
    bool isFirst = false,
    PdfColor? valueColor,
  }) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: isFirst
            ? null
            : pw.Border(
                top: pw.BorderSide(color: PdfColors.grey200),
              ),
      ),
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 140,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 11,
                color: PdfColors.grey700,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 11,
                color: valueColor ?? PdfColors.grey900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper to build table cell
  static pw.Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    pw.TextAlign align = pw.TextAlign.left,
    pw.TextStyle? style,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        textAlign: align,
        style: style ??
            pw.TextStyle(
              fontSize: isHeader ? 11 : 10,
              fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: isHeader ? PdfColors.grey800 : PdfColors.grey900,
            ),
      ),
    );
  }

  /// Format date to readable string
  static String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Load image from URL
  static Future<Uint8List?> _loadImageFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Save PDF and open it
  static Future<bool> _savePdf(pw.Document pdf, String ventureName) async {
    try {
      final bytes = await pdf.save();
      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final safeName = ventureName.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(' ', '_');
      final file = io.File("${dir.path}/barber_profile_${safeName}_$timestamp.pdf");

      await file.writeAsBytes(bytes);
      try {
        final result = await OpenFilex.open(file.path);
        if (result.type == ResultType.done) {

        } else {
          throw Exception('PDF saved but could not auto-open: ${result.message}');
        }
      } catch (openError) {
        throw Exception(openError);
      }
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }
}

