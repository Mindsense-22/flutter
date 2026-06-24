import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:mindsense_app/features/doctors/logic/doctors_provider.dart';
import 'package:mindsense_app/features/doctors/ui/widgets/doctor_card.dart';
import 'package:mindsense_app/features/doctors/ui/my_sessions_screen.dart';
import 'package:mindsense_app/core/styles/colors.dart';

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
      Provider.of<ProfileScreenProvider>(context, listen: false).fetchUserProfile();
      context.read<DoctorsProvider>().getAllDoctors();
      context.read<DoctorsProvider>().fetchMySessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Doctors',style: TextStyle(
          fontSize: 22.sp
        ),),
        centerTitle: true,
        actions: [
          Consumer<DoctorsProvider>(
            builder: (context, provider, _) {
              final count = provider.sessionsList.length;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon:  Icon(Icons.calendar_month_outlined,size: 25.sp,),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MySessionsScreen()),
                      );
                    },
                  ),
                  if (count > 0)
                    Positioned(
                      top: 8.h,
                      right: 6.w,
                      child: Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppColers.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(minWidth: 16.w, minHeight: 16.w),
                        child: Text(
                          count > 99 ? '99+' : '$count',
                          style: TextStyle(color: Colors.black, fontSize: 9.sp, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          SizedBox(width: 4.w),
        ],
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