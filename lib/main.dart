import 'package:flutter/material.dart';

void main() {
  runApp(const KhaerulTerminalApp());
}

class KhaerulTerminalApp extends StatelessWidget {
  const KhaerulTerminalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Khaerul Terminal',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF161B22),
          elevation: 0,
        ),
      ),
      home: const TerminalHomeScreen(),
    );
  }
}

class TerminalHomeScreen extends StatelessWidget {
  const TerminalHomeScreen({super.key});

  final List<String> tabs = const [
    '🔥 TERKINI',
    '📈 PASAR',
    '🌐 GLOBAL',
    '💡 POPULER',
    '🤖 AI & TECH',
    '⚡ KLIPIK'
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'KHAERUL TERMINAL',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.greenAccent,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.greenAccent),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.greenAccent,
            labelColor: Colors.greenAccent,
            unselectedLabelColor: Colors.grey,
            tabs: tabs.map((tab) => Tab(text: tab)).toList(),
          ),
        ),
        body: TabBarView(
          children: tabs.map((tabName) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.terminal, size: 72, color: Colors.greenAccent),
                  const SizedBox(height: 16),
                  Text(
                    'KHAERUL TERMINAL ONLINE',
                    style: TextStyle(
                      fontSize: 22, 
                      color: Colors.grey[200], 
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B22),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
                    ),
                    child: Text(
                      'Kategori: $tabName',
                      style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Status Server: Active 24/7 (Cloud Deployed)',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
