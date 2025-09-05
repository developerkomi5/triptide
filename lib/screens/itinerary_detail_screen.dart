import 'package:flutter/material.dart';
import 'package:triptide/models/itinerary_model.dart';
import 'package:triptide/screens/personalize/edit_itinerary_screen.dart';
import 'package:triptide/screens/share_itinerary.dart';

class ItineraryDetailScreen extends StatefulWidget {
  final ItineraryModel itineraryModel;

  const ItineraryDetailScreen({Key? key, required this.itineraryModel})
    : super(key: key);

  @override
  State<ItineraryDetailScreen> createState() => _ItineraryDetailScreenState();
}

class _ItineraryDetailScreenState extends State<ItineraryDetailScreen> {
  late ItineraryModel itinerary;
  final ValueNotifier<int?> _openDay = ValueNotifier<int?>(null);

  @override
  void initState() {
    super.initState();
    itinerary = widget.itineraryModel;
  }

  @override
  Widget build(BuildContext context) {
    final it = itinerary;

    return Scaffold(
      appBar: AppBar(
        title: Text(itinerary.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.picture_as_pdf),
                      title: Text('Share as PDF'),
                      onTap: () {
                        Navigator.pop(context);
                        shareItineraryAsPdf(itinerary);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.text_snippet),
                      title: Text('Share as Text'),
                      onTap: () {
                        Navigator.pop(context);
                        shareItineraryAsText(itinerary);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      EditItineraryScreen(itineraryModel: itinerary),
                ),
              );

              if (updated != null && updated is ItineraryModel) {
                setState(() {
                  itinerary = updated;
                });
                print(itinerary.days);
              }
            },
          ),
          /*IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete',
            onPressed: () => _confirmDelete(context),
          ),*/
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Location details coming soon',
            style: TextStyle(color: Colors.grey),
          ),

          ValueListenableBuilder<int?>(
            valueListenable: _openDay,
            builder: (context, openIndex, _) {
              return ExpansionPanelList.radio(
                expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 8),
                children: it.days.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final activities = it.getActivitiesForDay(idx);

                  return ExpansionPanelRadio(
                    value: idx,
                    headerBuilder: (_, __) =>
                        ListTile(title: Text('Day ${idx + 1}')),
                    body: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: activities
                            .map(
                              (act) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Text('• $act'),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  /*void _confirmDelete(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Delete this itinerary?'),
        content: const Text('This action cannot be undone. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: delete logic
              Navigator.pop(ctx); // close dialog
              Navigator.pop(ctx); // back to HomeScreen
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }*/
}
