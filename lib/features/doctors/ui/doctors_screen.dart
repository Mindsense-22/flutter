import 'package:flutter/material.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';
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
      Provider.of<ProfileScreenProvider>(context, listen: false)
        .fetchUserProfile();
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
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProfileScreenProvider>().fetchUserProfile();
                await context.read<DoctorsProvider>().getAllDoctors();
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                  const Center(child: Text("No doctors found")),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<ProfileScreenProvider>().fetchUserProfile();
              await context.read<DoctorsProvider>().getAllDoctors();
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: provider.doctorsList.length,
              itemBuilder: (context, index) {
                final doctor = provider.doctorsList[index];
                return DoctorCard(doctor: doctor);
              },
            ),
          );
        },
      ),
    );
  }
}