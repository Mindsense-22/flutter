import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/dashboard/logic/dashboard_provider.dart';
import 'package:mindsense_app/features/dashboard/modules/dashboarditems.dart';
import 'package:mindsense_app/features/dashboard/ui/widgets/yaxis_wid.dart';
import 'package:provider/provider.dart';

class DashboardWid extends StatelessWidget {
  final double? height;
  final double? width;

  const DashboardWid({Key? key, this.height, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return Container(
          height:345.h,
          width: double.infinity,          
          decoration: BoxDecoration(
            color:Colors.transparent,
            //color: Colors.red,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: provider.isLoading
              ? _buildLoadingState()
              : provider.dashboardItems.isEmpty
                  ? _buildEmptyState()
                  : _buildChartContent(context, provider),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2.w,
        valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF2dd4bf)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart_outlined, size: 48.r, color: Colors.grey),
          SizedBox(height: 16.h),
          Text(
            'No Data Available',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16.sp,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartContent(BuildContext context, DashboardProvider provider) {
    
    
    return Column(      
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 315.h,
              width: 21.w,
              child: YAxis(),
            ),
            SizedBox(width: 13.w,),
            SizedBox(
              height: 340.h,
              width: 306.w,
              child: Padding(
                padding: EdgeInsets.only(right: 0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  
                  children: List.generate(
                    provider.dashboardItems.length,
                    (index) => _buildBarColumn(
                      provider.dashboardItems[index],
                      10,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),        
      ],
    );
   
  }

  Widget _buildBarColumn(DashboardItems item, double maxValue) {
        
    return item.faceValue>item.voiceValue?
     Stack(
        children: [
          _buildSingleBar(
            value: item.faceValue,
            maxValue: maxValue,
            color: const Color(0xFF99f6e4),
            day: item.day
          ),        
          _buildSingleBar(
            value: item.voiceValue,
            maxValue: maxValue,
            color: const Color(0xFF2dd4bf),
            day: item.day
          ),
        ],
     ):
     Stack(
        children: [
          _buildSingleBar(
            value: item.voiceValue,
            maxValue: maxValue,
            color: const Color(0xFF2dd4bf),
            day: item.day
          ),
          _buildSingleBar(
            value: item.faceValue,
            maxValue: maxValue,
            color: const Color(0xFF99f6e4),
            day: item.day
          ),      
          
        ],
     );
  }

  Widget _buildSingleBar({
    required int value,
    required double maxValue,
    required Color color,
    required String day,
  }) {
    final barHeight = 315.h;
    final fillHeight = maxValue > 0 ? ((value/10) / maxValue) * barHeight : 0.0;    
    
    return Column(      
      spacing: 5.h,
      children: [
        Container(
          width: 14.w,
          height: barHeight,
          decoration: BoxDecoration(
            color: const Color.fromARGB(51, 19, 112, 123),
            borderRadius: BorderRadius.circular(8.r),
          ),
          alignment: Alignment.bottomCenter,
          child: value > 0
              ? Container(
                  width: 14.w,
                  height: fillHeight,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                )
              : const SizedBox.shrink(),
        ),

        Text(
          day,
          style: TextStyle(
            color: const Color(0xFFcecece),
            fontSize: 14.sp,
            fontWeight: FontWeight.w400
          ),
        ),        
      ],
    );
  }
}