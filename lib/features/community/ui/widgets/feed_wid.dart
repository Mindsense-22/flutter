import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/community/logic/community_provider.dart';
import 'package:mindsense_app/features/community/ui/widgets/postshape_wid.dart';
import 'package:provider/provider.dart';

class FeedWid extends StatelessWidget {
  const FeedWid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityProvider>(
      builder: (context, val, _) {
        if (val.isFeedLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xff55EEDA)),
          );
        }

        if (val.error != null && val.feedPosts.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: Column(
                children: [
                  Icon(Icons.cloud_off_outlined, color: Colors.grey[600], size: 48.sp),
                  SizedBox(height: 12.h),
                  Text(
                    val.error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[500], fontSize: 13.sp),
                  ),
                ],
              ),
            ),
          );
        }

        if (val.feedPosts.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: Column(
                children: [
                  Icon(Icons.article_outlined, color: Colors.grey[600], size: 48.sp),
                  SizedBox(height: 12.h),
                  Text(
                    'No posts yet. Be the first to share!',
                    style: TextStyle(color: Colors.grey[500], fontSize: 13.sp),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics:  NeverScrollableScrollPhysics(),
          itemCount: val.feedPosts.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {            
            return PostshapeWid(post: val.feedPosts[index],);
          },
        );
      },
    );
  }
  
}
