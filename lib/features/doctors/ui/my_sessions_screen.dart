import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/doctors/logic/doctors_provider.dart';
import 'package:provider/provider.dart';

class MySessionsScreen extends StatefulWidget {
  const MySessionsScreen({super.key});

  @override
  State<MySessionsScreen> createState() => _MySessionsScreenState();
}

class _MySessionsScreenState extends State<MySessionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorsProvider>().fetchMySessions();
    });
  }

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return AppColers.primaryColor;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkThemeColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Sessions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 22.sp),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<DoctorsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingSessions) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.sessionsList.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => provider.fetchMySessions(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.35),
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.calendar_today_outlined, color: Colors.grey, size: 60.sp),
                        SizedBox(height: 16.h),
                        Text('No sessions yet', style: TextStyle(color: Colors.grey, fontSize: 16.sp)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => provider.fetchMySessions(),
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: provider.sessionsList.length,
              itemBuilder: (context, index) {
                final session = provider.sessionsList[index];
                final professional = session['professional'];
                final String? status = session['status'];
                final String? startTime = session['start_time'];
                final String? endTime = session['end_time'];
                final int? price = session['price'];
                final String? paymentMethod = session['payment_method'];

                String formatDate(String? isoDate) {
                  if (isoDate == null) return 'N/A';
                  try {
                    final dt = DateTime.parse(isoDate).toLocal();
                    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                  } catch (_) {
                    return isoDate;
                  }
                }

                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xff1E293B),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Doctor name + Status badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              professional?['name'] ?? 'Unknown Doctor',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: _statusColor(status).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(color: _statusColor(status)),
                            ),
                            child: Text(
                              status?.toUpperCase() ?? 'UNKNOWN',
                              style: TextStyle(
                                color: _statusColor(status),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // Time info
                      Row(
                        children: [
                          Icon(Icons.schedule, color: AppColers.primaryColor, size: 16.sp),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              'Start: ${formatDate(startTime)}',
                              style: TextStyle(color: Colors.grey[300], fontSize: 13.sp),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Icon(Icons.schedule_outlined, color: Colors.grey, size: 16.sp),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              'End:    ${formatDate(endTime)}',
                              style: TextStyle(color: Colors.grey[400], fontSize: 13.sp),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),

                      // Payment method
                      Row(
                        children: [
                          Text(
                            "${price.toString()} EGP"  ,
                            style: TextStyle(color: AppColers.primaryColor, fontSize: 13.sp),
                          ),
                          SizedBox(width: 6.w),
                          Icon(Icons.payment, color: Colors.blue, size: 16.sp),
                          SizedBox(width: 6.w),
                          Text(
                            paymentMethod ?? 'N/A',
                            style: TextStyle(color: Colors.grey[300], fontSize: 13.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
