import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:senagat_mobile/src/features/pay/model/paymet_history_model.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'payment_history_format.dart';

const _downloadsChannel = MethodChannel('senagat_downloads');

const _green = PdfColor.fromInt(0xFF2C702C);
const _ink = PdfColor.fromInt(0xFF191B19);
const _muted = PdfColor.fromInt(0xFF6F736D);
const _line = PdfColor.fromInt(0xFFDADFD8);

String _invoiceFileName(int id) => 'senagat_kwitansiya_$id.pdf';

String _invoicePrefKey(int id) => 'payment_invoice_$id';

Future<String> savePaymentInvoice(PaymentHistoryModel item) async {
  final bytes = await _buildInvoice(item);
  final name = _invoiceFileName(item.id);
  final String location;

  if (Platform.isAndroid) {
    final saved = await _downloadsChannel.invokeMethod<String>('savePdf', {
      'name': name,
      'bytes': bytes,
    });
    if (saved == null || saved.isEmpty) {
      throw StateError('Invoice was not saved');
    }
    location = saved;
  } else {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes, flush: true);
    location = file.path;
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'application/pdf')],
        subject: 'Töleg kwitansiýasy',
      ),
    );
  }

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_invoicePrefKey(item.id), location);
  return location;
}

Future<String?> savedInvoiceLocation(PaymentHistoryModel item) async {
  final prefs = await SharedPreferences.getInstance();
  final key = _invoicePrefKey(item.id);
  final saved = prefs.getString(key);
  if (saved != null && await _locationExists(saved)) return saved;

  final found = await _findInvoice(item.id);
  if (found != null) {
    await prefs.setString(key, found);
    return found;
  }
  if (saved != null) await prefs.remove(key);
  return null;
}

Future<void> openPaymentInvoice(String location) async {
  if (Platform.isAndroid) {
    await _downloadsChannel.invokeMethod<void>('openPdf', {
      'location': location,
    });
    return;
  }

  await SharePlus.instance.share(
    ShareParams(
      files: [XFile(location, mimeType: 'application/pdf')],
      subject: 'Töleg kwitansiýasy',
    ),
  );
}

Future<void> forgetInvoice(int id) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_invoicePrefKey(id));
}

Future<bool> _locationExists(String location) async {
  if (location.startsWith('content://')) {
    if (!Platform.isAndroid) return false;
    final exists = await _downloadsChannel.invokeMethod<bool>('hasPdf', {
      'location': location,
    });
    return exists == true;
  }
  return File(location).exists();
}

Future<String?> _findInvoice(int id) async {
  final name = _invoiceFileName(id);
  if (Platform.isAndroid) {
    return _downloadsChannel.invokeMethod<String>('findPdf', {'name': name});
  }
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$name');
  if (await file.exists()) return file.path;
  return null;
}

Future<Uint8List> _buildInvoice(PaymentHistoryModel item) async {
  final regular = pw.Font.ttf(
    await rootBundle.load('assets/fonts/Kinetika-Regular.ttf'),
  );
  final bold = pw.Font.ttf(
    await rootBundle.load('assets/fonts/Kinetika-Bold.ttf'),
  );
  final logoBytes = await rootBundle.load(AppAssets.senagatIcon);
  final logo = pw.MemoryImage(
    logoBytes.buffer.asUint8List(
      logoBytes.offsetInBytes,
      logoBytes.lengthInBytes,
    ),
  );

  final document = pw.Document(
    theme: pw.ThemeData.withFont(base: regular, bold: bold),
  );

  document.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(36),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Image(logo, width: 72, height: 72),
                pw.SizedBox(width: 16),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Senagat bank',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 20,
                        color: _ink,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Töleg kwitansiýasy',
                      style: const pw.TextStyle(fontSize: 14, color: _green),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Container(height: 2, color: _green),
            pw.SizedBox(height: 28),
            pw.Text(
              _statusTm(item.status),
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 16,
                color: _statusColor(item.status),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              '${item.amount} TMT',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 28,
                color: _ink,
              ),
            ),
            pw.SizedBox(height: 24),
            _row('Hyzmat', paymentServiceNameTm(item.type)),
            _row('Töleg belgisi', paymentHistoryTarget(item)),
            _row('Senesi', item.createdAt),
            _row('Kwitansiýa belgisi', '${item.id}'),
            pw.SizedBox(height: 36),
            pw.Text(
              'Bu kwitansiýa tölegiň ýagdaýyny görkezýär.',
              style: const pw.TextStyle(fontSize: 11, color: _muted),
            ),
          ],
        );
      },
    ),
  );

  return document.save();
}

pw.Widget _row(String label, String value) {
  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(vertical: 12),
    decoration: const pw.BoxDecoration(
      border: pw.Border(bottom: pw.BorderSide(color: _line, width: 0.6)),
    ),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 160,
          child: pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 12, color: _muted),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
              color: _ink,
            ),
          ),
        ),
      ],
    ),
  );
}

String _statusTm(String status) {
  switch (status) {
    case 'confirmed':
      return 'Töleg kabul edildi';
    case 'pending':
      return 'Garaşylýar';
    case 'failed':
      return 'Ret edildi';
    default:
      return status;
  }
}

PdfColor _statusColor(String status) {
  switch (status) {
    case 'confirmed':
      return _green;
    case 'pending':
      return const PdfColor.fromInt(0xFFB97E00);
    case 'failed':
      return const PdfColor.fromInt(0xFFCC1717);
    default:
      return _muted;
  }
}
