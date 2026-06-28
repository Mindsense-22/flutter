import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mindsense_app/core/Api/api_constants.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/features/community/logic/community_provider.dart';
import 'package:mindsense_app/features/community/models/community_model.dart';
import 'package:mindsense_app/features/community/ui/commnets_screen.dart';
import 'package:mindsense_app/features/community/ui/widgets/editpost_wid.dart';
import 'package:provider/provider.dart';

class PostshapeWid extends StatefulWidget {
  final FeedPost post;
  const PostshapeWid({super.key, required this.post});

  @override
  State<PostshapeWid> createState() => _PostshapeWidState();
}

class _PostshapeWidState extends State<PostshapeWid> {
  late int likeCounts;
  late int commentCounts;
  late int shareCount;
  late int saveCounts;
  var userid = "";
  bool isSaved=false;  
  bool isLiked=false;
  @override
  void initState() {
    super.initState();
    likeCounts = widget.post.reactions.length;
    commentCounts = widget.post.commentCount;
    shareCount = widget.post.shareCount;
    saveCounts = widget.post.savedBy.length;
    userid = SharedPreferencesitem.getString("userId") ?? "";
  }

  bool checkIsUserPost() {
    final authorId = widget.post.author is Map
        ? widget.post.author['_id'] as String?
        : widget.post.author as String?;
    return authorId == userid;
  }
  bool checkIsSaved(){    
   return widget.post.savedBy.contains(userid);
  }
  bool checkIsLikeed() {
    return widget.post.reactions.any(
      (reaction) => reaction.user == userid,
    );
  }

  String? _authorProfileImage() {
    if (widget.post.author is Map) {
      return (widget.post.author as Map)['profileImage'] as String?;
    }
    return widget.post.displayAuthor?.profileImage;
  }

  String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';

    if (diff.inDays < 2) return '${diff.inDays}d ago';

    return DateFormat('dd/MM/yyyy, hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final profileImage = _authorProfileImage();
    final displayName = widget.post.displayAuthor?.name ?? 'Anonymous';

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xff1E293B),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.post.visibility == "public"
              //||widget.post.visibility =="nickname" 
              &&
                      profileImage != null &&
                      profileImage.isNotEmpty
                  ? Container(
                      width: 45.w,
                      height: 45.w,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(108.r),
                      ),
                      child: CachedNetworkImage(
                        imageUrl:profileImage!=null? ApiConstants.baseUrl + profileImage:"https://drive.google.com/uc?export=download&id=1HQGGxju316dlVBAE5NkTzAa5drUkEZDm",
                        fit: BoxFit.fill,
                      ),
                    )
                  : Container(
                      width: 45.w,
                      height: 45.w,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(108.r),
                      ),
                      child: CircleAvatar(
                        backgroundColor: const Color(0xff334155),
                        child: Text(
                          (displayName.isNotEmpty ? displayName[0] : '?')
                              .toUpperCase(),
                          style: TextStyle(
                            color: const Color(0xff55EEDA),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        widget.post.type,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12.sp,
                        ),
                      ),
                      Text(
                        ", ${widget.post.visibility}",
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              checkIsUserPost()==false?
                TextButton(
                  onPressed: () {
                    context.read<CommunityProvider>().reportPost(context, widget.post.id);
                  },
                  child: Text(
                    "Report",
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ):              
              
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 24.sp,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: EditpostWid(post: widget.post),
                      ),
                    );
                  } else if (value == 'delete') {
                    context.read<CommunityProvider>().deletePost(context, widget.post.id);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20.sp),
                        SizedBox(width: 10.w),
                        Text(
                          'Edit Post',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          size: 20.sp,
                          color: Colors.red,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Delete Post',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )  
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(8.w),
            child: Text(
              widget.post.content,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.87),
                fontSize: 22.sp,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Spacer(),
              Text(
                overflow:TextOverflow.ellipsis,
                maxLines: 1, 
                timeAgo(widget.post.createdAt),
                style: TextStyle(color: Colors.grey[600], fontSize: 13.sp),
              ),
            ],
          ),
          SizedBox(height: 9.h,),
          
          Row(
            children: [
              //like button
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius:BorderRadius.circular(40.r)
                ),
                child: MaterialButton(
                  clipBehavior: Clip.hardEdge,
                  onPressed: isLiked||checkIsLikeed()
                ? null
                : () async {
                    await context
                        .read<CommunityProvider>()
                        .reaactPost(context, widget.post.id);

                    setState(() {
                      likeCounts++;
                      isLiked = true;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(isLiked||checkIsLikeed()?Icons.favorite:Icons.favorite_border, color: Colors.grey[600], size: 25.sp),
                      SizedBox(width: 5.w),
                      Text(
                        '$likeCounts',
                        style: TextStyle(color: Colors.grey[600], fontSize: 18.sp),
                      ),
                    ],
                  ),
                ),
              ),
              
              //comment button
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius:BorderRadius.circular(40.r)
                ),
                child: MaterialButton(
                  clipBehavior: Clip.hardEdge,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CommnetsScreen(),));
                  },
                  child: Row(
                    children: [
                      Icon(Icons.chat_bubble_outline, color: Colors.grey[600], size: 25.sp),
                      SizedBox(width: 5.w),
                      Text(
                        '$commentCounts',
                        style: TextStyle(color: Colors.grey[600], fontSize: 18.sp),
                      ),
                    ],
                  ),
                ),
              ),
              

              //share button
              Container(                
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius:BorderRadius.circular(40.r)
                ),
                child: MaterialButton(
                  clipBehavior: Clip.hardEdge,
                  onPressed: () {
                    context.read<CommunityProvider>().sharePost(context, widget.post.id);
                    setState(() {
                      shareCount++;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(Icons.share_outlined, color: Colors.grey, size: 25.sp),
                      SizedBox(width: 5.w),
                      Text(
                        '$shareCount',
                        style: TextStyle(color: Colors.grey, fontSize: 18.sp),
                      ),
                    ],
                  ),
                ),
              ),             

              //save button
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius:BorderRadius.circular(40.r)
                ),
                child: MaterialButton(
                  clipBehavior: Clip.hardEdge,
                  onPressed: isSaved||checkIsSaved()
                ? null
                : () async {
                    await context
                        .read<CommunityProvider>()
                        .savePost(context, widget.post.id);

                    setState(() {
                      saveCounts++;
                      isSaved = true;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(checkIsSaved()||isSaved?Icons.bookmark:Icons.bookmark_border, color: Colors.grey[600], size: 25.sp),
                      SizedBox(width: 5.w),
                      Text(
                        '$saveCounts',
                        style: TextStyle(color: Colors.grey[600], fontSize: 18.sp),
                      ),
                    ],
                  ),
                ),
              ), 
            ],
          ),
          
        ],
      ),
    );
  }
}
