import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../widgets/bubbly_title.dart';

class SettingsScreen extends StatefulWidget {
  final Player player;
  final VoidCallback onUpdate;

  const SettingsScreen({
    super.key,
    required this.player,
    required this.onUpdate,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _pseudoController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _pseudoController = TextEditingController(text: widget.player.pseudo);
  }

  @override
  void dispose() {
    _pseudoController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        widget.player.pseudo = _pseudoController.text;
      });
      widget.onUpdate();
    }
  }

  void _showPseudoInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Info Pseudo', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'Ton pseudo doit contenir 4 à 6 lettres suivies de 4 à 6 chiffres. Aucun caractère spécial autorisé.\nEx : LAPIN1234 ou CAT42',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Compris !', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00382B),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Doubled horizontal margin
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 110),
                const BubblyTitle(title: 'Paramètres'),
                const SizedBox(height: 25),

                // PSEUDO SECTION
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _pseudoController,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF004D40)),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'TON PSEUDO',
                            labelStyle: TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                            counterText: "",
                          ),
                          maxLength: 12,
                          onChanged: (val) => _saveSettings(),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Saisis un pseudo';
                            final reg = RegExp(r'^[a-zA-Z]{4,6}[0-9]{4,6}$');
                            if (!reg.hasMatch(value)) return '4-6 lettres puis 4-6 chiffres';
                            return null;
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.info_outline, color: Colors.blueGrey, size: 20),
                        onPressed: _showPseudoInfo,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // AVATAR SECTION
                _buildSectionTitle('TON AVATAR'),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAvatarOption('square', 'avatar_carre.png'),
                    _buildAvatarOption('triangle', 'avatar_triangle.png'),
                    _buildAvatarOption('diamond', 'avatar_losange.png'),
                    _buildAvatarOption('circle', 'avatar_rond.png'),
                  ],
                ),

                const SizedBox(height: 40),

                // SETTINGS CARDS
                _buildSettingCard(
                  icon: Icons.language,
                  label: 'Langue',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(widget.player.languageCode == 'fr' ? 'FR ' : 'EN '),
                        Text(widget.player.languageCode == 'fr' ? '🇫🇷' : '🇺🇸'),
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      widget.player.languageCode = widget.player.languageCode == 'fr' ? 'en' : 'fr';
                    });
                    widget.onUpdate();
                  },
                ),
                _buildSettingCard(
                  icon: Icons.volume_up,
                  label: 'Son',
                  trailing: Switch(
                    value: widget.player.sfxEnabled,
                    onChanged: (val) {
                      setState(() => widget.player.sfxEnabled = val);
                      widget.onUpdate();
                    },
                    activeColor: Colors.amber,
                  ),
                ),
                _buildSettingCard(
                  icon: Icons.music_note,
                  label: 'Musique',
                  trailing: Switch(
                    value: widget.player.musicEnabled,
                    onChanged: (val) {
                      setState(() => widget.player.musicEnabled = val);
                      widget.onUpdate();
                    },
                    activeColor: Colors.amber,
                  ),
                ),
                _buildSettingCard(
                  icon: Icons.vibration,
                  label: 'Vibrations',
                  trailing: Switch(
                    value: widget.player.vibrationsEnabled,
                    onChanged: (val) {
                      setState(() => widget.player.vibrationsEnabled = val);
                      widget.onUpdate();
                    },
                    activeColor: Colors.amber,
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: _buildSecondaryButton(
                        label: 'Confidentialité',
                        onTap: () {},
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildSecondaryButton(
                         label: 'Support client',
                         onTap: () {},
                         color: const Color(0xFF00A4EF),
                         icon: Icons.question_answer_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildAvatarOption(String id, String fileName) {
    bool isSelected = widget.player.avatarId == id;
    
    return GestureDetector(
      onTap: () {
        setState(() => widget.player.avatarId = id);
        widget.onUpdate();
      },
      child: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white10,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? Colors.amber : Colors.transparent, width: 3),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/images/avatars/$fileName',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingCard({required IconData icon, required String label, required Widget trailing, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
          border: Border.all(color: const Color(0xFF004D40), width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF00A4EF), size: 28),
            const SizedBox(width: 20),
            Text(
              label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF004D40)),
            ),
            const Spacer(),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({required String label, required VoidCallback onTap, required Color color, IconData? icon}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
