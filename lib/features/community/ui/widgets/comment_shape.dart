import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindsense_app/core/Api/api_constants.dart';
import 'package:mindsense_app/features/community/models/community_model.dart';

class CommentShapeWidget extends StatelessWidget {
  final Comment comment;
  

  const CommentShapeWidget({
    super.key,
    required this.comment,  
  });

  @override
  Widget build(BuildContext context) {
    final String displayName = comment.displayAuthor?.name ?? 'Unknown User';

    String? imageUrl;
    final String? displayAuthorImage = comment.displayAuthor?.profileImage;
    if (displayAuthorImage != null && displayAuthorImage.isNotEmpty) {
      imageUrl = '${ApiConstants.baseUrl}$displayAuthorImage';
    } else if (comment.author != null && comment.author is Map<String, dynamic>) {
      final String? profilePath = comment.author['profileImage'];
      if (profilePath != null && profilePath.isNotEmpty) {
        imageUrl = '${ApiConstants.baseUrl}$profilePath';
      }
    }
    String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';

    if (diff.inDays < 2) return '${diff.inDays}d ago';

    return DateFormat('dd/MM/yyyy, hh:mm a').format(date);
  }
    final String formattedDate =timeAgo(comment.createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl, 
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 40,
                      height: 40,
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 40,
                      height: 40,
                      color: Colors.grey[300],
                      child: const Icon(Icons.person),
                    ),
                  )
                : Container(
                    width: 40,
                    height: 40,
                    color: Colors.grey[300],
                    child: const Icon(Icons.person),
                  ),
          ),
          
          const SizedBox(width: 12),

          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 6),
                
                Text(
                  comment.content,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.3, 
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}