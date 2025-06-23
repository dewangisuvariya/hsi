import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/style_manager.dart';

// Display the UI of the column
class GenericListItem extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final List<String>? subtitles;
  final Widget? placeholder;

  const GenericListItem({
    Key? key,
    this.imageUrl,
    required this.title,
    this.subtitles,
    this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

  // display image
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

// custom widget
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
                child: Text(title, style: titleBarTextStyle),
              ),
              if (subtitle != null && subtitle!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  child: Text(subtitle!, style: subtitleofAboutHsiTextStyle),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(color: selectedDividerColor, thickness: 1),
              ),
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
