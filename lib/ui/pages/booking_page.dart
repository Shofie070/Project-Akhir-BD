import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/console_model.dart';
import 'package:flutter_application_1/services/api_service.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

/// View-only version of booking page body (no Scaffold).
class BookingView extends StatefulWidget {
  const BookingView({super.key});

  @override
  State<BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _hoursController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final ApiService api = ApiService();

  double _calculateTotal() {
    final hours = double.tryParse(_hoursController.text) ?? 0;
    return hours * 50000;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final console = args is ConsoleModel ? args : null;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Text('Booking for: ${console?.jenisConsole ?? '-'} (${console?.nomorUnit ?? '-'})',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            Text('Customer Information', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter your name';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter your phone number';
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text('Booking Details', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (date != null) setState(() => _selectedDate = date);
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text('Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (time != null) setState(() => _selectedTime = time);
                    },
                    icon: const Icon(Icons.access_time),
                    label: Text('Time: ${_selectedTime.format(context)}'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _hoursController,
              decoration: const InputDecoration(
                labelText: 'Hours',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter rental duration';
                if (double.tryParse(value) == null) return 'Please enter a valid number';
                return null;
              },
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price Summary', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total'),
                      Text('Rp ${_calculateTotal().toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      String two(int v) => v.toString().padLeft(2, '0');
                      String formatDate(DateTime d) => '${d.year}-${two(d.month)}-${two(d.day)}';
                      String formatTime(int hour, int minute) => '${two(hour)}:${two(minute)}:00';

                      final hours = int.tryParse(_hoursController.text) ?? 1;
                      final startHour = _selectedTime.hour;
                      final startMinute = _selectedTime.minute;
                      final endHour = (startHour + hours) % 24;

                      final tanggal = formatDate(_selectedDate);
                      final jam_mulai = formatTime(startHour, startMinute);
                      final jam_selesai = formatTime(endHour, startMinute);

                      final customerId = api.currentUser?['id'] ?? 1; // fallback to test customer id=1 if not logged in
                      if (api.currentUser == null) {
                        // Inform the user we used a fallback id
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Menggunakan akun pengganti (guest) untuk demo')));
                      }

                      await api.createBooking({
                        'id_customer': customerId,
                        'id_room': console?.id,
                        'tanggal': tanggal,
                        'jam_mulai': jam_mulai,
                        'jam_selesai': jam_selesai,
                        'status': 'pending'
                      });

                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking berhasil dibuat!')));
                      Navigator.pop(context);
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
                    }
                  }
                },
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _hoursController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final ApiService api = ApiService();
  
  double _calculateTotal() {
    // Anggap harga per jam adalah 50000
    final hours = double.tryParse(_hoursController.text) ?? 0;
    return hours * 50000;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final console = args is ConsoleModel ? args : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Booking for: ${console?.jenisConsole ?? '-'} (${console?.nomorUnit ?? '-'})',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 24),
              
              // Customer Information
              Text('Customer Information', 
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Booking Details
              Text('Booking Details', 
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 30)),
                        );
                        if (date != null) {
                          setState(() => _selectedDate = date);
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: Text('Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (time != null) {
                          setState(() => _selectedTime = time);
                        }
                      },
                      icon: const Icon(Icons.access_time),
                      label: Text('Time: ${_selectedTime.format(context)}'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _hoursController,
                decoration: const InputDecoration(
                  labelText: 'Hours',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter rental duration';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {}),
              ),
              const SizedBox(height: 24),
              
              // Price Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price Summary', 
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total'),
                        Text(
                          'Rp ${_calculateTotal().toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Confirm Button
              ElevatedButton(
                onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        String two(int v) => v.toString().padLeft(2, '0');
                        String formatDate(DateTime d) => '${d.year}-${two(d.month)}-${two(d.day)}';
                        String formatTime(int hour, int minute) => '${two(hour)}:${two(minute)}:00';

                        final hours = int.tryParse(_hoursController.text) ?? 1;
                        final startHour = _selectedTime.hour;
                        final startMinute = _selectedTime.minute;
                        final endHour = (startHour + hours) % 24;

                        final tanggal = formatDate(_selectedDate);
                        final jam_mulai = formatTime(startHour, startMinute);
                        final jam_selesai = formatTime(endHour, startMinute);

                        final customerId = api.currentUser?['id'] ?? 1; // fallback to demo customer
                        if (api.currentUser == null) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Menggunakan akun pengganti (guest) untuk demo')));
                        }

                        await api.createBooking({
                          'id_customer': customerId,
                          'id_room': console?.id,
                          'tanggal': tanggal,
                          'jam_mulai': jam_mulai,
                          'jam_selesai': jam_selesai,
                          'status': 'pending'
                        });

                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Booking berhasil dibuat!')),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    }
                  },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Confirm Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
