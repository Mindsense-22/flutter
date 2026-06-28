import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/Api/api_constants.dart';
import 'package:mindsense_app/features/community/ui/widgets/addpost_wid.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';
import 'package:provider/provider.dart';

class AddpostShape extends StatelessWidget {
  const AddpostShape({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileScreenProvider>(
      builder: (context,val,child) {
        return Row(
          children: [
            val.avatarLink == null || val.avatarLink!.isEmpty
            ?Container(
              width: 40.w,
              height: 40.w,
              clipBehavior: Clip.antiAlias,                    
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(108.r),
              ),
              child: CachedNetworkImage(
                imageUrl: "https://drive.google.com/uc?export=download&id=1HQGGxju316dlVBAE5NkTzAa5drUkEZDm",
                fit: BoxFit.fill,                    
              ),
            )
            :Container(
              width: 40.w,
              height: 40.w,
              clipBehavior: Clip.antiAlias,                    
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(108.r),
              ),
              child: CachedNetworkImage(
                imageUrl: ApiConstants.baseUrl + val.avatarLink!,
                fit: BoxFit.fill,                    
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: const AddpostWid(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: const Color(0xff1E293B),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Text(
                    "What's on your mind?",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}