import 'package:flutter/material.dart';

void main() {
  runApp(const SurveyApp());
}

class _Motion {
  static const Duration fast = Duration(milliseconds: 180);
  static const Duration normal = Duration(milliseconds: 260);
}

class SurveyApp extends StatelessWidget {
  const SurveyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Survey App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      home: const AppStartFlow(),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: Colors.black,
      brightness: brightness,
    ).copyWith(
      primary: isDark ? const Color(0xFFF5F5F5) : const Color(0xFF111111),
      onPrimary: isDark ? const Color(0xFF111111) : Colors.white,
      secondary: isDark ? const Color(0xFFE5E5E5) : const Color(0xFF2A2A2A),
      onSecondary: isDark ? const Color(0xFF111111) : Colors.white,
      surface: isDark ? const Color(0xFF111111) : const Color(0xFFF9F9F9),
      onSurface: isDark ? const Color(0xFFF5F5F5) : const Color(0xFF121212),
      surfaceContainerHighest:
          isDark ? const Color(0xFF1F1F1F) : const Color(0xFFEDEDED),
      outline: isDark ? const Color(0xFF505050) : const Color(0xFFB8B8B8),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          isDark ? const Color(0xFF0C0C0C) : const Color(0xFFF3F3F3),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? const Color(0xFFEFEFEF) : const Color(0xFF1B1B1B),
        contentTextStyle: TextStyle(
          color: isDark ? const Color(0xFF161616) : Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.32)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.45)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.45)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class AppStartFlow extends StatefulWidget {
  const AppStartFlow({super.key});

  @override
  State<AppStartFlow> createState() => _AppStartFlowState();
}

