import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

const List<String> SUGGESTIONS = [
  'React',
  'Vue',
  'Angular',
  'Next.js',
  'Svelte',
  'TailwindCSS',
  'TypeScript',
  'JavaScript',
  'Node.js',
];

class PremiumSearchBar extends StatefulWidget {
  final String placeholder;
  final Function(String)? onSearch;

  const PremiumSearchBar({
    super.key,
    this.placeholder = 'Search...',
    this.onSearch,
  });

  @override
  State<PremiumSearchBar> createState() => _PremiumSearchBarState();
}

class _PremiumSearchBarState extends State<PremiumSearchBar> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  bool _isFocused = false;
  bool _isAnimating = false;
  List<String> _suggestions = [];

  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    _particleController.dispose();
    _hideOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (_isFocused) {
      _showOverlay();
    } else {
      // Delay to allow clicking suggestions
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _hideOverlay();
      });
    }
  }

  void _handleSearch(String value) {
    if (value.trim().isNotEmpty) {
      setState(() {
        _suggestions =
            SUGGESTIONS.where((item) => item.toLowerCase().contains(value.toLowerCase())).toList();
      });
      _showOverlay();
    } else {
      setState(() {
        _suggestions = [];
      });
      _hideOverlay();
    }
  }

  void _handleSubmit() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      widget.onSearch?.call(query);
      setState(() => _isAnimating = true);
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) setState(() => _isAnimating = false);
      });
      _focusNode.unfocus();
    }
  }

  void _showOverlay() {
    _hideOverlay();
    if (_suggestions.isEmpty || !_isFocused) return;

    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 340,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                    border: Border.all(
                      color: Theme.of(context).dividerColor.withOpacity(0.1),
                    ),
                  ),
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    shrinkWrap: true,
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = _suggestions[index];
                      return ListTile(
                        leading: Icon(
                          LucideIcons.circleDot,
                          size: 16,
                          color: Colors.purple.shade400,
                        ).animate().scale(delay: (index * 50).ms),
                        title: Text(
                          suggestion,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ).animate().fadeIn(delay: (index * 50).ms).moveX(begin: -5, end: 0),
                        onTap: () {
                          _controller.text = suggestion;
                          widget.onSearch?.call(suggestion);
                          _focusNode.unfocus();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hoverColor: Colors.purple.withOpacity(0.1),
                      );
                    },
                  ),
                ),
              ),
            ),
          ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.1, end: 0),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        width: _isFocused ? 340 : 240,
        transform: Matrix4.identity()..scale(_isFocused ? 1.05 : 1.0),
        transformAlignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              if (_isFocused)
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Stack(
                children: [
                  // Background/Border
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: _isFocused ? Colors.transparent : Colors.grey.withOpacity(0.3),
                      ),
                      color: _isFocused ? Colors.transparent : Colors.white.withOpacity(0.1),
                    ),
                  ),

                  // Animated Background Gradient
                  if (_isFocused)
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: _particleController,
                        builder: (context, child) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.yellow.withOpacity(0.1),
                                  Colors.orange.withOpacity(0.1),
                                  Colors.blue.withOpacity(0.1),
                                  Colors.green.withOpacity(0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [
                                  (math.sin(_particleController.value * 2 * math.pi) + 1) / 2,
                                  (math.cos(_particleController.value * 2 * math.pi) + 1) / 2,
                                  (math.sin(_particleController.value * math.pi) + 1) / 2,
                                  (math.cos(_particleController.value * math.pi) + 1) / 2,
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  // Particles
                  if (_isFocused)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: ParticlePainter(
                          animation: _particleController,
                        ),
                      ),
                    ),

                  // Input Content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.search,
                          size: 20,
                          color: _isAnimating
                              ? Colors.purple
                              : _isFocused
                                  ? Colors.purple.shade600
                                  : Colors.grey,
                        )
                            .animate(target: _isAnimating ? 1 : 0)
                            .shake(duration: 600.ms)
                            .scale(begin: const Offset(1, 1), end: const Offset(1.3, 1.3)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            onChanged: _handleSearch,
                            onSubmitted: (_) => _handleSubmit(),
                            decoration: InputDecoration(
                              hintText: widget.placeholder,
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (_controller.text.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: ElevatedButton(
                              onPressed: _handleSubmit,
                              style: ElevatedButton.styleFrom(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ).copyWith(
                                backgroundColor: WidgetStateProperty.resolveWith((states) => null),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Colors.purple, Colors.pink],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: const Text(
                                    'Search',
                                    style: TextStyle(color: Colors.white, fontSize: 13),
                                  ),
                                ),
                              ),
                            ).animate().fadeIn().scale(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final Animation<double> animation;
  final math.Random random = math.Random(42);

  ParticlePainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    for (int i = 0; i < 15; i++) {
      final t = (animation.value + (i / 15)) % 1.0;
      final x = size.width * (random.nextDouble() + 0.5 * math.cos(t * 2 * math.pi + i)) / 1.5;
      final y = size.height * (random.nextDouble() + 0.5 * math.sin(t * 2 * math.pi + i)) / 1.5;

      final opacity = 0.1 * math.sin(t * math.pi);
      paint.color = Colors.purple.withOpacity(opacity.clamp(0, 1));

      canvas.drawCircle(
        Offset(x, y),
        5 + 5 * math.sin(t * math.pi),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
