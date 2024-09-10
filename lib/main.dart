import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data_service.dart';

// provider for the data
final dataProvider = FutureProvider<List<dynamic>>((ref) async {
  return await fetchData();
});

// search query
final searchQueryProvider = StateProvider<String>((ref) => '');

// filtering items based on the search query
final filteredItemsProvider = Provider<List<dynamic>>((ref) {
  final items = ref.watch(dataProvider).maybeWhen(
    data: (data) => data,
    orElse: () => [],
  );
  final query = ref.watch(searchQueryProvider);
  return items.where((item) {
    final name = item['name'].toString().toLowerCase();
    return name.contains(query);
  }).toList();
});

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Riverpod App',
      home: HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Searchable List'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                // Update the search query state
                ref.read(searchQueryProvider.notifier).state = value;
              },
              decoration: InputDecoration(
                hintText: 'Search...',
              ),
            ),
          ),
        ),
      ),
      body: asyncItems.when(
        data: (items) {
          final filteredItems = ref.watch(filteredItemsProvider);
          return ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              final item = filteredItems[index];
              return ListTile(
                title: Text(item['name']),
                subtitle: Text(item['cuisine']),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