class _AppStartFlowState extends State<AppStartFlow> {
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1700), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _showOnboarding = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 460),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: _showOnboarding
          ? OnboardingScreen(
        key: const ValueKey<String>('onboarding'),
        onGetStarted: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (_) => const SurveyFormScreen(),
            ),
          );
        },
      )
          : const SplashScreen(key: ValueKey<String>('splash')),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              scheme.surface,
              scheme.surfaceContainerHighest.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _FadeSlideIn(
                delay: const Duration(milliseconds: 60),
                child: Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.forum_rounded,
                    size: 42,
                    color: scheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _FadeSlideIn(
                delay: const Duration(milliseconds: 140),
                child: Text(
                  'Survey Studio',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _FadeSlideIn(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  'Thoughtful feedback starts here',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.72),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key, required this.onGetStarted});

  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final bool isCompact = MediaQuery
        .sizeOf(context)
        .width < 420;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              isCompact ? 16 : 22, 16, isCompact ? 16 : 22, 20),
          child: _FadeSlideIn(
            delay: const Duration(milliseconds: 80),
            beginOffset: const Offset(0, 0.025),
            child: Container(
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(34),
                border: Border.all(
                    color: scheme.outline.withValues(alpha: 0.32)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    isCompact ? 20 : 26, 24, isCompact ? 20 : 26, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _FadeSlideIn(
                      delay: const Duration(milliseconds: 130),
                      child: Text(
                        'Expand Your\nKnowledge !',
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _FadeSlideIn(
                      delay: const Duration(milliseconds: 180),
                      child: Text(
                        'Learn from every response and design better experiences.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.72),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _FadeSlideIn(
                      delay: const Duration(milliseconds: 220),
                      child: FilledButton.tonalIcon(
                        onPressed: onGetStarted,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(72, 42),
                          maximumSize: const Size(72, 42),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22)),
                        ),
                        icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                        label: const Text(''),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 3,
                      child: _FadeSlideIn(
                        delay: const Duration(milliseconds: 260),
                        child: Center(
                          child: Image.asset(
                            'lib/assets/hand-drawn-community-spirit-illustration.png',
                            fit: BoxFit.contain,
                            errorBuilder: (BuildContext context,
                                Object _,
                                StackTrace? _,) {
                              return Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: scheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Text(
                                  'Illustration not found in assets.',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _FadeSlideIn(
                      delay: const Duration(milliseconds: 300),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onGetStarted,
                          child: const Text('Get Started'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SurveyResponse {
  const SurveyResponse({
    required this.name,
    required this.feedback,
    required this.discoverySource,
    required this.improvements,
    required this.rating,
  });

  final String name;
  final String feedback;
  final String discoverySource;
  final List<String> improvements;
  final double rating;
}

class SurveyFormScreen extends StatefulWidget {
  const SurveyFormScreen({super.key});

  @override
  State<SurveyFormScreen> createState() => _SurveyFormScreenState();
}

class _SurveyFormScreenState extends State<SurveyFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  final FocusNode _feedbackFocusNode = FocusNode();

  String? _discoverySource;
  final Set<String> _selectedImprovements = <String>{};
  double _rating = 4;
  bool _isSubmitting = false;

  static const List<String> _discoveryOptions = <String>[
    'Friend or colleague',
    'Social media',
    'Online search',
    'Advertisement',
  ];

  static const List<String> _improvementOptions = <String>[
    'Design consistency',
    'App performance',
    'Feature clarity',
    'Support quality',
    'Pricing transparency',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _feedbackController.dispose();
    _feedbackFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    if (_discoverySource == null) {
      _showSnackBar('Please select how you discovered us.');
      return;
    }

    if (_selectedImprovements.isEmpty) {
      _showSnackBar('Choose at least one area to improve.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 280));
    if (!mounted) {
      return;
    }

    final SurveyResponse response = SurveyResponse(
      name: _nameController.text.trim(),
      feedback: _feedbackController.text.trim(),
      discoverySource: _discoverySource!,
      improvements: _selectedImprovements.toList()..sort(),
      rating: _rating,
    );

    setState(() {
      _isSubmitting = false;
    });

    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => SurveySummaryScreen(response: response),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final bool isCompact = MediaQuery.sizeOf(context).width < 480;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Feedback Survey'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              isCompact ? 16 : 24,
              14,
              isCompact ? 16 : 24,
              28,
            ),
            children: <Widget>[
              _FadeSlideIn(
                delay: const Duration(milliseconds: 40),
                child: _SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Tell us about your experience',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'A quick 1-minute survey to help us improve your next visit.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.78),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _FadeSlideIn(
                delay: const Duration(milliseconds: 70),
                child: _SectionCard(
                  title: 'Basic details',
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            _feedbackFocusNode.requestFocus(),
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          hintText: 'e.g. Alex Johnson',
                        ),
                        validator: (String? value) {
                          if (value == null || value
                              .trim()
                              .isEmpty) {
                            return 'Please enter your name.';
                          }
                          if (value
                              .trim()
                              .length < 2) {
                            return 'Name is too short.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _feedbackController,
                        focusNode: _feedbackFocusNode,
                        minLines: 4,
                        maxLines: 6,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) =>
                            FocusScope
                                .of(context)
                                .unfocus(),
                        decoration: const InputDecoration(
                          labelText: 'Open feedback',
                          hintText: 'Share what you liked and what could be better.',
                          alignLabelWithHint: true,
                        ),
                        validator: (String? value) {
                          if (value == null || value
                              .trim()
                              .isEmpty) {
                            return 'Feedback is required.';
                          }
                          if (value
                              .trim()
                              .length < 12) {
                            return 'Please write at least 12 characters.';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _FadeSlideIn(
                delay: const Duration(milliseconds: 100),
                child: _SectionCard(
                  title: 'How did you find us?',
                  subtitle: 'Choose one option',
                  child: RadioGroup<String>(
                    groupValue: _discoverySource,
                    onChanged: (String? value) {
                      setState(() {
                        _discoverySource = value;
                      });
                    },
                    child: Column(
                      children: _discoveryOptions.map((String option) {
                        return RadioListTile<String>(
                          value: option,
                          title: Text(option),
                          contentPadding: EdgeInsets.zero,
                          visualDensity: const VisualDensity(vertical: -1),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _FadeSlideIn(
                delay: const Duration(milliseconds: 130),
                child: _SectionCard(
                  title: 'Where should we improve?',
                  subtitle: 'Select all that apply',
                  child: Column(
                    children: _improvementOptions.map((String option) {
                      final bool selected = _selectedImprovements.contains(
                          option);
                      return CheckboxListTile(
                        value: selected,
                        title: Text(option),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(vertical: -1),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value ?? false) {
                              _selectedImprovements.add(option);
                            } else {
                              _selectedImprovements.remove(option);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _FadeSlideIn(
                delay: const Duration(milliseconds: 160),
                child: _SectionCard(
                  title: 'Overall rating',
                  subtitle: 'How would you rate your experience?',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: List<Widget>.generate(5, (int index) {
                          final int starNumber = index + 1;
                          final bool filled = _rating >= starNumber;
                          return IconButton(
                            onPressed: () {
                              setState(() {
                                _rating = starNumber.toDouble();
                              });
                            },
                            icon: AnimatedScale(
                              scale: filled ? 1.05 : 1,
                              duration: _Motion.fast,
                              child: Icon(
                                filled ? Icons.star_rounded : Icons
                                    .star_outline_rounded,
                              ),
                            ),
                            color: scheme.primary,
                            tooltip: '$starNumber stars',
                          );
                        }),
                      ),
                      Slider(
                        value: _rating,
                        min: 1,
                        max: 5,
                        divisions: 8,
                        label: _rating.toStringAsFixed(1),
                        onChanged: (double value) {
                          setState(() {
                            _rating = value;
                          });
                        },
                      ),
                      AnimatedSwitcher(
                        duration: _Motion.fast,
                        child: Align(
                          key: ValueKey<String>(_rating.toStringAsFixed(1)),
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${_rating.toStringAsFixed(1)} / 5.0',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _FadeSlideIn(
                delay: const Duration(milliseconds: 190),
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submit,
                  icon: AnimatedSwitcher(
                    duration: _Motion.fast,
                    child: _isSubmitting
                        ? const SizedBox(
                      key: ValueKey<String>('loading'),
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Icon(
                      Icons.send_rounded,
                      key: ValueKey<String>('send'),
                    ),
                  ),
                  label: AnimatedSwitcher(
                    duration: _Motion.fast,
                    child: Text(
                      _isSubmitting ? 'Submitting...' : 'Submit response',
                      key: ValueKey<bool>(_isSubmitting),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SurveySummaryScreen extends StatelessWidget {
  const SurveySummaryScreen({super.key, required this.response});

  final SurveyResponse response;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Summary'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: <Widget>[
          _FadeSlideIn(
            delay: const Duration(milliseconds: 50),
            child: _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Thank you, ${response.name}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your feedback has been captured successfully.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.76),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          _FadeSlideIn(
            delay: const Duration(milliseconds: 90),
            child: _SectionCard(
              title: 'Your responses',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _SummaryRow(label: 'Discovery source',
                      value: response.discoverySource),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    label: 'Improvement areas',
                    value: response.improvements.join(', '),
                  ),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    label: 'Overall rating',
                    value: '${response.rating.toStringAsFixed(1)} / 5.0',
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Open feedback',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    response.feedback,
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _FadeSlideIn(
            delay: const Duration(milliseconds: 130),
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.edit_rounded),
              label: const Text('Back to form'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.child,
    this.title,
    this.subtitle,
  });

  final String? title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (title != null) ...<Widget>[
              Text(
                title!,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subtitle != null) ...<Widget>[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.73),
                  ),
                ),
              ],
              const SizedBox(height: 12),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

class _FadeSlideIn extends StatefulWidget {
  const _FadeSlideIn({
    required this.child,
    this.delay = Duration.zero,
    this.beginOffset = const Offset(0, 0.012),
  });

  final Widget child;
  final Duration delay;
  final Offset beginOffset;

  @override
  State<_FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<_FadeSlideIn> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay, () {
      if (!mounted) {
        return;
      }
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: _visible ? Offset.zero : widget.beginOffset,
      duration: _Motion.normal,
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: _Motion.normal,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return RichText(
      text: TextSpan(
        style: theme.textTheme.bodyLarge,
        children: <TextSpan>[
          TextSpan(
            text: '$label: ',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.72),
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: value,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
