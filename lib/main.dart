import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const KhaerulBloombergTerminal());
}

class KhaerulBloombergTerminal extends StatelessWidget {
  const KhaerulBloombergTerminal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KHAERUL TERMINAL | PRO',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF050505),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          elevation: 0,
        ),
      ),
      home: const TerminalMainScreen(),
    );
  }
}

class NewsItem {
  final String id;
  final String title;
  final String source;
  final String impact;
  final DateTime timestamp;

  NewsItem({
    required this.id,
    required this.title,
    required this.source,
    required this.impact,
    required this.timestamp,
  });
}

class TerminalMainScreen extends StatefulWidget {
  const TerminalMainScreen({super.key});

  @override
  State<TerminalMainScreen> createState() => _TerminalMainScreenState();
}

class _TerminalMainScreenState extends State<TerminalMainScreen> {
  final List<String> categories = const [
    '💱 FOREX',
    '🥇 COMMODITY',
    '₿ CRYPTO',
    '🇮🇩 SAHAM',
    '💻 TECH',
    '🌐 MACRO'
  ];

  DateTime nextMajorNewsTime = DateTime.now().add(const Duration(minutes: 24, seconds: 50));
  String nextNewsTitle = "US CPI & Core Inflation Data (MoM/YoY)";
  
  late Timer _timer;
  Duration _timeLeft = Duration.zero;

  List<NewsItem> allNews = [];

  @override
  void initState() {
    super.initState();
    _loadInitialNews();
    _startTerminalEngines();
  }

  void _loadInitialNews() {
    final now = DateTime.now();
    
    allNews = [
      NewsItem(
        id: '1',
        title: 'FED Chairman Signals Potential Rate Cuts Ahead of FOMC Meeting',
        source: 'BLOOMBERG FAST',
        impact: 'HIGH',
        timestamp: now.subtract(const Duration(minutes: 15)),
      ),
      NewsItem(
        id: '2',
        title: 'XAU/USD Surges Past \$2,430 as Safe-Haven Demand Spikes',
        source: 'REUTERS WIRE',
        impact: 'HIGH',
        timestamp: now.subtract(const Duration(hours: 2)),
      ),
      NewsItem(
        id: '3',
        title: 'US Jobless Claims Fall to 228K vs 235K Expected',
        source: 'MARKETWATCH',
        impact: 'MEDIUM',
        timestamp: now.subtract(const Duration(hours: 14)),
      ),
      NewsItem(
        id: '4',
        title: 'Bank of Indonesia Keeps Benchmark Rate Steady at 6.25%',
        source: 'CNBC WIRE',
        impact: 'LOW',
        timestamp: now.subtract(const Duration(hours: 28)),
      ),
      NewsItem(
        id: '5',
        title: 'Outdated Market Analysis Data on Asian Currencies',
        source: 'OLD WIRE',
        impact: 'LOW',
        timestamp: now.subtract(const Duration(hours: 32)),
      ),
    ];

    _purgeExpiredNews();
  }

  void _startTerminalEngines() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final difference = nextMajorNewsTime.difference(now);

