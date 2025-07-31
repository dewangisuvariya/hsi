import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  State<CustomRefreshIndicator> createState() => _CustomRefreshIndicatorState();
}

class _CustomRefreshIndicatorState extends State<CustomRefreshIndicator> {
  bool _isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is OverscrollNotification &&
            notification.overscroll < -100 &&
            !_isRefreshing) {
          _handleRefresh();
          return true;
        }
        return false;
      },
      child: Stack(
        children: [
          widget.child,
          if (_isRefreshing)
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: LoadingAnimationWidget.discreteCircle(
                  color: Colors.blue,
                  size: 30,
                  secondRingColor: Colors.lightBlue,
                  thirdRingColor: Colors.blueAccent,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);
    await widget.onRefresh();
    if (mounted) {
      setState(() => _isRefreshing = false);
    }
  }
}
