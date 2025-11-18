import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/video/video_player_service.dart';

/// Example of how to initialize and use the persistent video cache.
///
/// This example demonstrates:
/// 1. Initializing the cache at app startup
/// 2. Using the video service with automatic caching
/// 3. Handling pull-to-refresh with cache clearing
/// 4. Switching between tabs with cached results

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize persistent cache (do this once at app startup)
  final cacheDir = await getApplicationDocumentsDirectory();
  await VideoPlayerService.initializeCache(
    ttl: 300, // 5 minutes
    maxCacheSize: 100, // Maximum 100 cached queries
    cachePath: cacheDir.path,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Cache Example',
      home: const VideoFeedScreen(),
    );
  }
}

class VideoFeedScreen extends StatefulWidget {
  const VideoFeedScreen({super.key});

  @override
  State<VideoFeedScreen> createState() => _VideoFeedScreenState();
}

class _VideoFeedScreenState extends State<VideoFeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late VideoPlayerService _videoService;

  final List<String> _categories = ['Music', 'Sport', 'Brand'];
  String _contentMode = 'Featured'; // or 'ForYou'

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);

    // 2. Create video service (cache is already initialized)
    _videoService = VideoPlayerService(
      environment: StoycoEnvironment.development,
      userToken: 'your_user_token_here',
    );
  }

  /// Loads videos for a specific category.
  /// Results will be cached automatically to disk and memory.
  Future<List<dynamic>> _loadVideos(String category) async {
    final result = _contentMode == 'Featured'
        ? await _videoService.getFeaturedVideos(
            userId: 'user123',
            partnerProfile: category,
            page: 1,
            pageSize: 20,
          )
        : await _videoService.getVideosWithFilter(
            filterMode: 'ForYou',
            page: 1,
            pageSize: 20,
            userId: 'user123',
            partnerProfile: category,
          );

    return result.fold(
      (failure) {
        debugPrint('Error loading videos: $failure');
        return [];
      },
      (videos) => videos,
    );
  }

  /// Switches between Featured and For You content modes.
  /// Videos will be loaded from cache if available.
  void _switchContentMode(String mode) {
    setState(() {
      _contentMode = mode;
    });
  }

  /// Handles pull-to-refresh by clearing cache and reloading.
  Future<void> _onRefresh() async {
    // Clear all cached videos
    await _videoService.clearVideoCache();

    // Trigger rebuild - will fetch fresh data from backend
    setState(() {});
  }

  /// Clears cache for current filter only.
  Future<void> _clearCurrentFilter() async {
    await _videoService.clearVideoCacheForFilter(
      filterMode: _contentMode,
      userId: 'user123',
      partnerProfile: _categories[_tabController.index],
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos (with Persistent Cache)'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _categories.map((cat) => Tab(text: cat)).toList(),
          onTap: (_) {
            // Switching tabs will use cached results if available
            setState(() {});
          },
        ),
        actions: [
          // Button to clear current filter cache
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _clearCurrentFilter,
            tooltip: 'Refresh current filter',
          ),
        ],
      ),
      body: Column(
        children: [
          // Content mode selector (Featured / For You)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('Featured'),
                  selected: _contentMode == 'Featured',
                  onSelected: (selected) {
                    if (selected) _switchContentMode('Featured');
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('For You'),
                  selected: _contentMode == 'ForYou',
                  onSelected: (selected) {
                    if (selected) _switchContentMode('ForYou');
                  },
                ),
              ],
            ),
          ),

          // Video list with pull-to-refresh
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: TabBarView(
                controller: _tabController,
                children: _categories.map((category) {
                  return FutureBuilder<List<dynamic>>(
                    key: ValueKey('$_contentMode-$category'),
                    future: _loadVideos(category),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }

                      final videos = snapshot.data ?? [];

                      if (videos.isEmpty) {
                        return const Center(
                          child: Text('No videos available'),
                        );
                      }

                      return ListView.builder(
                        itemCount: videos.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.play_circle_outline),
                            title: Text('Video ${index + 1}'),
                            subtitle: Text('Category: $category'),
                            trailing: Chip(
                              label: Text(_contentMode),
                              backgroundColor: _contentMode == 'Featured'
                                  ? Colors.blue.shade100
                                  : Colors.green.shade100,
                            ),
                          );
                        },
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),

          // Cache info
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Videos cached to disk • Persists between sessions',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
