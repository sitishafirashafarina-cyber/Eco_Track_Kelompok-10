import 'package:flutter/material.dart';

void main() {
  runApp(const EcoTrackApp());
}

class EcoTrackApp extends StatelessWidget {
  const EcoTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoTrack',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F8F1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF328653),
        ),
      ),
      home: const EcoTrackHome(),
    );
  }
}

class EcoTrackHome extends StatefulWidget {
  const EcoTrackHome({super.key});

  @override
  State<EcoTrackHome> createState() => _EcoTrackHomeState();
}

class _EcoTrackHomeState extends State<EcoTrackHome> {
  int score = 85;
  int trees = 24;
  int selectedCard = -1;

  double dragX = 0;
  double dragY = 0;

  void tapCard(int index) {
    setState(() {
      selectedCard = index;
      score = score >= 100 ? 85 : score + 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Kartu berhasil disentuh! Skor: $score',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void longPressCard() {
    setState(() {
      trees++;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🌱 Aksi Ramah Lingkungan'),
        content: Text(
          'Kamu membuka informasi aktivitas '
          'lingkungan!\n\n'
          'Simulasi jumlah pohon: $trees pohon.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget statCard({
    required IconData icon,
    required String title,
    required String value,
    required int index,
  }) {
    final selected = selectedCard == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => tapCard(index),
        onLongPress: longPressCard,
        child: Card(
          elevation: selected ? 5 : 1,
          color: selected
              ? const Color(0xFFC5E8CE)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: const Color(0xFF328653)),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F8F1),
        title: const Text(
          'EcoTrack 🌿',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.eco, color: Color(0xFF328653)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Halo, Eco Hero! ',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Langkah kecil untuk bumi yang lebih baik.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // KARTU SKOR LINGKUNGAN
            Card(
              color: const Color(0xFF328653),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Skor Lingkungan',
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$score / 100',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Terus jaga bumi kita!',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.eco,
                      color: Colors.white,
                      size: 65,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Statistik Aktivitas',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // LAYOUT ROW DAN CARD
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                statCard(
                  icon: Icons.park,
                  title: 'Pohon',
                  value: '$trees',
                  index: 0,
                ),
                const SizedBox(width: 8),
                statCard(
                  icon: Icons.bolt,
                  title: 'Energi',
                  value: '12 kWh',
                  index: 1,
                ),
                const SizedBox(width: 8),
                statCard(
                  icon: Icons.water_drop,
                  title: 'Air',
                  value: '20 L',
                  index: 2,
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              'Aktivitas Hari Ini',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Sentuh, tekan lama, atau geser kartu!',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 12),

            // STACK DAN DRAG/PAN GESTURE
            LayoutBuilder(
              builder: (context, constraints) {
                final maxX =
                    (constraints.maxWidth - 240)
                        .clamp(0.0, double.infinity)
                        .toDouble();

                return Container(
                  height: 155,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3EFDF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: 12,
                        bottom: 10,
                        child: Icon(
                          Icons.eco,
                          size: 55,
                          color: Colors.green.withValues(alpha: 0.2),
                        ),
                      ),
                      Positioned(
                        left: dragX.clamp(0.0, maxX),
                        top: dragY.clamp(0.0, 20.0),
                        child: GestureDetector(
                          onTap: () => tapCard(3),
                          onLongPress: longPressCard,
                          onPanUpdate: (details) {
                            setState(() {
                              dragX = (dragX + details.delta.dx)
                                  .clamp(0.0, maxX);
                              dragY = (dragY + details.delta.dy)
                                  .clamp(0.0, 20.0);
                            });
                          },
                          child: SizedBox(
                            width: 240,
                            child: Card(
                              color: Colors.white,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(18),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.recycling,
                                          color: Color(0xFF328653),
                                          size: 30,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Eco Challenge',
                                            style: TextStyle(
                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Kurangi sampah plastik '
                                      'mulai hari ini!',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      '↔ Geser kartu ini',
                                      style: TextStyle(
                                        color: Color(0xFF328653),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
            Card(
              color: const Color(0xFFFFF3D8),
              child: const ListTile(
                leading: Icon(
                  Icons.lightbulb,
                  color: Colors.orange,
                ),
                title: Text(
                  'Tips Hari Ini',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Bawa botol minum sendiri untuk '
                  'mengurangi sampah plastik.',
                ),
              ),
            ),  

            const SizedBox(height: 18),
            const Center(
              child: Text(
                'EcoTrack • Small Actions, Big Impact ',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}