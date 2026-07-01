import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindsense_app/core/Api/api_constants.dart';
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
  int numberOfFollowers=0;
  @override
  void initState() {
    super.initState();
    numberOfFollowers = widget.doctor.followers?.length ?? 0;
  }


  @override
  Widget build(BuildContext context) {
    var provider=context.watch<ProfileScreenProvider>();
    bool isFollowing=provider.followingIds.contains(widget.doctor.sId);
    
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
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              clipBehavior: Clip.antiAlias,
                              borderRadius: BorderRadius.circular(100.r),
                              child: CachedNetworkImage(
                                imageUrl: widget.doctor.profileImage != null && widget.doctor.profileImage!.isNotEmpty
                                    ? ApiConstants.baseUrl + widget.doctor.profileImage!
                                    : "https://drive.google.com/uc?export=download&id=1lOoHNvh57TJTcyV6hwAw4xHKsnCZcNYt",
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,                        
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) { 
                                  return CachedNetworkImage(
                                    imageUrl: "https://drive.google.com/uc?export=download&id=1lOoHNvh57TJTcyV6hwAw4xHKsnCZcNYt",
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
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
                        "$numberOfFollowers",
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
              if (isFollowing)
              
                Row(
                  children: [                    
                    Expanded(
                      child:Container(
                        height: 40.h,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColers.primaryColor,
                            width: 1.5.w
                          )
                        ),
                        child: MaterialButton(
                          onPressed: () {
                          log(provider.followingIds.toString());
                          log(widget.doctor.sId.toString());
                          doctorsprovider .unfollowButton(widget.doctor.sId,context);
                          setState(() {
                            isFollowing=false;
                            numberOfFollowers--;
                          });
                        },
                          child: Text("Unfollow",style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color:Theme.of(context).colorScheme.onSecondary
                          ),),
                        ),
                      )
                    
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child:Container(
                        height: 40.h,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: AppColers.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                          
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => BookingScreen(doctor: widget.doctor),));
                            log("d id ${widget.doctor.sId.toString()}");
                            
                          },
                          child: Text("Book Session",style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color:Theme.of(context).colorScheme.onPrimary
                          ),),
                        ),
                      )
                    
                    ),
                    
                  ],
                )
              else
                Container(
                  height: 40.h,
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: AppColers.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      doctorsprovider .followButton(widget.doctor.sId,context);
                      setState(() {
                        isFollowing=true;
                        numberOfFollowers=numberOfFollowers+1;
                      });
                    },
                    child: Text("Follow",style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w700,
                      color:Theme.of(context).colorScheme.onPrimary
                    ),),
                  ),
                ),                
                
            ],
          );
        }
      ),
    );
  }
}
