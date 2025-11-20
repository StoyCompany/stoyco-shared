import 'package:flutter/material.dart';
import 'package:stoyco_shared/video/video_player_service.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/active_subscription_service.dart';

/// Example demonstrating automatic prefetching of next page.
///
/// This example shows how the video service automatically loads
/// the next page in the background, making pagination seamless.

class PrefetchingExampleScreen extends StatefulWidget {
  const PrefetchingExampleScreen({super.key});

  @override
  State<PrefetchingExampleScreen> createState() =>
      _PrefetchingExampleScreenState();
}

class _PrefetchingExampleScreenState extends State<PrefetchingExampleScreen> {
  late VideoPlayerService _videoService;
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 1;
  final int _pageSize = 20;
  final List<dynamic> _allVideos = [];
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();

    _videoService = VideoPlayerService(
      activeSubscriptionService: ActiveSubscriptionService.instance,
      userToken: 'your_token',
    );

    // Enable prefetching (enabled by default)
    _videoService.enablePrefetching = true;

    // Load initial page
    _loadPage(_currentPage);

    // Listen to scroll for pagination
    _scrollController.addListener(_onScroll);
  }

  /// Loads a specific page of videos.
  /// Next page is automatically prefetched in background!
  Future<void> _loadPage(int page) async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    final result = await _videoService.getVideosWithFilter(
      filterMode: 'Featured',
      page: page,
      pageSize: _pageSize,
      userId: 'user123',
    );

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $failure')),
        );
      },
      (videos) {
        setState(() {
          if (videos.isEmpty) {
            _hasMore = false;
          } else {
            _allVideos.addAll(videos);
            _currentPage = page;
          }
        });
      },
    );

    setState(() => _isLoading = false);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      // User scrolled 80% down, load next page
      // Next page should already be prefetched!
      _loadPage(_currentPage + 1);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Prefetching Example'),
          actions: [
            // Toggle prefetching
            IconButton(
              icon: Icon(
                _videoService.enablePrefetching
                    ? Icons.flash_on
                    : Icons.flash_off,
              ),
              onPressed: () {
                setState(() {
                  _videoService.enablePrefetching =
                      !_videoService.enablePrefetching;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _videoService.enablePrefetching
                          ? 'Prefetching enabled'
                          : 'Prefetching disabled',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Status indicator
            Container(
              padding: const EdgeInsets.all(8),
              color: _videoService.enablePrefetching
                  ? Colors.green.shade100
                  : Colors.grey.shade200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _videoService.enablePrefetching
                        ? Icons.rocket_launch
                        : Icons.hourglass_empty,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _videoService.enablePrefetching
                        ? 'Smart Prefetching: ON • Next page loads automatically'
                        : 'Prefetching: OFF • Manual loading only',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            // Video list
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _allVideos.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _allVideos.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  return ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text('Video ${index + 1}'),
                    subtitle: Text('Page ${(index ~/ _pageSize) + 1}'),
                    trailing: index >= (_currentPage - 1) * _pageSize &&
                            index < _currentPage * _pageSize
                        ? const Chip(
                            label: Text('Current'),
                            backgroundColor: Colors.blue,
                          )
                        : index >= _currentPage * _pageSize &&
                                index < (_currentPage + 1) * _pageSize
                            ? Chip(
                                label: Text(_videoService.enablePrefetching
                                    ? 'Prefetched'
                                    : 'Next'),
                                backgroundColor: _videoService.enablePrefetching
                                    ? Colors.green.shade200
                                    : Colors.grey.shade300,
                              )
                            : null,
                  );
                },
              ),
            ),

            // Info panel
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'How it works:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.download,
                    'When you load page 1, page 2 starts loading automatically',
                  ),
                  _buildInfoRow(
                    Icons.speed,
                    'When you scroll to page 2, it\'s already cached!',
                  ),
                  _buildInfoRow(
                    Icons.cached,
                    'Each page prefetches the next one in background',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Loaded: ${_allVideos.length} videos • Page: $_currentPage',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildInfoRow(IconData icon, String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
