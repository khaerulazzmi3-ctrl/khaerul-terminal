import 'package:flutter/material.dart';

void main() {
  runApp(const KhaerulTerminalApp());
}

class KhaerulTerminalApp extends StatelessWidget {
  const KhaerulTerminalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'khaerul-terminal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        cardColor: const Color(0xFF161B22),
        primaryColor: Colors.blueAccent,
      ),
      home: const TerminalDashboard(),
    );
  }
}

class TerminalDashboard extends StatefulWidget {
  const TerminalDashboard({super.key});

  @override
  State<TerminalDashboard> createState() => _TerminalDashboardState();
}

class _TerminalDashboardState extends State<TerminalDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // 6 Kategori Berita Filtered
  final List<String> _categories = [
    '🪙 Crypto',
    '💱 Forex',
    '🥇 Commodity',
    '💻 Teknology',
    '📈 Saham',
    '🌍 Macro Global'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text('⚡ KHAERUL TERMINAL v1.0 (WIB)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.greenAccent,
          tabs: _categories.map((cat) => Tab(text: cat)).toList(),
        ),
      ),
      body: Column(
        children: [
          // Banner Peringatan Pre-News Alert (< 25 Menit)
          Container(
            color: Colors.redAccent.withOpacity(0.2),
            padding: const EdgeInsets.all(12),
            child: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '⚠️ PRE-NEWS ALERT (H-25m): US CPI / Inflation Rate rilis jam 19:30 WIB | Forecast: 3.1% | Prev: 3.3%',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          
          // List Berita Berdasarkan Tab
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _categories.map((cat) => NewsListView(category: cat)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class NewsListView extends StatelessWidget {
  final String category;
  const NewsListView({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        NewsCard(
          title: 'Sampel Live News $category: Pergerakan Pasar Terkini',
          source: 'Ingestion Engine WIB',
          timeWIB: '11:55 WIB',
          impact: 'HIGH',
        ),
      ],
    );
  }
}

class NewsCard extends StatelessWidget {
  final String title;
  final String source;
  final String timeWIB;
  final String impact;

  const NewsCard({
    super.key,
    required this.title,
    required this.source,
    required this.timeWIB,
    required this.impact,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text('$source • $timeWIB', style: const TextStyle(color: Colors.grey, fontSize: 12)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: impact == 'HIGH' ? Colors.red : Colors.orange,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(impact, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
