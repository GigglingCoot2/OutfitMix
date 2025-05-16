import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: calendarScreen(),
    );
  }
}

class calendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<calendarScreen> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  late final Map<DateTime, List<Event>> _events;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();

    _events = {};

    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _addEvent() {
    if (_titleController.text.isEmpty ||
        _startTimeController.text.isEmpty ||
        _endTimeController.text.isEmpty) return;

    final startTime = DateFormat('HH:mm').parse(_startTimeController.text);
    final endTime = DateFormat('HH:mm').parse(_endTimeController.text);

    if (startTime.isAfter(endTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('La hora de inicio no puede ser después de la de fin')),
      );
      return;
    }

    final event = Event(
      title: _titleController.text,
      startTime: DateTime(
        _selectedDay.year,
        _selectedDay.month,
        _selectedDay.day,
        startTime.hour,
        startTime.minute,
      ),
      endTime: DateTime(
        _selectedDay.year,
        _selectedDay.month,
        _selectedDay.day,
        endTime.hour,
        endTime.minute,
      ),
    );

    setState(() {
      if (_events[_selectedDay] != null) {
        _events[_selectedDay]!.add(event);
      } else {
        _events[_selectedDay] = [event];
      }
      _selectedEvents.value = _getEventsForDay(_selectedDay);
      _titleController.clear();
      _startTimeController.clear();
      _endTimeController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario de Eventos'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 01, 01),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedEvents.value = _getEventsForDay(selectedDay);
                });
              }
            },
            eventLoader: (day) {
              return _events[day] ?? [];
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.deepOrange,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              markersMaxCount: 1,
              markerDecoration: BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Título del Evento',
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _startTimeController,
              decoration: InputDecoration(
                labelText: 'Hora de Inicio (HH:mm)',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _endTimeController,
              decoration: InputDecoration(
                labelText: 'Hora de Fin (HH:mm)',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: _addEvent,
            child: Text('Agregar Evento'),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final event = value[index];
                    final startTimeFormatted = DateFormat('HH:mm').format(event.startTime);
                    final endTimeFormatted = DateFormat('HH:mm').format(event.endTime);

                    return ListTile(
                      title: Text(event.title),
                      subtitle: Text('$startTimeFormatted - $endTimeFormatted'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Event {
  final String title;
  final DateTime startTime;
  final DateTime endTime;

  Event({
    required this.title,
    required this.startTime,
    required this.endTime,
  });
}
