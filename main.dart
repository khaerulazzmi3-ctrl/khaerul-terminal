<!DOCTYPE html>
<html>
<head>
<style>
  @page {
    size: A4;
    margin: 15mm 12mm;
    background-color: #0d1117;
  }
  body {
    margin: 0;
    padding: 0;
    font-family: 'Segoe UI', Arial, sans-serif;
    color: #c9d1d9;
    background-color: #0d1117;
    font-size: 10pt;
    line-height: 1.4;
  }
  *, *::before, *::after { box-sizing: border-box; }

  .header {
    background-color: #161b22;
    border-bottom: 2px solid #238636;
    padding: 15px;
    margin-bottom: 20px;
    border-radius: 6px;
  }
  h1 {
    color: #58a6ff;
    font-size: 18pt;
    margin: 0 0 5px 0;
  }
  .subtitle {
    color: #8b949e;
    font-size: 10pt;
  }
  h2 {
    color: #79c0ff;
    font-size: 13pt;
    border-left: 4px solid #238636;
    padding-left: 8px;
    margin-top: 20px;
    margin-bottom: 10px;
    page-break-after: avoid;
  }
  p { margin: 0 0 10px 0; }
  pre {
    background-color: #161b22;
    border: 1px solid #30363d;
    border-radius: 6px;
    padding: 10px;
    font-family: 'Consolas', 'Courier New', monospace;
    font-size: 8.5pt;
    color: #e6edf3;
    white-space: pre-wrap;
    word-break: break-all;
    margin: 10px 0;
  }
  .badge {
    display: inline-block;
    padding: 2px 6px;
    font-size: 8pt;
    font-weight: bold;
    border-radius: 4px;
    color: #ffffff;
  }
  .badge-red { background-color: #da3633; }
  .badge-green { background-color: #238636; }
</style>
</head>
<body>

<div class="header">
  <h1>⚡ khaerul-terminal (Mobile & PC Edition)</h1>
  <div class="subtitle">Panduan Kode Lengkap Project Cross-Platform Flutter</div>
</div>

<h2>1. File: pubspec.yaml</h2>
<p>Lokasi file di repository: <code>pubspec.yaml</code></p>
<pre>
name: khaerul_terminal
description: "Cross-Platform Real-Time News Terminal & Economic Calendar"
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 &lt;4.0.0'

dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
  intl: ^0.19.0
  shared_preferences: ^2.2.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
</pre>

<h2>2. File: lib/main.dart</h2>
<p>Lokasi file di repository: <code>lib/main.dart</code> <span class="badge badge-red">Penting: Wajib dalam folder lib/</span></p>
<pre>
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
  State&lt;TerminalDashboard&gt; createState() =&gt; _TerminalDashboardState();
}

class _TerminalDashboardState extends State&lt;TerminalDashboard&gt; with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // 6 Kategori Berita Filtered
  final List&lt;String&gt; _categories = [
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
          tabs: _categories.map((cat) =&gt; Tab(text: cat)).toList(),
        ),
      ),
      body: Column(
        children: [
          // Banner Peringatan Pre-News Alert (&lt; 25 Menit)
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
              children: _categories.map((cat) =&gt; NewsListView(category: cat)).toList(),
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
</pre>

<h2>3. File: .github/workflows/build.yml</h2>
<p>Lokasi file di repository: <code>.github/workflows/build.yml</code></p>
<pre>
name: Build Khaerul Terminal (APK & EXE)

on:
  push:
    branches: [ main ]

jobs:
  build-android:
    name: Build Android APK
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
      
      - name: Generate Android Native Folder
        run: |
          mkdir temp_app
          cd temp_app
          flutter create --org com.khaerul.terminal --project-name khaerul_terminal .
          cp -r android ../
          cd ..
          rm -rf temp_app

      - run: flutter pub get
      - run: flutter build apk --release --no-tree-shake-icons
      - uses: actions/upload-artifact@v4
        with:
          name: khaerul-terminal-android-apk
          path: build/app/outputs/flutter-apk/app-release.apk

  build-windows:
    name: Build Windows EXE
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
      
      - name: Generate Windows Native Folder
        run: |
          flutter config --enable-windows-desktop
          mkdir temp_app
          cd temp_app
          flutter create --org com.khaerul.terminal --project-name khaerul_terminal .
          xcopy /E /I /Y windows ..\windows
          cd ..
          rmdir /S /Q temp_app

      - run: flutter pub get
      - run: flutter build windows --release
      - uses: actions/upload-artifact@v4
        with:
          name: khaerul-terminal-windows-exe
          path: build/windows/x64/runner/Release/
</pre>

</body>
</html>
