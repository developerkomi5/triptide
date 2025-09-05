import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:triptide/models/itinerary_model.dart';

Future<void> shareItineraryAsPdf(ItineraryModel it) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              it.title,
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 12),
            pw.Text('Destination: ${it.destination}'),
            pw.Text('Duration: ${it.duration} days'),
            pw.SizedBox(height: 12),
            pw.Text('Itinerary:', style: pw.TextStyle(fontSize: 18)),
            ...List.generate(it.days.length, (index) {
              final day = it.days[index];
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Day ${index + 1}:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Bullet(
                    text: (day['activities'] is List)
                        ? List<String>.from(
                            day['activities'].whereType<String>(),
                          ).join(', ')
                        : 'No activities',
                  ),

                  pw.SizedBox(height: 8),
                ],
              );
            }),
          ],
        );
      },
    ),
  );

  final output = await getTemporaryDirectory();
  final file = File('${output.path}/${it.title.replaceAll(' ', '_')}.pdf');
  await file.writeAsBytes(await pdf.save());

  await Share.shareXFiles([
    XFile(file.path),
  ], text: 'Check out this itinerary!');
}

Future<void> shareItineraryAsText(ItineraryModel it) async {
  final buffer = StringBuffer();
  buffer.writeln('${it.title}');
  buffer.writeln('Destination: ${it.destination}');
  buffer.writeln('Duration: ${it.duration} days\n');
  buffer.writeln('Itinerary:');

  for (int i = 0; i < it.days.length; i++) {
    buffer.writeln('Day ${i + 1}:');
    final activities = it.getActivitiesForDay(i);
    for (final activity in activities) {
      buffer.writeln('- $activity');
    }
    buffer.writeln('');
  }

  await Share.share(buffer.toString(), subject: 'TripTide Itinerary');
}
