import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; 

class AppointmentPage extends StatefulWidget {
  final String? appointmentId;
  const AppointmentPage({super.key, this.appointmentId});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _motivoController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _loading = false;
  bool _isEditing = false; 

  @override
  void initState() {
    super.initState();
    if (widget.appointmentId != null) {
      _isEditing = true;
      _loadAppointmentData();
    }
  }

  Future<void> _loadAppointmentData() async {
    setState(() => _loading = true);
    try {
      final doc = await _firestore.collection('citas').doc(widget.appointmentId).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final DateTime fullDateTime = (data['fecha_hora_cita'] as Timestamp).toDate();
        setState(() {
          _motivoController.text = data['motivo_consulta'] ?? '';
          _selectedDate = fullDateTime;
          _selectedTime = TimeOfDay.fromDateTime(fullDateTime);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al cargar datos de la cita: $e")),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Future<void> _submitForm() async {
    final user = _auth.currentUser;
    if (user == null) { return; }
    if (_selectedDate == null || _selectedTime == null) { return; }
    if (_motivoController.text.trim().isEmpty) { return; }

    setState(() => _loading = true);

    final DateTime fullAppointmentDateTime = DateTime(
      _selectedDate!.year, _selectedDate!.month, _selectedDate!.day,
      _selectedTime!.hour, _selectedTime!.minute,
    );
    final Timestamp appointmentTimestamp = Timestamp.fromDate(fullAppointmentDateTime);

    try {
      if (_isEditing) {
        // --- Lógica de ACTUALIZAR (Update) ---
        await _firestore.collection('citas').doc(widget.appointmentId).update({
          'fecha_hora_cita': appointmentTimestamp,
          'motivo_consulta': _motivoController.text.trim(),
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Cita actualizada exitosamente")),
          );
        }
      } else {
        // --- Lógica de CREAR (Create) ---
        await _firestore.collection('citas').add({
          'id_paciente': user.uid,
          'email_paciente': user.email,
          'fecha_hora_cita': appointmentTimestamp,
          'motivo_consulta': _motivoController.text.trim(),
          'estado': 'programada',
          'id_medico': null,
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Cita agendada exitosamente")),
          );
        }
      }
      if (mounted) Navigator.pop(context); 

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al guardar la cita: $e")),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? "Editar Cita" : "Agendar Cita")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("1. Selecciona la fecha:", style: TextStyle(fontSize: 18)),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text(_selectedDate == null
                        ? "Toca para elegir..."
                        : DateFormat('d MMM yyyy', 'es').format(_selectedDate!)),
                    onTap: _pickDate,
                  ),
                  const Divider(),
                  const Text("2. Selecciona la hora:", style: TextStyle(fontSize: 18)),
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text(_selectedTime == null
                        ? "Toca para elegir..."
                        : _selectedTime!.format(context)),
                    onTap: _pickTime,
                  ),
                  const Divider(),
                  const Text("3. Motivo de la consulta:", style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _motivoController,
                    decoration: const InputDecoration(
                      labelText: "Describe tus síntomas o motivo",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(_isEditing ? "Actualizar Cita" : "Confirmar Cita"),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}