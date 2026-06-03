import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindsense_app/core/Api/api_constants.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/features/doctors/logic/doctors_provider.dart';
import 'package:mindsense_app/features/doctors/modules/doctordetails.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/doctors/ui/booking_screen.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';
import 'package:provider/provider.dart';

class DoctorCard extends StatefulWidget {
  final DoctorDetails doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  @override
  Widget build(BuildContext context) {
    var provider=context.watch<ProfileScreenProvider>();
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: DarkThemeColors.backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Consumer<DoctorsProvider>(
        builder: (context,doctorsprovider,child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Name, Verified Icon, Followers
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            widget.doctor.profileImage!=null?
                            ClipRRect(
                              clipBehavior: Clip.antiAlias,
                              borderRadius: BorderRadius.circular(100.r),
                              child: CachedNetworkImage(
                                imageUrl: ApiConstants.baseUrl+widget.doctor.profileImage!,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,                        
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) {
                                  print("URL = $url");
                                  print("ERROR = $error");
                                  return ClipRRect(clipBehavior: Clip.antiAlias,
                                    borderRadius: BorderRadius.circular(100.r),child:  Icon(Icons.error, size: 40.sp));
                                },
                              ),
                            ):SizedBox.shrink(),
                            SizedBox(width: 8.w,),
                            Flexible(
                              child: Text(
                                widget.doctor.name ?? "Unknown",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (widget.doctor.isVerified == true) ...[
                              SizedBox(width: 8.w),
                              SvgPicture.asset(
                                "assets/images/correct_icon.svg",
                                width: 12.w,
                                height: 12.w,
                              ),
                            ],
                          ],
                        ),
                        if (widget.doctor.professionalProfile?.headline != null) ...[
                          SizedBox(height: 4.h),
                          Text(
                            widget.doctor.professionalProfile!.headline!,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[300],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${widget.doctor.followers?.length ?? 0}",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColers.primaryColor,
                        ),
                      ),
                      Text(
                        "Followers",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 6.h),
          
              // Bio
              Text(
                widget.doctor.professionalProfile?.bio ?? "No bio available.",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[400],
                ),
              ),
              SizedBox(height: 8.h),
              
              // Languages
              if (widget.doctor.professionalProfile?.languages?.isNotEmpty == true)
                Row(
                  children: [
                    Icon(Icons.language, color: Colors.grey, size: 16.sp),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        widget.doctor.professionalProfile!.languages!.join(", "),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[300],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 10.h),
          
              // Price & Availability
              Row(
                children: [              
                  Text(
                    "${widget.doctor.professionalProfile?.pricePerSession ?? 0} Egp / session",
                    style: TextStyle(color: AppColers.primaryColor, fontSize: 14.sp),
                  ),
                  SizedBox(width: 16.w),
                  Icon(Icons.access_time, color: Colors.blue, size: 18.sp),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      widget.doctor.professionalProfile?.availability?.isNotEmpty == true
                          ? widget.doctor.professionalProfile!.availability!.join(", ")
                          : "Availability not set",
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
          
              // Actions
              if (provider.followingIds.contains(widget.doctor.sId))
              
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          log(provider.followingIds.toString());
                          log(widget.doctor.sId.toString());
                          doctorsprovider .unfollowButton(widget.doctor.sId,context);
                        },
                        text: "Unfollow",
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => BookingScreen(doctor: widget.doctor),));
                          log("d id"+widget.doctor.sId.toString());
                        },
                        text: "Book",
                      ),
                    ),
                  ],
                )
              else
                CustomButton(
                  onPressed: () {
                    doctorsprovider .followButton(widget.doctor.sId,context);
                  },
                  text: "Follow",
                )
                
            ],
          );
        }
      ),
    );
  }
}
