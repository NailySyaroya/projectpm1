import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TextEditingController _noteController = TextEditingController();
  List<Reminder> reminderList = []; // Menyimpan daftar pengingat sebagai objek

  Future<void> _selectDateTime(BuildContext context) async {
    // Pilih tanggal
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });

      // Pilih waktu
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          selectedTime = pickedTime;
        });

        // Memunculkan dialog untuk menambahkan catatan
        _showAddNoteDialog(context);
      }
    }
  }

  // Menampilkan dialog untuk memasukkan catatan
  void _showAddNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tambahkan Catatan"),
          content: TextField(
            controller: _noteController,
            decoration: InputDecoration(hintText: "Masukkan catatan"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Simpan"),
              onPressed: () {
                setState(() {
                  reminderList.add(Reminder(
                    date: selectedDate!,
                    time: selectedTime!,
                    note: _noteController.text,
                  ));
                });
                _noteController.clear(); // Kosongkan text field setelah simpan
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengingat Tanggal'),
      ),
      body: Column(
        children: <Widget>[
          // Tombol untuk memilih tanggal dan waktu
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _selectDateTime(context),
              child: Text('Pilih Tanggal dan Waktu'),
            ),
          ),
          // Tampilkan pengingat dalam bentuk tabel
          reminderList.isEmpty
              ? Center(child: Text('Belum ada pengingat.'))
              : Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Tanggal')),
                  DataColumn(label: Text('Jam')),
                  DataColumn(label: Text('Noted')),
                ],
                rows: reminderList
                    .map(
                      (reminder) => DataRow(cells: [
                    DataCell(Text(reminder.getFormattedDate())),
                    DataCell(Text(reminder.getFormattedTime())),
                    DataCell(Text(reminder.note)),
                  ]),
                )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Model untuk menyimpan pengingat
class Reminder {
  DateTime date;
  TimeOfDay time;
  String note;

  Reminder({
    required this.date,
    required this.time,
    required this.note,
  });

  String getFormattedDate() {
    return "${date.year}-${date.month}-${date.day}";
  }

  String getFormattedTime() {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }
}