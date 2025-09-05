import 'package:flutter/material.dart';
import 'package:triptide/models/itinerary_model.dart';

class EditItineraryScreen extends StatefulWidget {
  final ItineraryModel itineraryModel;

  const EditItineraryScreen({Key? key, required this.itineraryModel})
    : super(key: key);

  @override
  State<EditItineraryScreen> createState() => _EditItineraryScreenState();
}

class _EditItineraryScreenState extends State<EditItineraryScreen> {
  late List<List<String>> editableDays;

  @override
  void initState() {
    super.initState();
    editableDays = List.generate(
      widget.itineraryModel.days.length,
      (index) => widget.itineraryModel.getActivitiesForDay(index),
    );
  }

  void _saveChanges() {
    final updatedDays = editableDays
        .map((acts) => {'activities': acts})
        .toList();
    final updatedModel = ItineraryModel(
      id: widget.itineraryModel.id,
      title: widget.itineraryModel.title,
      destination: widget.itineraryModel.destination,
      duration: widget.itineraryModel.duration,
      startDate: widget.itineraryModel.startDate,
      endDate: widget.itineraryModel.endDate,
      budget: widget.itineraryModel.budget,
      people: widget.itineraryModel.people,
      days: updatedDays,
      mapCenter: widget.itineraryModel.mapCenter,
    );

    Navigator.pop(context, updatedModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Itinerary'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveChanges),
        ],
      ),
      body: ListView.builder(
        itemCount: editableDays.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Day ${index + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              ...editableDays[index].asMap().entries.map((entry) {
                final actIdx = entry.key;
                final act = entry.value;
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: act,
                        onChanged: (val) => editableDays[index][actIdx] = val,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          setState(() => editableDays[index].removeAt(actIdx)),
                    ),
                  ],
                );
              }),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Activity'),
                onPressed: () => setState(() => editableDays[index].add('')),
              ),
              const Divider(),
            ],
          );
        },
      ),
    );
  }
}
