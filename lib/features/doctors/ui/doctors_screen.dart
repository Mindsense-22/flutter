import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mindsense_app/features/doctors/logic/doctors_provider.dart';

import 'package:mindsense_app/features/doctors/ui/widgets/doctor_card.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorsProvider>().getAllDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctors'),
        centerTitle: true,
      ),
      body: Consumer<DoctorsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.doctorsList.isEmpty) {
            return const Center(child: Text("No doctors found"));
          }
          return ListView.builder(
            itemCount: provider.doctorsList.length,
            itemBuilder: (context, index) {
              final doctor = provider.doctorsList[index];
              return DoctorCard(doctor: doctor);
            },
          );
        },
      ),
    );
  }
}