      setState(() {
        _timeLeft = difference.isNegative ? Duration.zero : difference;
        _purgeExpiredNews();
      });
    });
  }

  void _purgeExpiredNews() {
    final now = DateTime.now();
    allNews.removeWhere((item) {
      final ageInHours = now.difference(item.timestamp).inHours;
      return ageInHours >= 30;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    bool isWarning25Min = _timeLeft.inMinutes <= 25 && _timeLeft > Duration.zero;

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F141C),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: Colors.amber[700],
                child: const Text(
                  'BLOOMBERG MODE',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'KHAERUL TERMINAL',
                style: TextStyle(
                  fontWeight: FontWeight.black,
                  letterSpacing: 1.5,
                  color: Colors.greenAccent,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          actions: const [
            Center(
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Text(
                  'AUTO-PURGE: 30H 🧹',
                  style: TextStyle(color: Colors.orangeAccent, fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.amber,
            labelColor: Colors.amber,
            unselectedLabelColor: Colors.grey,
            tabs: categories.map((tab) => Tab(text: tab)).toList(),
          ),
        ),
        body: Column(
          children: [
            if (isWarning25Min)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: Colors.red[900],
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '⚠️ HIGH IMPACT NEWS ALERT (< 25 MINS)',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          Text(
                            '$nextNewsTitle Rilis dalam ${_formatDuration(_timeLeft)}',
                            style: const TextStyle(color: Colors.amberAccent, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: Text(
                        _formatDuration(_timeLeft),
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: 'monospace',
                        ),
                      ),
                    )
                  ],
                ),
              ),
            Container(
              height: 32,
              color: const Color(0xFF181D26),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  TickerItem(symbol: 'XAU/USD', price: '2,432.10', change: '+1.25%', isUp: true),
                  TickerItem(symbol: 'EUR/USD', price: '1.0892', change: '-0.15%', isUp: false),
                  TickerItem(symbol: 'BTC/USD', price: '64,120.00', change: '+3.40%', isUp: true),
                  TickerItem(symbol: 'USD/IDR', price: '15,850.00', change: '-0.05%', isUp: false),
                  TickerItem(symbol: 'US10Y', price: '3.89%', change: '-0.02%', isUp: false),
                  TickerItem(symbol: 'NVDA', price: '128.50', change: '+2.10%', isUp: true),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: categories.map((category) {
                  return NewsTerminalFeed(categoryName: category, newsList: allNews);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TickerItem extends StatelessWidget {
  final String symbol;
  final String price;
  final String change;
  final bool isUp;

  const TickerItem({
    super.key,
    required this.symbol,
    required this.price,
    required this.change,
    required this.isUp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Row(
        children: [
          Text(symbol, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11)),
          const SizedBox(width: 6),
          Text(price, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(width: 6),
          Text(
            change,
            style: TextStyle(
              color: isUp ? Colors.greenAccent : Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class NewsTerminalFeed extends StatelessWidget {
  final String categoryName;
  final List<NewsItem> newsList;

  const NewsTerminalFeed({
    super.key,
    required this.categoryName,
    required this.newsList,
  });

  String _formatTime(DateTime dt) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(dt.hour)}:${twoDigits(dt.minute)}:${twoDigits(dt.second)}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF090C10),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LIVE WIRE :: $categoryName',
                style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 1.1, fontSize: 11),
              ),
              Text(
                'ACTIVE ARTICLES: ${newsList.length} (MAX AGE: 30H)',
                style: const TextStyle(color: Colors.grey, fontSize: 10, fontFamily: 'monospace'),
              ),
            ],
          ),
          const Divider(color: Colors.amber, thickness: 0.5),
          Expanded(
            child: newsList.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada berita dalam 30 jam terakhir.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  )
                : ListView.builder(
                    itemCount: newsList.length,
                    itemBuilder: (context, index) {
                      final news = newsList[index];
                      final ageHours = DateTime.now().difference(news.timestamp).inHours;

                      return _buildNewsCard(
                        time: _formatTime(news.timestamp),
                        impact: news.impact,
                        title: news.title,
                        source: news.source,
                        ageHours: ageHours,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard({
    required String time,
    required String impact,
    required String title,
    required String source,
    required int ageHours,
  }) {
    Color impactColor = impact == 'HIGH'
        ? Colors.redAccent
        : (impact == 'MEDIUM' ? Colors.orangeAccent : Colors.blueAccent);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF11161D),
        borderRadius: BorderRadius.circular(4),
        border: Border(left: BorderSide(color: impactColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(time, style: const TextStyle(color: Colors.greenAccent, fontSize: 11, fontFamily: 'monospace')),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                color: impactColor.withOpacity(0.2),
                child: Text(
                  impact,
                  style: TextStyle(color: impactColor, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              Text('$source • ${ageHours}h ago', style: const TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
