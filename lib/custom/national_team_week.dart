import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/style_manager.dart';

// Display the UI of the column or row based on screen width
class GenericListItem extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final List<String>? subtitles;
  final Widget? placeholder;
  final bool isWideLayout;

  const GenericListItem({
    Key? key,
    this.imageUrl,
    required this.title,
    this.subtitles,
    this.placeholder,
    this.isWideLayout = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isWideLayout) {
      // Wide layout (row)
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 44.w, height: 44.h, child: _buildImage()),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: titleOfCoachOrTeamTextStyle.copyWith(
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  if (subtitles != null)
                    ...subtitles!
                        .map(
                          (subtitle) => Text(
                            subtitle,
                            style: subtitleOfCoachOrTeamTextStyle.copyWith(
                              fontSize: 16.sp,
                            ),
                          ),
                        )
                        .toList(),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // Narrow layout (column)
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(width: 33.w, height: 33.h, child: _buildImage()),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: titleOfCoachOrTeamTextStyle),
                    SizedBox(height: 4.h),
                    if (subtitles != null)
                      ...subtitles!
                          .map(
                            (subtitle) => Text(
                              subtitle,
                              style: subtitleOfCoachOrTeamTextStyle,
                            ),
                          )
                          .toList(),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],
      );
    }
  }

  Widget _buildImage() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return placeholder ?? _defaultPlaceholder();
    }

    return Image.network(
      imageUrl!,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return placeholder ?? _defaultPlaceholder();
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(child: SizedBox.shrink());
      },
    );
  }

  Widget _defaultPlaceholder() {
    return Icon(Icons.person, size: 20.w, color: Colors.white);
  }
}

class UniversalListContainer extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final String? subtitle;

  const UniversalListContainer({
    Key? key,
    required this.title,
    required this.items,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: borderContainerDecoration,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  title,
                  style:
                      isWideScreen
                          ? titleBarTextStyle.copyWith(fontSize: 19.sp)
                          : titleBarTextStyle,
                ),
              ),
              if (subtitle != null && subtitle!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  child: Text(
                    subtitle!,
                    style:
                        isWideScreen
                            ? subtitleofAboutHsiTextStyle.copyWith(
                              fontSize: 17.sp,
                            )
                            : subtitleofAboutHsiTextStyle,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(color: selectedDividerColor, thickness: 1),
              ),
              if (isWideScreen)
                // Wide layout - items in a row
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing:
                        MediaQuery.of(context).size.width /
                        8.5, // Horizontal space between items
                    runSpacing: 20.0, // Vertical space between rows
                    children:
                        items
                            .map(
                              (item) => SizedBox(
                                width:
                                    MediaQuery.of(context).size.width /
                                    2.5, // Fixed width for each item
                                child: GenericListItem(
                                  imageUrl: item['imageUrl'],
                                  title: item['title'],
                                  subtitles: item['subtitles'],
                                  isWideLayout: true,
                                ),
                              ),
                            )
                            .toList(),
                  ),
                )
              else
                // Narrow layout - items in a column
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children:
                        items
                            .map(
                              (item) => GenericListItem(
                                imageUrl: item['imageUrl'],
                                title: item['title'],
                                subtitles: item['subtitles'],
                                isWideLayout: false,
                              ),
                            )
                            .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
