import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/level_model.dart';
import '../models/player_model.dart';
import '../widgets/level_node.dart';
import '../widgets/road_painter.dart';
import '../widgets/mascot_widget.dart';
import '../widgets/top_view_car.dart';
import '../services/utils/road_path_builder.dart';

class BoardGameScreen extends StatefulWidget {
  final Player player;

  const BoardGameScreen({super.key, required this.player});

  @override
  State<BoardGameScreen> createState() => _BoardGameScreenState();
}

class _BoardGameScreenState extends State<BoardGameScreen> with SingleTickerProviderStateMixin {
  late AnimationController _carController;
  late Animation<double> _carAnimation;
  double _carPositionPercentage = 0.0;
  double _carRotation = 0.0;
  Offset _carOffset = Offset.zero;
  
  double _startPercent = 0.0;
  double _targetPercent = 0.0;

  @override
  void initState() {
    super.initState();
    _carController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _carAnimation = CurvedAnimation(
      parent: _carController,
      curve: Curves.easeInOutCubic,
    );

    _carController.addListener(_updateCarPosition);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initCarPosition();
    });
  }

  void _initCarPosition() {
    if (widget.player.statsLevels.isEmpty) {
      _carPositionPercentage = 0.0;
    } else {
      int lastDone = widget.player.maxLevelUnlocked - 1;
      _carPositionPercentage = _getPercentForLevel(lastDone > 0 ? lastDone : 1);
    }
    _updatePositionFromPercent(_carPositionPercentage);
  }

  double _getPercentForLevel(int levelId) {
    double targetTop = 0.98 - ((levelId - 1) * 0.1);
    double targetY = 3600 * targetTop;
    return (4050 - targetY) / 4050;
  }

  void _updateCarPosition() {
    double currentPercent = _startPercent + (_targetPercent - _startPercent) * _carAnimation.value;
    _updatePositionFromPercent(currentPercent);
  }

  void _updatePositionFromPercent(double percent) {
    final size = Size(MediaQuery.of(context).size.width, 4000);
    final path = RoadPathBuilder.buildRoadPath(size);
    final metrics = path.computeMetrics().toList();
    
    if (metrics.isNotEmpty) {
      final metric = metrics.first;
      final distance = metric.length * percent.clamp(0.0, 1.0);
      final tangent = metric.getTangentForOffset(distance);
      
      if (tangent != null) {
        setState(() {
          _carOffset = tangent.position;
          _carRotation = -tangent.angle + (3.14159 / 2); 
        });
      }
    }
  }

  void _animateToLevel(int levelId) {
    _startPercent = _carPositionPercentage;
    _targetPercent = _getPercentForLevel(levelId);
    
    _carController.forward(from: 0.0).then((_) {
      _carPositionPercentage = _targetPercent;
      print('Arrived at level $levelId - Launching Quiz');
    });
  }

  @override
  void dispose() {
    _carController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<LevelStatus> levels = List.generate(10, (index) {
      int levelId = index + 1;
      LevelState state = LevelState.locked;
      int score = 0;

      if (widget.player.unlockedLevels.contains(levelId)) {
        state = widget.player.statsLevels.containsKey('level_$levelId') 
            ? LevelState.completed 
            : LevelState.available;
        score = widget.player.statsLevels['level_$levelId'] ?? 0;
      }

      return LevelStatus(
        id: levelId,
        state: state,
        score: score,
        isCurrent: levelId == widget.player.maxLevelUnlocked,
      );
    });

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF7CB342), 
                    Color(0xFF9CCC65), 
                    Color(0xFF8BC34A),
                  ],
                ),
              ),
            ),
          ),
          
          SingleChildScrollView(
            reverse: true,
            child: Container(
              height: 4000, 
              width: double.infinity,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                   Positioned.fill(
                     child: CustomPaint(
                       painter: RoadPainter(),
                     ),
                   ),

                   _buildDecor(context, Icons.park_rounded, Colors.green[900]!, left: 0.85, top: 0.96),
                   _buildDecor(context, Icons.home_rounded, Colors.brown[400]!, left: 0.1, top: 0.92),
                   
                   _buildMascot(context, MascotType.rondy, left: 0.85, top: 0.82),
                   _buildDecor(context, Icons.cottage_rounded, Colors.red[300]!, left: 0.15, top: 0.85),
                   
                   _buildDecor(context, Icons.forest_rounded, Colors.green[800]!, left: 0.88, top: 0.72),
                   _buildMascot(context, MascotType.carrevite, left: 0.1, top: 0.72),
                   
                   _buildDecor(context, Icons.home_work_rounded, Colors.blue[300]!, left: 0.85, top: 0.62),
                   
                   _buildDecor(context, Icons.park_outlined, Colors.green[700]!, left: 0.12, top: 0.54),
                   _buildDecor(context, Icons.castle_rounded, Colors.orange[300]!, left: 0.1, top: 0.38),
                   _buildMascot(context, MascotType.trigo, left: 0.9, top: 0.32),
                   
                   _buildDecor(context, Icons.church_rounded, Colors.grey[400]!, left: 0.75, top: 0.18),

                   _buildLevelPositioned(context, levels[0], left: 0.20, top: 0.98),
                   _buildLevelPositioned(context, levels[1], left: 0.80, top: 0.88),
                   _buildLevelPositioned(context, levels[2], left: 0.20, top: 0.78),
                   _buildLevelPositioned(context, levels[3], left: 0.80, top: 0.68),
                   _buildLevelPositioned(context, levels[4], left: 0.20, top: 0.58),
                   _buildLevelPositioned(context, levels[5], left: 0.80, top: 0.48),
                   _buildLevelPositioned(context, levels[6], left: 0.20, top: 0.38),
                   _buildLevelPositioned(context, levels[7], left: 0.80, top: 0.28),
                   _buildLevelPositioned(context, levels[8], left: 0.20, top: 0.18),
                   _buildLevelPositioned(context, levels[9], left: 0.80, top: 0.08),

                   Positioned(
                     left: _carOffset.dx - 15,
                     top: _carOffset.dy - 25,
                     child: Transform.rotate(
                       angle: _carRotation,
                       child: const TopViewCarWidget(size: 50),
                     ),
                   ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelPositioned(BuildContext context, LevelStatus level, {required double left, required double top}) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
      left: screenWidth * left - 50,
      top: 3600 * top, 
      child: LevelNode(
        level: level,
        onTap: () {
          _animateToLevel(level.id);
        },
      ),
    );
  }

  Widget _buildDecor(BuildContext context, IconData icon, Color color, {required double left, required double top}) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
      left: screenWidth * left - 20,
      top: 3600 * top,
      child: Icon(icon, color: color, size: 50),
    );
  }

  Widget _buildMascot(BuildContext context, MascotType type, {required double left, required double top}) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
      left: screenWidth * left - 30,
      top: 3600 * top,
      child: MascotWidget(type: type, size: 50),
    );
  }
}
