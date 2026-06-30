import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/dashboard/logic/dashboard_provider.dart';
import 'package:mindsense_app/features/dashboard/ui/more_info_screen.dart';
import 'package:mindsense_app/features/dashboard/ui/widgets/dashboard_info_wid.dart';
import 'package:mindsense_app/features/dashboard/ui/widgets/dashboard_wid.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<DashboardProvider>();
      provider.fetchMainDashboard();
      if (provider.needsRefresh) {
        provider.fetchEmotionHistory();
        provider.fetchEmotionReport();
        provider.fetchMainDashboard();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider=context.watch<DashboardProvider>();
    return PopScope(      
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Dashboard",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
                color: Theme.of(context).colorScheme.onSecondary),
          ),
          centerTitle: true,
        ),
        body: provider.allDashboardLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => provider.refreshData(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 17.w),
                    child: Column(
                      children: [
                        const DashboardInfoWid(),
                        SizedBox(height: 20.h),
                        const DashboardWid(),                                    
                        SizedBox(height: 20.h),
                        MoreInfoScreen()
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
