import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const appName = 'Realme Buds Tracker';
const userName = 'Naveen';
const deviceModel = 'Realme Air Buds 7';

const muted = Color(0xFF6B6B66);
const accent = Color(0xFF534AB7);

void main() => runApp(const BudsApp());

class BudsApp extends StatelessWidget {
  const BudsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: accent),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: accent, brightness: Brightness.dark),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/logo.svg', width: 44, height: 44,
                      semanticsLabel: '$appName logo'),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Hi $userName, welcome back',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                        Text('$appName · $deviceModel',
                            style: TextStyle(fontSize: 13, color: muted)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 0, label: Text('Dashboard')),
                  ButtonSegment(value: 1, label: Text('Buds')),
                  ButtonSegment(value: 2, label: Text('Analytics')),
                ],
                selected: {_index},
                onSelectionChanged: (s) => setState(() => _index = s.first),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: IndexedStack(
                  index: _index,
                  children: const [DashboardPage(), BudsPage(), AnalyticsPage()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final Color titleColor;
  final List<(String, String)> rows;

  const InfoCard({super.key, required this.title, required this.titleColor, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: titleColor, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            for (final (name, value) in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text(name, style: const TextStyle(color: muted)),
                    const Spacer(),
                    Flexible(child: Text(value, textAlign: TextAlign.right)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class StatTile extends StatelessWidget {
  final String title;
  final String value;
  final Color background;
  final Color foreground;

  const StatTile({
    super.key,
    required this.title,
    required this.value,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 13, color: foreground)),
          const SizedBox(height: 2),
          Text(value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: foreground)),
        ],
      ),
    );
  }
}

String fmtHms(int seconds) {
  final h = seconds ~/ 3600;
  final m = (seconds % 3600) ~/ 60;
  final s = seconds % 60;
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(h)}:${two(m)}:${two(s)}';
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _seconds = 2537; // placeholder session length
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() => _seconds++));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              const Text('Current session',
                  style: TextStyle(fontSize: 13, color: Color(0xFFEEEDFE))),
              Text(fmtHms(_seconds),
                  style: const TextStyle(
                      fontSize: 44, fontWeight: FontWeight.w500, color: Color(0xFFEEEDFE),
                      fontFeatures: [FontFeature.tabularFigures()])),
              const Text('Music, ANC on, AAC',
                  style: TextStyle(fontSize: 13, color: Color(0xFFEEEDFE))),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(child: StatTile(title: 'Left bud', value: '82%',
                background: Color(0xFFE1F5EE), foreground: Color(0xFF04342C))),
            SizedBox(width: 8),
            Expanded(child: StatTile(title: 'Right bud', value: '79%',
                background: Color(0xFFE1F5EE), foreground: Color(0xFF04342C))),
            SizedBox(width: 8),
            Expanded(child: StatTile(title: 'Case', value: '64%',
                background: Color(0xFFFAECE7), foreground: Color(0xFF4A1B0C))),
          ],
        ),
        const SizedBox(height: 12),
        const InfoCard(
          title: 'Status',
          titleColor: Color(0xFF3C3489),
          rows: [
            ('Wearing', 'Both in ear'),
            ('Connection', 'Strong'),
            ('ANC', 'On'),
            ('Codec', 'AAC'),
            ('Connected to', 'Phone, Laptop'),
          ],
        ),
      ],
    );
  }
}

class BudsPage extends StatelessWidget {
  const BudsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        InfoCard(title: 'Identity', titleColor: Color(0xFF0F6E56), rows: [
          ('Model', 'Realme Air Buds 7'),
          ('Firmware', 'Read from device'),
          ('Hardware revision', 'Read from device'),
          ('Serial', 'Read from device'),
          ('Manufacture date', 'Read from device'),
          ('Regulatory IDs', 'From the box'),
        ]),
        SizedBox(height: 12),
        InfoCard(title: 'Audio and connectivity', titleColor: Color(0xFF534AB7), rows: [
          ('Codecs', 'AAC, SBC, LHDC 5.0'),
          ('Bluetooth', '5.4'),
          ('Driver', '12.4 mm dynamic'),
          ('Mics for ANC', '6'),
          ('Dual device', 'Yes'),
          ('Game mode latency', '45 ms'),
          ('Fast Pair', 'Google, Swift Pair'),
        ]),
        SizedBox(height: 12),
        InfoCard(title: 'Noise control and touch', titleColor: Color(0xFF993556), rows: [
          ('ANC', 'Up to 52 dB'),
          ('Transparency', 'Yes, auto when one bud removed'),
          ('Double tap', 'Play or pause'),
          ('Triple tap', 'Next track'),
          ('Hold', 'Cycle ANC modes'),
        ]),
        SizedBox(height: 12),
        InfoCard(title: 'Sound and battery', titleColor: Color(0xFF854F0B), rows: [
          ('EQ presets', 'Serenade, Original, Pure Bass, Deep Bass'),
          ('Custom EQ', 'Yes, frequency sliders'),
          ('Bud battery', '62 mAh each'),
          ('Case battery', '480 mAh'),
          ('Water and dust', 'IP55'),
        ]),
        SizedBox(height: 12),
        Text('My notes', style: TextStyle(color: muted)),
        SizedBox(height: 6),
        TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Add a note about these buds',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const modes = [
      ('ANC', 33240, Color(0xFF7F77DD)),
      ('Transparency', 10920, Color(0xFF1D9E75)),
      ('Normal', 5820, Color(0xFFD85A30)),
    ];
    return ListView(
      children: [
        const Row(children: [
          Expanded(child: StatTile(title: 'ANC turned on', value: '41 times · 9h 14m',
              background: Color(0xFFEEEDFE), foreground: Color(0xFF26215C))),
          SizedBox(width: 8),
          Expanded(child: StatTile(title: 'Transparency on', value: '27 times · 3h 02m',
              background: Color(0xFFE1F5EE), foreground: Color(0xFF04342C))),
        ]),
        const SizedBox(height: 8),
        const Row(children: [
          Expanded(child: StatTile(title: 'ANC off (normal)', value: '18 times · 1h 37m',
              background: Color(0xFFFAECE7), foreground: Color(0xFF4A1B0C))),
          SizedBox(width: 8),
          Expanded(child: StatTile(title: 'Auto transparency', value: '6 times',
              background: Color(0xFFFBEAF0), foreground: Color(0xFF4B1528))),
        ]),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Time in each mode',
                    style: TextStyle(color: accent, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    height: 14,
                    child: Row(
                      children: [
                        for (final (_, secs, color) in modes)
                          Expanded(flex: secs, child: Container(color: color)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    for (final (name, _, color) in modes) ...[
                      Text(name, style: TextStyle(color: color)),
                      const SizedBox(width: 12),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text('Other things to track', style: TextStyle(color: muted)),
        const SizedBox(height: 8),
        const Wrap(spacing: 6, runSpacing: 6, children: [
          Chip(label: Text('Game mode time')),
          Chip(label: Text('Ear removals')),
          Chip(label: Text('Codec used')),
          Chip(label: Text('Battery drain per hour')),
          Chip(label: Text('Dual device switches')),
          Chip(label: Text('Case charge cycles')),
        ]),
      ],
    );
  }
}
